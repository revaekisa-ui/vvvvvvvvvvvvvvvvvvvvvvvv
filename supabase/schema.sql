-- Supabase schema for Vena Pictures dashboard
-- This schema maps to the TypeScript interfaces in types.ts and constants.tsx
-- NOTE: Multi-tenant simplified: each row has owner_uid (UUID) that must equal auth.uid() via RLS
-- For public pages, you may later relax SELECT policies on certain tables (e.g., packages)

-- Enable extensions (safe-noop if already enabled)
create extension if not exists pgcrypto;

-- Common updated_at trigger
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ENUM-like checks via CHECK constraints (keep types flexible as TEXT)
-- You can convert to real Postgres ENUMs if you prefer strictness

-- Profiles (vendor profile)
create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  owner_uid uuid not null default auth.uid(), -- the admin user who owns this vendor profile

  full_name text not null,
  email text not null,
  phone text not null,
  company_name text not null,
  website text,
  address text,
  bank_account text,
  authorized_signer text,
  id_number text,
  bio text,
  income_categories text[] not null default '{}',
  expense_categories text[] not null default '{}',
  project_types text[] not null default '{}',
  event_types text[] not null default '{}',
  asset_categories text[] not null default '{}',
  sop_categories text[] not null default '{}',
  package_categories text[] not null default '{}',
  project_status_config jsonb not null default '[]',
  notification_settings jsonb not null default '{"newProject":true,"paymentConfirmation":true,"deadlineReminder":true}',
  security_settings jsonb not null default '{"twoFactorEnabled":false}',
  briefing_template text,
  terms_and_conditions text,
  contract_template text,
  logo_base64 text,
  brand_color text,
  public_page_config jsonb not null default '{"template":"classic","title":"","introduction":"","galleryImages":[]}',
  package_share_template text,
  booking_form_template text,
  chat_templates jsonb not null default '[]',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_profiles_updated_at
before update on public.profiles
for each row execute procedure public.handle_updated_at();

