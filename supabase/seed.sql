-- Seed data for Vena Pictures demo
-- IMPORTANT: BEFORE RUNNING, replace YOUR_USER_UUID_HERE with your actual Supabase auth user id
-- 
-- HOW TO GET YOUR USER UUID:
-- 1. Login to your app first (create user via Supabase Auth or SQL)
-- 2. Run: SELECT id FROM auth.users WHERE email = 'your-email@example.com';
-- 3. Copy the UUID and replace ALL occurrences of YOUR_USER_UUID_HERE below
-- 
-- QUICK REPLACE: Find/Replace "YOUR_USER_UUID_HERE" with your actual UUID

begin;

-- ⚠️  REPLACE THIS PLACEHOLDER WITH YOUR ACTUAL USER UUID ⚠️
-- Current placeholder: YOUR_USER_UUID_HERE
-- Replace with something like: a1b2c3d4-e5f6-7890-abcd-ef1234567890

-- Profile
insert into public.profiles (
  id, owner_uid, full_name, email, phone, company_name, website, address, bank_account,
  authorized_signer, id_number, bio, income_categories, expense_categories, project_types,
  event_types, asset_categories, sop_categories, package_categories, project_status_config,
  notification_settings, security_settings, briefing_template, terms_and_conditions, contract_template,
  logo_base64, brand_color, public_page_config, package_share_template, booking_form_template, chat_templates
) values (
  gen_random_uuid(), 'taaa40dd-8f4d-4e8c-ac7d-879d7d937a9',
  'Andi Vena', 'nopianhadi2@gmail.com', '081288889999', 'Vena Pictures', 'https://venapictures.com',
  'Jl. Kreatif No. 10, Jakarta Pusat', 'BCA - 9876543210 a/n Vena Pictures',
  'Andi Vena', '3171234567890002',
  'Mengabadikan momen dengan sentuhan sinematik. Spesialis pernikahan dan prewedding di Vena Pictures.',
  '{"DP Proyek","Pelunasan Proyek","Penjualan Cetak","Sewa Alat","Modal","Penjualan Add-on"}',
  '{"Gaji Freelancer","Transportasi","Akomodasi","Konsumsi","Peralatan","Marketing","Operasional Kantor","Sewa Tempat","Cetak Album","Penarikan Hadiah Freelancer","Transfer Internal","Penutupan Anggaran","Biaya Produksi Lain"}',
  '{"Pernikahan","Lamaran","Prewedding","Korporat","Ulang Tahun","Produk","Keluarga"}',
  '{"Meeting Klien","Survey Lokasi","Libur","Workshop","Acara Internal","Lainnya"}',
  '{"Kamera","Lensa","Lighting","Komputer","Drone","Aksesoris","Lainnya"}',
  '{"Pernikahan","Korporat","Umum","Editing","Prewedding"}',
  '{"Pernikahan","Lamaran","Prewedding","Korporat","Ulang Tahun","Produk","Keluarga"}',
  -- project_status_config (JSON)
  '[
    {"id":"status_1","name":"Persiapan","color":"#6366f1","subStatuses":[{"name":"Briefing Internal","note":"Rapat tim internal untuk membahas konsep."},{"name":"Survey Lokasi","note":"Kunjungan ke lokasi acara jika diperlukan."}],"note":"Tahap awal persiapan proyek."},
    {"id":"status_2","name":"Dikonfirmasi","color":"#3b82f6","subStatuses":[{"name":"Pembayaran DP","note":"Menunggu konfirmasi pembayaran DP dari klien."},{"name":"Penjadwalan Tim","note":"Mengalokasikan freelancer untuk proyek."}],"note":"Proyek telah dikonfirmasi oleh klien."},
    {"id":"status_3","name":"Editing","color":"#8b5cf6","subStatuses":[{"name":"Seleksi Foto","note":"Proses pemilihan foto terbaik oleh tim atau klien."},{"name":"Color Grading Video","note":"Penyesuaian warna pada video."},{"name":"Music Scoring","note":"Pemilihan musik latar untuk video."}],"note":"Proses pasca-produksi."},
    {"id":"status_4","name":"Revisi","color":"#14b8a6","subStatuses":[],"note":"Tahap revisi berdasarkan masukan klien."},
    {"id":"status_5","name":"Cetak","color":"#f97316","subStatuses":[{"name":"Approval Desain Album","note":"Menunggu persetujuan final desain album dari klien."},{"name":"Proses Cetak","note":"Album dan foto sedang dalam proses pencetakan."},{"name":"QC Album","note":"Pemeriksaan kualitas hasil cetakan."}],"note":"Proses pencetakan output fisik."},
    {"id":"status_6","name":"Dikirim","color":"#06b6d4","subStatuses":[],"note":"Hasil akhir telah dikirim ke klien."},
    {"id":"status_7","name":"Selesai","color":"#10b981","subStatuses":[],"note":"Proyek telah selesai dan semua pembayaran lunas."},
    {"id":"status_8","name":"Dibatalkan","color":"#ef4444","subStatuses":[],"note":"Proyek dibatalkan oleh klien atau vendor."}
  ]',
  '{"newProject":true,"paymentConfirmation":true,"deadlineReminder":true}',
  '{"twoFactorEnabled":false}',
  'Halo tim,\nBerikut adalah briefing untuk acara besok.\n\nKey Persons:\n- [Nama CP Klien]\n- [Nama WO]\n\nJangan lupa:\n- Bawa baterai cadangan & memory card kosong.\n- Datang 1 jam sebelum acara dimulai.\n- Dress code: Hitam rapi.\n\nSemangat!',
  '📜 **Syarat & Ketentuan Umum**\n- Harga yang tertera dapat berubah sewaktu-waktu sebelum adanya kesepakatan.\n\n💰 **Pembayaran**\n- Pemesanan dianggap sah setelah pembayaran Uang Muka (DP) sebesar 50% dari total biaya.\n- Pelunasan wajib dilakukan paling lambat 3 (tiga) hari sebelum tanggal acara.\n\n⏱ **Pembatalan & Perubahan Jadwal**\n- Uang Muka (DP) yang telah dibayarkan tidak dapat dikembalikan (non-refundable) jika terjadi pembatalan dari pihak klien.\n- Perubahan jadwal dapat dilakukan maksimal 1 (satu) kali dengan konfirmasi selambat-lambatnya 14 hari sebelum tanggal acara, tergantung ketersediaan tim.\n\n📦 **Hasil Akhir**\n- Waktu pengerjaan hasil akhir (foto & video) adalah sesuai dengan yang tertera pada detail paket, dihitung setelah semua materi dan data dari klien kami terima.\n- Hak cipta hasil foto dan video tetap menjadi milik Vena Pictures. Klien mendapatkan hak guna pribadi dan non-komersial.\n- Vena Pictures berhak menggunakan hasil foto dan video untuk keperluan portofolio dan promosi dengan seizin klien.',
  null,
  '#3b82f6',
  '{"template":"classic","title":"Galeri & Paket Layanan Kami","introduction":"Lihat portofolio terbaru dan paket layanan yang kami tawarkan. Kami siap mengabadikan momen spesial Anda.","galleryImages":[]}',
  'Halo {leadName},\n\nTerima kasih atas ketertarikan Anda dengan layanan dari Vena Pictures. Berikut adalah tautan untuk melihat daftar paket layanan kami:\n\n{packageLink}\n\nJangan ragu untuk bertanya jika ada yang kurang jelas.\n\nTerima kasih,\nTim Vena Pictures',
  'Halo {leadName},\n\nMenindaklanjuti diskusi kita, silakan isi formulir pemesanan pada tautan berikut untuk melanjutkan ke tahap selanjutnya:\n\n{bookingFormLink}\n\nKami tunggu konfirmasinya.\n\nTerima kasih,\nTim Vena Pictures',
  '[
    {"id":"welcome","title":"Ucapan Selamat Datang","template":"Halo {clientName}, selamat! Booking Anda untuk proyek \"{projectName}\" telah kami konfirmasi. Kami sangat senang bisa bekerja sama dengan Anda! Tim kami akan segera menghubungi Anda untuk langkah selanjutnya. Terima kasih!"},
    {"id":"next_steps","title":"Langkah Selanjutnya","template":"Hai {clientName}, menindaklanjuti konfirmasi proyek \"{projectName}\", berikut adalah beberapa langkah selanjutnya yang bisa kita diskusikan: [Sebutkan langkah selanjutnya, misal: jadwal meeting, survey lokasi, dll]. Mohon informasikan waktu terbaik Anda. Terima kasih."},
    {"id":"payment_reminder","title":"Pengingat Pelunasan","template":"Yth. {clientName},\\n\\nIni adalah pengingat ramah untuk pembayaran pelunasan proyek \"{projectName}\" Anda yang akan segera jatuh tempo.\\n\\nMohon informasikan jika Anda sudah melakukan pembayaran.\\n\\nTerima kasih."}
  ]'
);

