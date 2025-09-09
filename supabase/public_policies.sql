-- Public read-only RLS policies for unauthenticated visitors (anon role)
-- Apply these if you want public pages (like PublicPackages) to work without login.

-- Packages
create policy if not exists "packages_public_select"
  on public.packages
  for select
  to anon
  using (true);

-- Add-ons
create policy if not exists "add_ons_public_select"
  on public.add_ons
  for select
  to anon
  using (true);

-- Vendor profile (basic public info)
create policy if not exists "profiles_public_select"
  on public.profiles
  for select
  to anon
  using (true);

