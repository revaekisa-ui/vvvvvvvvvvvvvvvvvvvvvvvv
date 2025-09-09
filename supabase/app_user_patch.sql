begin;

-- Ensure your app user is Admin and matches your Supabase Auth user
insert into public.app_users (id, owner_uid, email, full_name, role, permissions, is_approved)
values (
  '1aaa40dd-8f46-4e8c-ac7d-879d718931a9',
  '1aaa40dd-8f46-4e8c-ac7d-879d718931a9',
  'nopianhadi2@gmail.com',
  'Nopian Hadi',
  'Admin',
  '{}',
  true
)
on conflict (id) do update set
  owner_uid = excluded.owner_uid,
  email = excluded.email,
  full_name = excluded.full_name,
  role = excluded.role,
  permissions = excluded.permissions,
  is_approved = excluded.is_approved;

-- Optional: align vendor profile email
update public.profiles
   set email = 'nopianhadi2@gmail.com'
 where owner_uid = '1aaa40dd-8f46-4e8c-ac7d-879d718931a9';

commit;