-- App users (linking auth user to role/permissions)
-- ⚠️  UPDATE EMAIL AND NAME BELOW ⚠️
insert into public.app_users (id, owner_uid, email, full_name, role, permissions, is_approved)
values ('taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','nopianhadi2@gmail.com','Nopian Hadi','Admin','{}', true);

-- Packages
insert into public.packages (id, owner_uid, name, price, category, physical_items, digital_items, processing_time, photographers, videographers)
values
('PKG001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Paket Pernikahan Silver',12000000,'Pernikahan','[{"name":"Album Cetak Eksklusif 20x30cm 20 Halaman","price":850000},{"name":"Cetak Foto 16R + Bingkai Minimalis (2pcs)","price":400000}]','{"Semua file foto (JPG) hasil seleksi","1 Video highlight (3-5 menit)"}','30 hari kerja','2 Fotografer','1 Videografer'),
('PKG002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Paket Pernikahan Gold',25000000,'Pernikahan','[{"name":"Album Cetak Premium 25x30cm 30 Halaman","price":1500000},{"name":"Cetak Foto 20R + Bingkai Premium (2pcs)","price":750000},{"name":"Box Kayu Eksklusif + Flashdisk 64GB","price":500000}]','{"Semua file foto (JPG) tanpa seleksi","1 Video sinematik (5-7 menit)","Video Teaser 1 menit untuk sosmed"}','45 hari kerja','2 Fotografer','2 Videografer'),
('PKG003','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Paket Acara Korporat',8000000,'Korporat','[]','{"Dokumentasi foto (JPG)","1 Video dokumentasi (10-15 menit)"}','14 hari kerja','1 Fotografer','1 Videografer'),
('PKG004','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Paket Lamaran',5000000,'Lamaran','[]','{"Semua file foto (JPG) hasil seleksi","1 Video highlight (1-2 menit)"}','14 hari kerja','1 Fotografer',null),
('PKG005','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Paket Prewedding',6500000,'Prewedding','[{"name":"Cetak Foto Kanvas 40x60cm","price":600000}]','{"50 foto edit high-resolution","1 video sinematik 1 menit"}','21 hari kerja','1 Fotografer','1 Videografer'),
('PKG006','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Sesi Foto Keluarga',3500000,'Keluarga','[{"name":"Cetak Foto 10R + Bingkai (5pcs)","price":350000}]','{"25 foto edit high-resolution"}','10 hari kerja','1 Fotografer',null);

