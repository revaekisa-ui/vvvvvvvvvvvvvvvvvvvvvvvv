-- Seed data for Vena Pictures demo (complete)
-- OWNER_UID used: 1aaa40dd-8f46-4e8c-ac7d-879d718931a9

begin;

-- Profiles (vendor profile)
insert into public.profiles (
  id, owner_uid, full_name, email, phone, company_name, website, address, bank_account,
  authorized_signer, id_number, bio, income_categories, expense_categories, project_types,
  event_types, asset_categories, sop_categories, package_categories, project_status_config,
  notification_settings, security_settings, briefing_template, terms_and_conditions, contract_template,
  logo_base64, brand_color, public_page_config, package_share_template, booking_form_template, chat_templates
) values (
  gen_random_uuid(), '1aaa40dd-8f46-4e8c-ac7d-879d718931a9',
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
  -- project_status_config
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
  null,
  null,
  null,
  '#3b82f6',
  '{"template":"classic","title":"Galeri & Paket Layanan Kami","introduction":"Lihat portofolio terbaru dan paket layanan yang kami tawarkan. Kami siap mengabadikan momen spesial Anda.","galleryImages":[]}',
  'Halo {leadName},\n\nTerima kasih atas ketertarikan Anda dengan layanan dari Vena Pictures. Berikut adalah tautan untuk melihat daftar paket layanan kami:\n\n{packageLink}\n\nJangan ragu untuk bertanya jika ada yang kurang jelas.\n\nTerima kasih,\nTim Vena Pictures',
  'Halo {leadName},\n\nMenindaklanjuti diskusi kita, silakan isi formulir pemesanan pada tautan berikut untuk melanjutkan ke tahap selanjutnya:\n\n{bookingFormLink}\n\nKami tunggu konfirmasinya.\n\nTerima kasih,\nTim Vena Pictures',
  '[
    {"id":"welcome","title":"Ucapan Selamat Datang","template":"Halo {clientName}, selamat! Booking Anda untuk proyek \\\"{projectName}\\\" telah kami konfirmasi. Kami sangat senang bisa bekerja sama dengan Anda! Tim kami akan segera menghubungi Anda untuk langkah selanjutnya. Terima kasih!"},
    {"id":"next_steps","title":"Langkah Selanjutnya","template":"Hai {clientName}, menindaklanjuti konfirmasi proyek \\\"{projectName}\\\", berikut adalah beberapa langkah selanjutnya yang bisa kita diskusikan: [Sebutkan langkah selanjutnya, misal: jadwal meeting, survey lokasi, dll]. Mohon informasikan waktu terbaik Anda. Terima kasih."},
    {"id":"payment_reminder","title":"Pengingat Pelunasan","template":"Yth. {clientName},\\\\n\\\\nIni adalah pengingat ramah untuk pembayaran pelunasan proyek \\\"{projectName}\\\" Anda yang akan segera jatuh tempo.\\\\n\\\\nMohon informasikan jika Anda sudah melakukan pembayaran.\\\\n\\\\nTerima kasih."}
  ]'
);

-- app_users (ensure Admin mapping for your Supabase user)
insert into public.app_users (id, owner_uid, email, full_name, role, permissions, is_approved)
values ('1aaa40dd-8f46-4e8c-ac7d-879d718931a9','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','nopianhadi2@gmail.com','Nopian Hadi','Admin','{}', true)
on conflict (id) do update set
  owner_uid = excluded.owner_uid,
  email = excluded.email,
  full_name = excluded.full_name,
  role = excluded.role,
  permissions = excluded.permissions,
  is_approved = excluded.is_approved;

