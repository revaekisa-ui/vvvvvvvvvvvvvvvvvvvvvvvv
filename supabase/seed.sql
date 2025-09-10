begin;

-- ⚠️  REPLACE THIS PLACEHOLDER WITH YOUR ACTUAL USER UUID ⚠️
-- This will be replaced by the setup-seed.sh script.

-- Profile
insert into public.profiles (
  id, owner_uid, full_name, email, phone, company_name, website, address, bank_account,
  authorized_signer, id_number, bio, income_categories, expense_categories, project_types,
  event_types, asset_categories, sop_categories, package_categories, project_status_config,
  notification_settings, security_settings, briefing_template, terms_and_conditions, contract_template,
  logo_base64, brand_color, public_page_config, package_share_template, booking_form_template, chat_templates
) values (
  gen_random_uuid(), 'YOUR_USER_UUID_HERE',
  'Your Full Name', 'your-email@example.com', '081234567890', 'My Photography Studio', 'https://example.com',
  '123 Photo Lane, Imaginary City', 'Bank Name - 1234567890',
  'Your Full Name', '1234567890123456',
  'Capturing moments, creating memories.',
  '{"DP Proyek","Pelunasan Proyek","Penjualan Cetak"}',
  '{"Gaji Freelancer","Transportasi","Peralatan","Marketing"}',
  '{"Pernikahan","Prewedding","Korporat"}',
  '{"Meeting Klien","Survey Lokasi","Libur"}',
  '{"Kamera","Lensa","Lighting"}',
  '{"Umum","Pernikahan"}',
  '{"Pernikahan","Prewedding","Korporat"}',
  '[]',
  '{"newProject":true,"paymentConfirmation":true,"deadlineReminder":true}',
  '{"twoFactorEnabled":false}',
  'Briefing template here.',
  'Terms and conditions here.',
  null,
  null,
  '#3b82f6',
  '{"template":"classic","title":"Gallery & Packages","introduction":"Welcome to our portfolio.","galleryImages":[]}',
  'Package share template here.',
  'Booking form template here.',
  '[]'
);

-- App users (linking auth user to role/permissions)
insert into public.app_users (id, owner_uid, email, full_name, role, permissions, is_approved)
values ('YOUR_USER_UUID_HERE','YOUR_USER_UUID_HERE','your-email@example.com','Your Full Name','Admin','{}', true);

commit;