alter table public.profiles enable row level security;
create policy "profiles_owner_all"
  on public.profiles
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- App users (metadata for roles/permissions; authentication handled by auth.users)
create table if not exists public.app_users (
  id uuid primary key, -- matches auth.users.id
  owner_uid uuid not null default auth.uid(),
  email text not null,
  full_name text not null,
  role text not null check (role in ('Admin','Member')),
  permissions text[] not null default '{}',
  is_approved boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_app_users_updated_at
before update on public.app_users
for each row execute procedure public.handle_updated_at();

alter table public.app_users enable row level security;
create policy "app_users_owner_all"
  on public.app_users
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Clients
create table if not exists public.clients (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  email text,
  phone text,
  whatsapp text,
  since date,
  instagram text,
  status text not null check (status in ('Prospek','Aktif','Tidak Aktif','Hilang')),
  client_type text not null check (client_type in ('Langsung','Vendor')),
  last_contact timestamptz,
  portal_access_id text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_clients_updated_at
before update on public.clients
for each row execute procedure public.handle_updated_at();

alter table public.clients enable row level security;
create policy "clients_owner_all"
  on public.clients
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Team members
create table if not exists public.team_members (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  role text not null,
  email text,
  phone text,
  standard_fee numeric not null default 0,
  norek text,
  reward_balance numeric not null default 0,
  rating numeric not null default 0,
  performance_notes jsonb not null default '[]',
  portal_access_id text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_team_members_updated_at
before update on public.team_members
for each row execute procedure public.handle_updated_at();

alter table public.team_members enable row level security;
create policy "team_members_owner_all"
  on public.team_members
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Packages and Add-ons
create table if not exists public.packages (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  price numeric not null,
  category text not null,
  physical_items jsonb not null default '[]',
  digital_items text[] not null default '{}',
  processing_time text,
  default_printing_cost numeric,
  default_transport_cost numeric,
  photographers text,
  videographers text,
  cover_image text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_packages_updated_at
before update on public.packages
for each row execute procedure public.handle_updated_at();

alter table public.packages enable row level security;
create policy "packages_owner_all"
  on public.packages
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

create table if not exists public.add_ons (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  price numeric not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_add_ons_updated_at
before update on public.add_ons
for each row execute procedure public.handle_updated_at();

alter table public.add_ons enable row level security;
create policy "add_ons_owner_all"
  on public.add_ons
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Cards
create table if not exists public.cards (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  card_holder_name text not null,
  bank_name text not null,
  card_type text not null check (card_type in ('Prabayar','Kredit','Debit','Tunai')),
  last_four_digits text not null,
  expiry_date text,
  balance numeric not null default 0,
  color_gradient text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_cards_updated_at
before update on public.cards
for each row execute procedure public.handle_updated_at();

alter table public.cards enable row level security;
create policy "cards_owner_all"
  on public.cards
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Pockets (financial buckets)
create table if not exists public.pockets (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  description text,
  icon text not null,
  type text not null check (type in ('Nabung & Bayar','Terkunci','Bersama','Anggaran Pengeluaran','Tabungan Hadiah Freelancer')),
  amount numeric not null default 0,
  goal_amount numeric,
  lock_end_date date,
  members jsonb not null default '[]',
  source_card_id text references public.cards(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_pockets_updated_at
before update on public.pockets
for each row execute procedure public.handle_updated_at();

alter table public.pockets enable row level security;
create policy "pockets_owner_all"
  on public.pockets
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Leads
create table if not exists public.leads (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  contact_channel text not null check (contact_channel in ('WhatsApp','Instagram','Website','Telepon','Referensi','Form Saran','Lainnya')),
  location text,
  status text not null check (status in ('Sedang Diskusi','Menunggu Follow Up','Dikonversi','Ditolak')),
  date timestamptz,
  notes text,
  whatsapp text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_leads_updated_at
before update on public.leads
for each row execute procedure public.handle_updated_at();

alter table public.leads enable row level security;
create policy "leads_owner_all"
  on public.leads
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Assets
create table if not exists public.assets (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  name text not null,
  category text not null,
  purchase_date date,
  purchase_price numeric not null default 0,
  serial_number text,
  status text not null check (status in ('Tersedia','Digunakan','Perbaikan')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_assets_updated_at
before update on public.assets
for each row execute procedure public.handle_updated_at();

alter table public.assets enable row level security;
create policy "assets_owner_all"
  on public.assets
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Projects
create table if not exists public.projects (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  project_name text not null,
  client_name text not null,
  client_id text references public.clients(id) on delete set null,
  project_type text not null,
  package_name text,
  package_id text references public.packages(id) on delete set null,
  date date,
  deadline_date date,
  location text,
  progress integer not null default 0,
  status text not null,
  active_sub_statuses text[] not null default '{}',
  total_cost numeric not null default 0,
  amount_paid numeric not null default 0,
  payment_status text not null check (payment_status in ('Lunas','DP Terbayar','Belum Bayar')),
  notes text,
  accommodation text,
  drive_link text,
  client_drive_link text,
  final_drive_link text,
  start_time text,
  end_time text,
  promo_code_id text,
  discount_amount numeric,
  shipping_details text,
  dp_proof_url text,
  printing_cost numeric,
  transport_cost numeric,
  is_editing_confirmed_by_client boolean,
  is_printing_confirmed_by_client boolean,
  is_delivery_confirmed_by_client boolean,
  confirmed_sub_statuses text[] not null default '{}',
  client_sub_status_notes jsonb not null default '{}',
  sub_status_confirmation_sent_at jsonb not null default '{}',
  completed_digital_items text[] not null default '{}',
  invoice_signature text,
  custom_sub_statuses jsonb not null default '[]',
  booking_status text check (booking_status in ('Baru','Terkonfirmasi','Ditolak')),
  rejection_reason text,
  chat_history jsonb not null default '[]',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_projects_updated_at
before update on public.projects
for each row execute procedure public.handle_updated_at();

alter table public.projects enable row level security;
create policy "projects_owner_all"
  on public.projects
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Project add-ons (join)
create table if not exists public.project_add_ons (
  project_id text references public.projects(id) on delete cascade,
  add_on_id text references public.add_ons(id) on delete cascade,
  owner_uid uuid not null default auth.uid(),
  primary key (project_id, add_on_id)
);
alter table public.project_add_ons enable row level security;
create policy "project_add_ons_owner_all"
  on public.project_add_ons
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Project assigned team members (join)
create table if not exists public.project_team (
  project_id text references public.projects(id) on delete cascade,
  member_id text references public.team_members(id) on delete set null,
  name text not null,
  role text not null,
  fee numeric not null default 0,
  reward numeric,
  sub_job text,
  owner_uid uuid not null default auth.uid(),
  primary key (project_id, member_id)
);
alter table public.project_team enable row level security;
create policy "project_team_owner_all"
  on public.project_team
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Project revisions
create table if not exists public.project_revisions (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  project_id text references public.projects(id) on delete cascade,
  date timestamptz,
  admin_notes text,
  deadline timestamptz,
  freelancer_id text references public.team_members(id) on delete set null,
  status text not null check (status in ('Menunggu Revisi','Sedang Dikerjakan','Revisi Selesai')),
  freelancer_notes text,
  drive_link text,
  completed_date timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_project_revisions_updated_at
before update on public.project_revisions
for each row execute procedure public.handle_updated_at();

alter table public.project_revisions enable row level security;
create policy "project_revisions_owner_all"
  on public.project_revisions
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Printing items per project
create table if not exists public.printing_items (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  project_id text references public.projects(id) on delete cascade,
  item_type text not null, -- e.g., 'Cetak Album', 'Cetak Foto', 'Flashdisk', 'Custom'
  custom_name text,
  details text,
  cost numeric not null default 0
);
alter table public.printing_items enable row level security;
create policy "printing_items_owner_all"
  on public.printing_items
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Transactions
create table if not exists public.transactions (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  date date,
  description text,
  amount numeric not null,
  type text not null check (type in ('Pemasukan','Pengeluaran')),
  project_id text references public.projects(id) on delete set null,
  category text not null,
  method text not null check (method in ('Transfer Bank','Tunai','E-Wallet','Sistem','Kartu')),
  pocket_id text references public.pockets(id) on delete set null,
  card_id text references public.cards(id) on delete set null,
  printing_item_id text references public.printing_items(id) on delete set null,
  vendor_signature text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_transactions_updated_at
before update on public.transactions
for each row execute procedure public.handle_updated_at();

alter table public.transactions enable row level security;
create policy "transactions_owner_all"
  on public.transactions
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Contracts
create table if not exists public.contracts (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  contract_number text not null,
  client_id text references public.clients(id) on delete set null,
  project_id text references public.projects(id) on delete set null,
  signing_date date,
  signing_location text,
  created_at timestamptz not null default now(),

  client_name1 text,
  client_address1 text,
  client_phone1 text,
  client_name2 text,
  client_address2 text,
  client_phone2 text,

  shooting_duration text,
  guaranteed_photos text,
  album_details text,
  digital_files_format text,
  other_items text,
  personnel_count text,
  delivery_timeframe text,

  dp_date date,
  final_payment_date date,
  cancellation_policy text,
  jurisdiction text,

  vendor_signature text,
  client_signature text,
  updated_at timestamptz not null default now()
);
create trigger set_contracts_updated_at
before update on public.contracts
for each row execute procedure public.handle_updated_at();

alter table public.contracts enable row level security;
create policy "contracts_owner_all"
  on public.contracts
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Team project payments
create table if not exists public.team_project_payments (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  project_id text references public.projects(id) on delete cascade,
  team_member_name text not null,
  team_member_id text references public.team_members(id) on delete set null,
  date date,
  status text not null check (status in ('Paid','Unpaid')),
  fee numeric not null default 0,
  reward numeric,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_team_project_payments_updated_at
before update on public.team_project_payments
for each row execute procedure public.handle_updated_at();

alter table public.team_project_payments enable row level security;
create policy "team_project_payments_owner_all"
  on public.team_project_payments
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Team payment records + items
create table if not exists public.team_payment_records (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  record_number text unique not null,
  team_member_id text references public.team_members(id) on delete set null,
  date date,
  total_amount numeric not null default 0,
  vendor_signature text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_team_payment_records_updated_at
before update on public.team_payment_records
for each row execute procedure public.handle_updated_at();

alter table public.team_payment_records enable row level security;
create policy "team_payment_records_owner_all"
  on public.team_payment_records
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

create table if not exists public.team_payment_record_items (
  record_id text references public.team_payment_records(id) on delete cascade,
  project_payment_id text references public.team_project_payments(id) on delete cascade,
  owner_uid uuid not null default auth.uid(),
  primary key (record_id, project_payment_id)
);
alter table public.team_payment_record_items enable row level security;
create policy "team_payment_record_items_owner_all"
  on public.team_payment_record_items
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Reward ledger entries
create table if not exists public.reward_ledger_entries (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  team_member_id text references public.team_members(id) on delete set null,
  date date,
  description text,
  amount numeric not null,
  project_id text references public.projects(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_reward_ledger_entries_updated_at
before update on public.reward_ledger_entries
for each row execute procedure public.handle_updated_at();

alter table public.reward_ledger_entries enable row level security;
create policy "reward_ledger_entries_owner_all"
  on public.reward_ledger_entries
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Client feedback
create table if not exists public.client_feedback (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  client_name text not null,
  satisfaction text not null check (satisfaction in ('Sangat Puas','Puas','Biasa Saja','Tidak Puas')),
  rating integer not null,
  feedback text,
  date timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_client_feedback_updated_at
before update on public.client_feedback
for each row execute procedure public.handle_updated_at();

alter table public.client_feedback enable row level security;
create policy "client_feedback_owner_all"
  on public.client_feedback
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Notifications
create table if not exists public.notifications (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  title text not null,
  message text not null,
  timestamp timestamptz not null,
  is_read boolean not null default false,
  icon text not null, -- 'lead' | 'deadline' | 'revision' | ...
  link jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_notifications_updated_at
before update on public.notifications
for each row execute procedure public.handle_updated_at();

alter table public.notifications enable row level security;
create policy "notifications_owner_all"
  on public.notifications
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Social media posts
create table if not exists public.social_media_posts (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  project_id text references public.projects(id) on delete set null,
  client_name text,
  post_type text not null, -- see PostType TS enum
  platform text not null,  -- 'Instagram' | 'TikTok' | 'Website'
  scheduled_date timestamptz,
  caption text,
  media_url text,
  status text not null, -- see PostStatus TS enum
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_social_media_posts_updated_at
before update on public.social_media_posts
for each row execute procedure public.handle_updated_at();

alter table public.social_media_posts enable row level security;
create policy "social_media_posts_owner_all"
  on public.social_media_posts
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- SOPs
create table if not exists public.sops (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  title text not null,
  category text not null,
  content text not null,
  last_updated timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_sops_updated_at
before update on public.sops
for each row execute procedure public.handle_updated_at();

alter table public.sops enable row level security;
create policy "sops_owner_all"
  on public.sops
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

-- Promo codes
create table if not exists public.promo_codes (
  id text primary key,
  owner_uid uuid not null default auth.uid(),
  code text not null,
  discount_type text not null check (discount_type in ('percentage','fixed')),
  discount_value numeric not null,
  is_active boolean not null default true,
  usage_count integer not null default 0,
  max_usage integer,
  expiry_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger set_promo_codes_updated_at
before update on public.promo_codes
for each row execute procedure public.handle_updated_at();

alter table public.promo_codes enable row level security;
create policy "promo_codes_owner_all"
  on public.promo_codes
  using (owner_uid = auth.uid())
  with check (owner_uid = auth.uid());