-- Packages
insert into public.packages (id, owner_uid, name, price, category, physical_items, digital_items, processing_time, photographers, videographers) values
('PKG001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Paket Pernikahan Silver',12000000,'Pernikahan','[{"name":"Album Cetak Eksklusif 20x30cm 20 Halaman","price":850000},{"name":"Cetak Foto 16R + Bingkai Minimalis (2pcs)","price":400000}]','{"Semua file foto (JPG) hasil seleksi","1 Video highlight (3-5 menit)"}','30 hari kerja','2 Fotografer','1 Videografer'),
('PKG002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Paket Pernikahan Gold',25000000,'Pernikahan','[{"name":"Album Cetak Premium 25x30cm 30 Halaman","price":1500000},{"name":"Cetak Foto 20R + Bingkai Premium (2pcs)","price":750000},{"name":"Box Kayu Eksklusif + Flashdisk 64GB","price":500000}]','{"Semua file foto (JPG) tanpa seleksi","1 Video sinematik (5-7 menit)","Video Teaser 1 menit untuk sosmed"}','45 hari kerja','2 Fotografer','2 Videografer'),
('PKG003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Paket Acara Korporat',8000000,'Korporat','[]','{"Dokumentasi foto (JPG)","1 Video dokumentasi (10-15 menit)"}','14 hari kerja','1 Fotografer','1 Videografer'),
('PKG004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Paket Lamaran',5000000,'Lamaran','[]','{"Semua file foto (JPG) hasil seleksi","1 Video highlight (1-2 menit)"}','14 hari kerja','1 Fotografer',null),
('PKG005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Paket Prewedding',6500000,'Prewedding','[{"name":"Cetak Foto Kanvas 40x60cm","price":600000}]','{"50 foto edit high-resolution","1 video sinematik 1 menit"}','21 hari kerja','1 Fotografer','1 Videografer'),
('PKG006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Sesi Foto Keluarga',3500000,'Keluarga','[{"name":"Cetak Foto 10R + Bingkai (5pcs)","price":350000}]','{"25 foto edit high-resolution"}','10 hari kerja','1 Fotografer',null);

-- Add-ons
insert into public.add_ons (id, owner_uid, name, price) values
('ADDON001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Same Day Edit Video',2500000),
('ADDON002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Aerial Drone Shot',1500000),
('ADDON003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Jasa MUA Profesional',1000000),
('ADDON004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Album Tambahan untuk Orang Tua',1200000);

-- Cards
insert into public.cards (id, owner_uid, card_holder_name, bank_name, card_type, last_four_digits, expiry_date, balance, color_gradient) values
('CARD001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Andi Vena','BCA','Debit','3090','09/28',52500000,'from-blue-500 to-sky-400'),
('CARD002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Andi Vena','Mandiri','Kredit','1121','11/27',-2500000,'from-yellow-400 to-amber-500'),
('CARD_CASH_001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Kas Operasional','Tunai','Tunai','CASH',null,5000000,'from-slate-100 to-slate-300');

-- Clients
insert into public.clients (id, owner_uid, name, email, phone, whatsapp, since, instagram, status, client_type, last_contact, portal_access_id) values
('CLI001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Budi & Sinta','budi.sinta@example.com','081234567890','6281234567890','2023-01-15','@budisinta.wedding','Aktif','Langsung','2024-05-20T10:00:00Z','portal-budi-sinta'),
('CLI002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PT Sejahtera Abadi','hrd@sejahteraabadi.com','021-555-1234',null,'2023-03-22',null,'Aktif','Langsung','2024-07-10T14:00:00Z','portal-sejahtera-abadi'),
('CLI004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Dewi & Rian','dewi.rian@example.com','08111222333',null,'2023-08-01',null,'Aktif','Langsung','2024-06-25T11:00:00Z','portal-dewi-rian'),
('CLI005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Farhan & Aisyah','farhan.aisyah@example.com','085678901234',null,'2023-11-10',null,'Aktif','Langsung','2024-07-12T09:00:00Z','portal-farhan-aisyah'),
('CLI006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Agung & Bella','agung.bella@example.com','087712345678',null,'2024-02-05',null,'Aktif','Langsung','2024-07-15T16:00:00Z','portal-agung-bella'),
('CLI007','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Rina & Doni','rina.doni@example.com','089987654321',null,'2024-04-12',null,'Aktif','Langsung','2024-07-01T13:00:00Z','portal-rina-doni'),
('CLI008','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','CV Maju Jaya','contact@majujaya.co.id','031-888-4567',null,'2024-05-20',null,'Tidak Aktif','Vendor','2024-06-15T10:00:00Z','portal-maju-jaya'),
('CLI009','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Kevin & Laura','kevin.laura@example.com','082123450987',null,'2024-01-10',null,'Hilang','Langsung','2024-03-01T18:00:00Z','portal-kevin-laura');

