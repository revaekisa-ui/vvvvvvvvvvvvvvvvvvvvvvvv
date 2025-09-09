-- Admin helper + policies
-- Creates a SECURITY DEFINER function to safely check if a user is an Admin
-- and a policy that allows Admin users to SELECT all rows from public.app_users.

-- Note: This function is SECURITY DEFINER so the check can bypass RLS on public.app_users
-- and avoid circular RLS evaluation. After applying, run this in your Supabase SQL editor.

create or replace function public.is_app_admin(uid uuid)
returns boolean
language sql
stable
security definer
as $$
  select exists(
    select 1 from public.app_users where id = uid and role = 'Admin'
  );
$$;

create policy "app_users_admin_select"
  on public.app_users
  for select
  to authenticated
  using (
    public.is_app_admin(auth.uid())
  );
