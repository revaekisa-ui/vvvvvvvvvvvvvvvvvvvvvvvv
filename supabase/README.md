# Supabase setup for this app

Follow these steps to provision the database, enable RLS, and seed mock data that matches the current app types.

Prerequisites:
- A Supabase project (get your Project URL and anon key)
- An auth user account (email/password) you will use to sign in from the app, so that RLS can identify `auth.uid()`

Steps:

1) Create .env.local
- Copy .env.example to .env.local, fill:
  - VITE_SUPABASE_URL
  - VITE_SUPABASE_ANON_KEY

2) Apply schema (tables + RLS policies)
- Open Supabase Dashboard > SQL > New query
- Paste contents of supabase/schema.sql
- Run it once

3) Find your auth user id (OWNER_UID)
- In Supabase Dashboard > Authentication > Users, click your user and copy the UUID (ID)
  Alternatively, run in SQL:
  ```sql
  select id, email from auth.users order by created_at desc;
  ```

4) Seed mock data
- Open supabase/seed.sql in an editor
- Replace all occurrences of 00000000-0000-0000-0000-000000000000 with your auth user UUID from step (3)
- In Supabase SQL editor, paste the updated seed and Run

5) (Optional) Relax RLS for public pages
- Jika Anda ingin pengunjung tanpa login dapat melihat paket/add-on/profil vendor di halaman publik, jalankan SQL berikut:
  - Buka Supabase Dashboard > SQL Editor > New query
  - Paste isi file: supabase/public_policies.sql
  - Run Query
  Ini akan membuat policy SELECT untuk role anon pada tables: packages, add_ons, profiles.

6) Start the app
- npm run dev
- Login as your auth user (you may need to swap the login UI to use Supabase Auth later). With the current setup, data is loaded from Supabase when VITE_SUPABASE_URL is set. Writes are not yet synchronized.

Notes:
- All tables include `owner_uid uuid default auth.uid()` and RLS that only allows the owner to read/write their rows.
- The schema uses snake_case column names; the frontend uses a small adapter to camelCase keys.
- Next steps (not included here):
  - Replace the custom Login component with Supabase Auth (email/password or OAuth), then wire session to the app
  - Replace setState mutations with direct Supabase inserts/updates (or a sync layer)