-- Team members
insert into public.team_members (id, owner_uid, name, role, email, phone, standard_fee, norek, reward_balance, rating, performance_notes, portal_access_id) values
('TM001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Andi Pratama','Fotografer','andi.p@freelance.com','081211112222',2000000,'BCA 1234567890',250000,4.8,'[{"id":"pn1","date":"2024-02-15T10:00:00Z","note":"Komposisi foto sangat baik di acara Budi & Sinta.","type":"Pujian"}]','freelance-andi'),
('TM002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Citra Lestari','Videografer','citra.l@freelance.com','081233334444',2500000,'Mandiri 0987654321',150000,4.5,'[]','freelance-citra'),
('TM003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Doni Firmansyah','Editor','doni.f@freelance.com','081255556666',1500000,null,0,4.2,'[{"id":"pn2","date":"2024-05-10T10:00:00Z","note":"consegna video teaser terlambat 1 hari untuk proyek Farhan & Aisyah.","type":"Keterlambatan Deadline"}]','freelance-doni'),
('TM004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Rian Hidayat','Asisten Fotografer','rian.h@freelance.com','081277778888',750000,null,50000,4.0,'[]','freelance-rian'),
('TM005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Fira Anjani','MUA','fira.a@freelance.com','081299990000',1000000,null,0,5.0,'[]','freelance-fira'),
('TM006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Eka Wijaya','Pilot Drone','eka.w@freelance.com','081212341234',1200000,null,100000,4.7,'[]','freelance-eka');

-- Projects
insert into public.projects (
  id, owner_uid, project_name, client_name, client_id, project_type, package_name, package_id, date, deadline_date, location,
  progress, status, active_sub_statuses, total_cost, amount_paid, payment_status, final_drive_link
) values
('PRJ001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Pernikahan Budi & Sinta','Budi & Sinta','CLI001','Pernikahan','Paket Pernikahan Gold','PKG002','2024-02-14','2024-03-30','Hotel Mulia, Jakarta',100,'Selesai',ARRAY[]::text[],26500000,26500000,'Lunas','https://bit.ly/vena-budi-sinta'),
('PRJ002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Acara Tahunan PT Sejahtera Abadi','PT Sejahtera Abadi','CLI002','Korporat','Paket Acara Korporat','PKG003','2024-08-20','2024-09-03','Ritz-Carlton, Jakarta',60,'Editing',ARRAY['Color Grading Video'],8000000,4000000,'DP Terbayar',null),
('PRJ004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Lamaran Dewi & Rian','Dewi & Rian','CLI004','Lamaran','Paket Lamaran','PKG004','2024-06-15','2024-06-29','Plataran Menteng, Jakarta',95,'Dikirim',ARRAY[]::text[],5000000,5000000,'Lunas',null),
('PRJ005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Prewedding Farhan & Aisyah','Farhan & Aisyah','CLI005','Prewedding','Paket Prewedding','PKG005','2024-05-05','2024-05-26','Bromo, Jawa Timur',80,'Revisi',ARRAY[]::text[],6500000,6500000,'Lunas',null),
('PRJ007','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Pernikahan Agung & Bella','Agung & Bella','CLI006','Pernikahan','Paket Pernikahan Silver','PKG001','2024-09-10',null,'Bandung',10,'Persiapan',ARRAY[]::text[],12000000,0,'Belum Bayar',null),
('PRJ008','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Pernikahan Rina & Doni','Rina & Doni','CLI007','Pernikahan','Paket Pernikahan Silver','PKG001','2024-07-28','2024-08-28','Bali',90,'Cetak',ARRAY['Proses Cetak'],13200000,6600000,'DP Terbayar',null),
('PRJ009','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Foto Produk CV Maju Jaya','CV Maju Jaya','CLI008','Produk','Sesi Foto Keluarga','PKG006','2024-06-01','2024-06-11','Studio Vena',100,'Selesai',ARRAY[]::text[],3500000,3500000,'Lunas',null),
('PRJ010','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Prewedding Kevin & Laura','Kevin & Laura','CLI009','Prewedding','Paket Prewedding','PKG005','2024-04-15',null,'Yogyakarta',25,'Dibatalkan',ARRAY[]::text[],6500000,3250000,'DP Terbayar',null),
('PRJ012','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Sesi Maternity Budi & Sinta','Budi & Sinta','CLI001','Keluarga','Sesi Foto Keluarga','PKG006','2024-08-15',null,'Studio Vena',0,'Dikonfirmasi',ARRAY[]::text[],3500000,1000000,'DP Terbayar',null);