-- Add-ons
insert into public.add_ons (id, owner_uid, name, price) values
('ADDON001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Same Day Edit Video',2500000),
('ADDON002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Aerial Drone Shot',1500000),
('ADDON003','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Jasa MUA Profesional',1000000),
('ADDON004','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Album Tambahan untuk Orang Tua',1200000);

-- Cards
insert into public.cards (id, owner_uid, card_holder_name, bank_name, card_type, last_four_digits, expiry_date, balance, color_gradient) values
('CARD001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Andi Vena','BCA','Debit','3090','09/28',52500000,'from-blue-500 to-sky-400'),
('CARD002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Andi Vena','Mandiri','Kredit','1121','11/27',-2500000,'from-yellow-400 to-amber-500'),
('CARD_CASH_001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Kas Operasional','Tunai','Tunai','CASH',null,5000000,'from-slate-100 to-slate-300');

-- Clients
insert into public.clients (id, owner_uid, name, email, phone, whatsapp, since, instagram, status, client_type, last_contact, portal_access_id) values
('CLI001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Budi & Sinta','budi.sinta@example.com','081234567890','6281234567890','2023-01-15','@budisinta.wedding','Aktif','Langsung','2024-05-20T10:00:00Z','portal-budi-sinta'),
('CLI002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','PT Sejahtera Abadi','hrd@sejahteraabadi.com','021-555-1234',null,'2023-03-22',null,'Aktif','Langsung','2024-07-10T14:00:00Z','portal-sejahtera-abadi'),
('CLI004','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Dewi & Rian','dewi.rian@example.com','08111222333',null,'2023-08-01',null,'Aktif','Langsung','2024-06-25T11:00:00Z','portal-dewi-rian'),
('CLI005','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Farhan & Aisyah','farhan.aisyah@example.com','085678901234',null,'2023-11-10',null,'Aktif','Langsung','2024-07-12T09:00:00Z','portal-farhan-aisyah'),
('CLI006','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Agung & Bella','agung.bella@example.com','087712345678',null,'2024-02-05',null,'Aktif','Langsung','2024-07-15T16:00:00Z','portal-agung-bella'),
('CLI007','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Rina & Doni','rina.doni@example.com','089987654321',null,'2024-04-12',null,'Aktif','Langsung','2024-07-01T13:00:00Z','portal-rina-doni'),
('CLI008','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','CV Maju Jaya','contact@majujaya.co.id','031-888-4567',null,'2024-05-20',null,'Tidak Aktif','Vendor','2024-06-15T10:00:00Z','portal-maju-jaya'),
('CLI009','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Kevin & Laura','kevin.laura@example.com','082123450987',null,'2024-01-10',null,'Hilang','Langsung','2024-03-01T18:00:00Z','portal-kevin-laura');

