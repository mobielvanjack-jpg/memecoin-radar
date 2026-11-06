# Memecoin Radar v1.4

A static, mobile-friendly memecoin research dashboard with a separate virtual-money educational trading simulator. **Not a broker, trading bot, coin-ranking service, or investment recommendation.** It sends no trades, holds no funds, and never requests wallet passwords or recovery phrases.

Live site: https://mobielvanjack-jpg.github.io/memecoin-radar/

Paper Lab: https://mobielvanjack-jpg.github.io/memecoin-radar/paper.html

## Paper Lab (v1.4)

The `paper.html` page is a **virtual-money-only simulator**. It starts each browser with $100 in fictional funds and supports token lookup by symbol or address, simulated purchases and sales, a virtual portfolio, weighted-average cost basis, realized P&L, fees, modeled pool impact, and export/reset of the virtual session. It does not connect to wallets or submit transactions.

- Token quotes and selected-pool liquidity are fetched from DEX Screener, and simulated orders require a recently refreshed quote (under 2 minutes old).
- Quotes use a simplified **constant-product (x*y=k)** model assuming USD pool liquidity is split evenly between the two sides. It is **not an executable quote**, especially for concentrated-liquidity and other non-constant-product pools. The real price, platform fees, and realized sale value may differ widely.
- The model defaults to $0.10 fixed fee, 0.30% variable fee, and $2 minimum simulated gross sale; all three are **configurable illustrations**, not verified FOMO fees.
- Positions below the modeled minimum sale show that their cash value is unavailable for modeled liquidation. The chart-style value remains separately visible.
- All paper balances, history, and assumptions are stored **locally in the browser** under `mr-paper-v1`. This data is separate from watchlist and journal data and **does not sync** with optional cloud accounts.
- It is an educational simulation rather than a trading recommendation, performance predictor, or guarantee of profits.


## What's new

- **Research Lab** with source-labelled, expandable checks: selected-pool liquidity relative to circulating market cap, 24h turnover relative to liquidity, FDV/circulating-cap gap, pair age, 24h price volatility, buy/sell *transaction counts*, paid boosts, provider disagreement, and pool discovery coverage. There is deliberately **no composite buy score** or token ranking.
- **Side-by-side comparison** of watched tokens using the same formulas; missing values are explicitly labelled.
- **News Desk** uses the GDELT 2.0 ArticleList API in the browser to retrieve real indexed article URLs and date metadata, and only displays articles whose titles contain a tracked token name or ticker. It labels these as **keyword matches**, not proof of token identity or price impact. A broader Google News link is provided when article indexing fails or matches are absent.
- **Account & Sync interface** with secure optional passwordless email authentication, data restoration/back-up choice, and per-user cloud workspace structure. **Not enabled until a Supabase project has been configured**, see below. Until then, the website explicitly says sign-in is unavailable; it never simulates successful sign-in.
- The original token explorer, watchlist, research journal, light/dark theme, exports, token-specific pool discovery, provider comparison, and 60-second foreground price refresh remain.

## Data handling and limits

- DEX Screener API: token search, pools, price, trading activity, and boost indicators. Market-cap reporting can be provider-specific and should not be silently substituted with FDV.
- GeckoTerminal API: independent reported token cap/FDV and its own indexed pool list. **Never sum liquidity totals across providers**: their pool inventories may overlap and may not be exhaustive.
- GDELT DOC 2.0: recent news article search. Publication date is not always confirmed; the UI shows when GDELT indexed an item. Some token names and tickers are common words. Keyword coincidence and news-market causality are **not established** by these results.
- All source requests are client-side from the visitor's browser. APIs can fail due to CORS, quotas, rate limits, connectivity, or coverage. Metrics may be delayed.
- Selected-pool liquidity is **not** the total value a trader can redeem. Volume can include wash activity; buy/sell counts are not dollar-weighted flows. Pool age is not token launch date.
- This app does not currently verify holder concentration, contract permissions, insiders, lockups, audits, token distributions, or smart contract safety. Never imply they were checked.

## Hosting and updates

GitHub Pages builds the public site from the `main` branch root. Commit a changed `index.html` (currently self-contained for one-file deployment), wait for Pages to deploy, then refresh the **same** URL. Users do not need to download an HTML file each version. Browser cache may take a moment to refresh.

The watchlist and journal are stored in localStorage (`memecoin-radar-v1`), preserving previous v1.x data when someone uses the **same domain and browser**. The old downloaded `content://` or `file://` app uses different browser storage; export a JSON backup from its Journal and import on the hosted site if needed.

## Enable real accounts (operator action required)

Accounts cannot be securely implemented by a standalone GitHub Pages file. The public `index.html` intentionally embeds an empty `window.MR_CLOUD_CONFIG` object. **Do not claim account creation or cross-device sync works until these steps pass testing.**

1. Create a project at https://supabase.com/ (with appropriate privacy and moderation settings for a public app).
2. In Supabase **SQL Editor**, execute `supabase-schema.sql`. This creates the `radar_workspaces` table with Row Level Security, granting users access only to their own row. Verify the table/policies in the dashboard.
3. In Supabase **Authentication → URL Configuration**, set **Site URL** to `https://mobielvanjack-jpg.github.io/memecoin-radar/` and add the same address to **Redirect URLs**.
4. Enable email authentication (the code uses Supabase `signInWithOtp` with `shouldCreateUser: true`; first-time users get account creation through an email verification link). Configure email sending/rate limits and abuse controls before inviting the public.
5. In `index.html`, locate `window.MR_CLOUD_CONFIG` and fill `url` with `https://<project-ref>.supabase.co` and `publishableKey` with the **public** `sb_publishable_...` key. The publishable key is designed to be visible to web visitors. **NEVER add a Supabase secret key, service_role key, privileged password, or database connection string to any public repository.**
6. Publish changes and test sign-in and user-data isolation with **two separate test accounts**, then test cross-device backup and restore with non-sensitive test notes.
7. Review your privacy policy, content policy, consent/age-appropriate protections, deletion process, and domain security before activating public registration.

After real accounts have been enabled and tested, the user **explicitly chooses** whether to restore cloud data onto this device or back up this device to the cloud. Neither side is overwritten automatically during initial setup. After the user chooses, changes in this signed-in browser are backed up with a short debounce. This is a simple last-write-wins sync, **not a conflict-free multi-device merge**: do not edit different devices simultaneously. Export JSON backups regularly.

## Development and testing

- The deployed `index.html` and `paper.html` are standalone HTML files. During development the JavaScript modules passed syntax checks and their deterministic formulas passed local unit tests; those test harness files are not included in this production repository.
- Browser smoke tests used a 393px viewport with mocked DEX Screener, GeckoTerminal, and GDELT responses to check token search, watchlist additions, research checks, comparison, news filter, account-unconfigured state, and theme switching. Live provider uptime and actual Supabase login were **not** validated. No real market data is included in mocks.

- Paper Lab: JavaScript syntax and deterministic fee/constant-product scenarios were checked; a live mobile-browser integration test and real provider connectivity remain unverified.

## Source docs

- https://docs.dexscreener.com/api/reference
- https://apiguide.geckoterminal.com/
- https://blog.gdeltproject.org/gdelt-doc-2-0-api-debuts/
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://supabase.com/docs/guides/auth/auth-email-passwordless
- https://supabase.com/docs/guides/getting-started/api-keys