-- Project add-ons
insert into public.project_add_ons (project_id, add_on_id, owner_uid) values
('PRJ001','ADDON002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9'),
('PRJ008','ADDON004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9');

-- Project revisions
insert into public.project_revisions (id, owner_uid, project_id, date, admin_notes, deadline, freelancer_id, status) values
('REV001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ005','2024-05-22T10:00:00Z','Klien meminta tone warna lebih warm dan ada beberapa foto yang ingin dihilangkan jerawatnya.','2024-05-25T10:00:00Z','TM003','Menunggu Revisi');

-- Transactions
insert into public.transactions (id, owner_uid, date, description, amount, type, project_id, category, method, card_id) values
('TRN001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-01-20','DP Proyek Pernikahan Budi & Sinta',13250000,'Pemasukan','PRJ001','DP Proyek','Transfer Bank','CARD001'),
('TRN002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-02-10','Pelunasan Proyek Pernikahan Budi & Sinta',13250000,'Pemasukan','PRJ001','Pelunasan Proyek','Transfer Bank','CARD001'),
('TRN003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-02-20','Gaji Freelancer - Andi P (Budi & Sinta)',2000000,'Pengeluaran','PRJ001','Gaji Freelancer','Transfer Bank','CARD001'),
('TRN004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-02-20','Gaji Freelancer - Citra L (Budi & Sinta)',2500000,'Pengeluaran','PRJ001','Gaji Freelancer','Transfer Bank','CARD001'),
('TRN005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-07-10','DP Proyek Acara Tahunan PT SA',4000000,'Pemasukan','PRJ002','DP Proyek','Transfer Bank','CARD002'),
('TRN006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-07-05','Biaya langganan Adobe Creative Cloud',870000,'Pengeluaran',null,'Operasional Kantor','Kartu','CARD001'),
('TRN007','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-06-01','Pelunasan Proyek Lamaran Dewi & Rian',5000000,'Pemasukan','PRJ004','Pelunasan Proyek','Tunai','CARD_CASH_001'),
('TRN008','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','2024-04-15','Pelunasan Proyek Prewedding F&A',6500000,'Pemasukan','PRJ005','Pelunasan Proyek','Transfer Bank','CARD001');

-- Pockets
insert into public.pockets (id, owner_uid, name, description, icon, type, amount, goal_amount, lock_end_date, source_card_id) values
('POC001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Dana Pajak 2024','Alokasi dana untuk pembayaran pajak tahunan.','clipboard-list','Terkunci',5000000,null,'2025-03-31',null),
('POC002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Tabungan Lensa & Kamera Baru','Menabung untuk upgrade gear.','piggy-bank','Nabung & Bayar',8500000,40000000,null,null),
('POC003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Anggaran Operasional Juli 2024','Dana untuk pengeluaran bulanan.','clipboard-list','Anggaran Pengeluaran',2000000,5000000,null,'CARD001'),
('POC_REWARD_POOL','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Tabungan Hadiah Freelancer','Akumulasi hadiah untuk tim.','star','Tabungan Hadiah Freelancer',500000,null,null,null);

