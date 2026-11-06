-- Supabase setup for Memecoin Radar. Run this in your own project SQL editor.
-- Never use a service_role or secret key in GitHub Pages.
create table if not exists public.radar_workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint workspace_json_object check (jsonb_typeof(data)='object'),
  constraint workspace_max_bytes check (octet_length(data::text) <= 750000)
);
alter table public.radar_workspaces enable row level security;
revoke all on public.radar_workspaces from anon;
grant select, insert, update on public.radar_workspaces to authenticated;
drop policy if exists "read_own_workspace" on public.radar_workspaces;
create policy "read_own_workspace" on public.radar_workspaces for select to authenticated
 using ((select auth.uid())=user_id);
drop policy if exists "create_own_workspace" on public.radar_workspaces;
create policy "create_own_workspace" on public.radar_workspaces for insert to authenticated
 with check ((select auth.uid())=user_id);
drop policy if exists "update_own_workspace" on public.radar_workspaces;
create policy "update_own_workspace" on public.radar_workspaces for update to authenticated
 using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