-- Team members
insert into public.team_members (id, owner_uid, name, role, email, phone, standard_fee, norek, reward_balance, rating, performance_notes, portal_access_id) values
('TM001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Andi Pratama','Fotografer','andi.p@freelance.com','081211112222',2000000,'BCA 1234567890',250000,4.8,'[{"id":"pn1","date":"2024-02-15T10:00:00Z","note":"Komposisi foto sangat baik di acara Budi & Sinta.","type":"Pujian"}]','freelance-andi'),
('TM002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Citra Lestari','Videografer','citra.l@freelance.com','081233334444',2500000,'Mandiri 0987654321',150000,4.5,'[]','freelance-citra'),
('TM003','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Doni Firmansyah','Editor','doni.f@freelance.com','081255556666',1500000,null,0,4.2,'[{"id":"pn2","date":"2024-05-10T10:00:00Z","note":"consegna video teaser terlambat 1 hari untuk proyek Farhan & Aisyah.","type":"Keterlambatan Deadline"}]','freelance-doni'),
('TM004','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Rian Hidayat','Asisten Fotografer','rian.h@freelance.com','081277778888',750000,null,50000,4.0,'[]','freelance-rian'),
('TM005','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Fira Anjani','MUA','fira.a@freelance.com','081299990000',1000000,null,0,5.0,'[]','freelance-fira'),
('TM006','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Eka Wijaya','Pilot Drone','eka.w@freelance.com','081212341234',1200000,null,100000,4.7,'[]','freelance-eka');

-- Projects
insert into public.projects (
  id, owner_uid, project_name, client_name, client_id, project_type, package_name, package_id, date, deadline_date, location,
  progress, status, active_sub_statuses, total_cost, amount_paid, payment_status, final_drive_link
) values
('PRJ001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Pernikahan Budi & Sinta','Budi & Sinta','CLI001','Pernikahan','Paket Pernikahan Gold','PKG002','2024-02-14','2024-03-30','Hotel Mulia, Jakarta',100,'Selesai','{}',26500000,26500000,'Lunas','https://bit.ly/vena-budi-sinta'),
('PRJ002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','Acara Tahunan PT Sejahtera Abadi','PT Sejahtera Abadi','CLI002','Korporat','Paket Acara Korporat','PKG003','2024-08-20','2024-09-03','Ritz-Carlton, Jakarta',60,'Editing','{"Color Grading Video"}',8000000,4000000,'DP Terbayar',null),...
('TPP003','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','PRJ001','Eka Wijaya','TM006','2024-02-14','Paid',1200000,100000),
('TPP004','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','PRJ002','Andi Pratama','TM001','2024-08-20','Unpaid',1000000,null),
('TPP005','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','PRJ002','Citra Lestari','TM002','2024-08-20','Unpaid',1500000,null),
('TPP006','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','PRJ004','Andi Pratama','TM001','2024-06-15','Paid',1500000,null);

-- Reward ledger
insert into public.reward_ledger_entries (id, owner_uid, team_member_id, date, description, amount, project_id) values
('RLE001','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','TM001','2024-02-15','Hadiah dari proyek Pernikahan Budi & Sinta',250000,'PRJ001'),
('RLE002','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','TM006','2024-02-15','Hadiah dari proyek Pernikahan Budi & Sinta',100000,'PRJ001'),
('RLE003','taaa40dd-8f4d-4e8c-ac7d-879d7d937a9','TM004','2024-07-01','Hadiah dari proyek Lamaran Dewi & Rian',50000,'PRJ004');

commit;