-- Leads
insert into public.leads (id, owner_uid, name, contact_channel, location, status, date, notes) values
('LEAD001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Calon Klien - Sarah','Instagram','Jakarta','Sedang Diskusi',now(),'Menanyakan paket prewedding untuk bulan Desember.'),
('LEAD002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Bapak Hendra - Corporate','Website','Surabaya','Menunggu Follow Up',now() - interval '5 days','Minta penawaran untuk acara gathering kantor. Sudah dikirim, tunggu balasan.'),
('LEAD003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Rini','WhatsApp','Tangerang','Ditolak',now() - interval '10 days','Budget tidak sesuai.');

-- Notifications
insert into public.notifications (id, owner_uid, title, message, timestamp, is_read, icon, link) values
('NOTIF001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Prospek Baru dari Instagram!','Sarah menanyakan tentang paket prewedding.',now(),false,'lead','{"view":"Prospek"}'),
('NOTIF002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Pembayaran Diterima','DP sebesar Rp 4.000.000 dari PT Sejahtera Abadi telah dikonfirmasi.','2024-07-10T14:05:00Z',true,'payment','{"view":"Keuangan"}'),
('NOTIF003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Deadline Mendekat','Proyek "Lamaran Dewi & Rian" akan melewati deadline dalam 3 hari.','2024-06-26T09:00:00Z',true,'deadline','{"view":"Proyek","action":{"type":"VIEW_PROJECT_DETAILS","id":"PRJ004"}}');

-- SOPs
insert into public.sops (id, owner_uid, title, category, content, last_updated) values
('SOP001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Alur Kerja Hari-H Pernikahan','Pernikahan','1. Tim berkumpul di lokasi 1 jam sebelum acara.\n2. Briefing cepat dengan WO dan CP Klien.\n3. Pembagian tugas: Fotografer A (pengantin), Fotografer B (tamu & detail), Videografer (sinematik).\n4. Selalu backup data setiap selesai sesi (e.g., setelah akad).','2023-12-01T10:00:00Z'),
('SOP002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Prosedur Backup Data','Umum','1. Segera setelah acara selesai, backup semua memory card ke 2 hard drive terpisah.\n2. Satu hard drive disimpan di kantor, satu dibawa pulang oleh PIC.\n3. Beri nama folder dengan format: YYYY-MM-DD_[NamaProyek].','2023-11-20T10:00:00Z');

-- Promo codes
insert into public.promo_codes (id, owner_uid, code, discount_type, discount_value, is_active, usage_count, max_usage, expiry_date, created_at) values
('PROMO001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','WEDDINGFEST','percentage',10,true,5,20,'2024-12-31','2024-01-01T10:00:00Z'),
('PROMO002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','AKHIRTAHUN','fixed',1000000,false,15,15,'2023-12-31','2023-11-01T10:00:00Z');

-- Social media posts
insert into public.social_media_posts (id, owner_uid, project_id, client_name, post_type, platform, scheduled_date, caption, status) values
('POST001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ001','Budi & Sinta','Instagram Feed','Instagram','2024-03-01T10:00:00Z','Momen bahagia dari pernikahan Budi & Sinta. Sebuah kehormatan bagi kami untuk mengabadikannya. #VenaPictures #WeddingDay','Diposting'),
('POST002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ005','Farhan & Aisyah','TikTok Video','TikTok','2024-07-25T19:00:00Z','BTS keseruan prewedding Farhan & Aisyah di Bromo! #prewedding #bromo #behindthescenes','Terjadwal'),
('POST003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9',null,'Konten Umum','Artikel Blog','Website','2024-08-01T10:00:00Z','5 Tips Memilih Fotografer Pernikahan yang Tepat','Draf');

-- Assets
insert into public.assets (id, owner_uid, name, category, purchase_date, purchase_price, serial_number, status, notes) values
('ASSET001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Sony A7 IV','Kamera','2023-01-10',38000000,'SN12345678','Tersedia','Kamera utama'),
('ASSET002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Sony FE 50mm f/1.8','Lensa','2023-01-10',3500000,null,'Tersedia',null),
('ASSET003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','DJI Mavic 3','Drone','2023-05-15',32000000,'SN98765432','Digunakan','Digunakan untuk proyek PT SA');

-- Client feedback
insert into public.client_feedback (id, owner_uid, client_name, satisfaction, rating, feedback, date) values
('FB001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Budi & Sinta','Sangat Puas',5,'Tim Vena Pictures sangat profesional dan hasilnya melebihi ekspektasi! Terima kasih banyak!','2024-04-05T10:00:00Z'),
('FB002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','Kevin & Laura','Tidak Puas',2,'Komunikasi kurang lancar dan ada beberapa permintaan kami yang terlewat saat sesi foto.','2024-03-02T10:00:00Z');

-- Contracts
insert into public.contracts (
  id, owner_uid, contract_number, client_id, project_id, signing_date, signing_location, created_at,
  client_name1, client_address1, client_phone1, client_name2, client_address2, client_phone2,
  shooting_duration, guaranteed_photos, album_details, digital_files_format, other_items, personnel_count, delivery_timeframe,
  dp_date, final_payment_date, cancellation_policy, jurisdiction, vendor_signature, client_signature
) values
('CTR001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','VP/CTR/2024/001','CLI001','PRJ001','2024-01-16','Kantor Vena Pictures','2024-01-16T10:00:00Z',
 'Budi Santoso','Jl. Merdeka No. 1, Jakarta','081234567890',null,null,null,
 '8 Jam','300 Foto Edit','1 Album 20x30cm 20 Halaman','JPG High-Res','Video Sinematik 5-7 menit','2 Fotografer, 2 Videografer','45 hari kerja','2024-01-20','2024-02-10','DP tidak dapat dikembalikan.','Jakarta Pusat','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='),
('CTR002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','VP/CTR/2024/002','CLI002','PRJ002','2024-07-09','Kantor PT Sejahtera Abadi','2024-07-09T10:00:00Z',
 'HRD PT Sejahtera Abadi','Jl. Jenderal Sudirman Kav. 52-53, Jakarta','021-555-1234',null,null,null,
 '6 Jam','Semua foto (JPG)','Tidak ada','JPG High-Res','Video dokumentasi 10-15 menit','1 Fotografer, 1 Videografer','14 hari kerja','2024-07-10','2024-08-17','DP tidak dapat dikembalikan.','Jakarta Selatan','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',null);

-- Team project payments
insert into public.team_project_payments (id, owner_uid, project_id, team_member_name, team_member_id, date, status, fee, reward) values
('TPP001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ001','Andi Pratama','TM001','2024-02-14','Paid',2000000,250000),
('TPP002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ001','Citra Lestari','TM002','2024-02-14','Paid',2500000,null),
('TPP003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ001','Eka Wijaya','TM006','2024-02-14','Paid',1200000,100000),
('TPP004','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ002','Andi Pratama','TM001','2024-08-20','Unpaid',1000000,null),
('TPP005','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ002','Citra Lestari','TM002','2024-08-20','Unpaid',1500000,null),
('TPP006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PRJ004','Andi Pratama','TM001','2024-06-15','Paid',1500000,null);

-- Team payment records and items
insert into public.team_payment_records (id, owner_uid, record_number, team_member_id, date, total_amount, vendor_signature) values
('TPR001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','PAY-FR-TM001-20240220','TM001','2024-02-20',3500000,'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=');

insert into public.team_payment_record_items (record_id, project_payment_id, owner_uid) values
('TPR001','TPP001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9'),
('TPR001','TPP006','1aaa40dd-8f46-4e8c-ac7d-879d718931a9');

-- Reward ledger entries
insert into public.reward_ledger_entries (id, owner_uid, team_member_id, date, description, amount, project_id) values
('RLE001','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','TM001','2024-02-15','Hadiah dari proyek Pernikahan Budi & Sinta',250000,'PRJ001'),
('RLE002','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','TM006','2024-02-15','Hadiah dari proyek Pernikahan Budi & Sinta',100000,'PRJ001'),
('RLE003','1aaa40dd-8f46-4e8c-ac7d-879d718931a9','TM004','2024-07-01','Hadiah dari proyek Lamaran Dewi & Rian',50000,'PRJ004');

commit;

