# 🗄️ **Tutorial Menjalankan SQL di Supabase**

## 📋 **Daftar Isi**
1. [Akses SQL Editor](#1-akses-sql-editor)
2. [Menjalankan Schema SQL](#2-menjalankan-schema-sql)
3. [Menjalankan Seed Data](#3-menjalankan-seed-data)
4. [Menjalankan RLS Policies](#4-menjalankan-rls-policies)
5. [Verifikasi Database](#5-verifikasi-database)
6. [Troubleshooting](#6-troubleshooting)

---

## **1. Akses SQL Editor**

### **Step 1.1: Login ke Supabase**
1. Buka https://supabase.com
2. Klik **"Sign in"** 
3. Login dengan akun Anda
4. Pilih project Anda (atau buat baru jika belum ada)

### **Step 1.2: Buka SQL Editor**
1. Di dashboard project, cari menu di sidebar kiri
2. Klik **"SQL Editor"** (icon database 🗄️)
3. Anda akan melihat interface SQL Editor

![SQL Editor Location](https://supabase.com/docs/img/sql-editor.png)

---

## **2. Menjalankan Schema SQL**

### **Step 2.1: Buka File Schema**
1. Di komputer Anda, buka `supabase/schema.sql`
2. **Select All** dengan `Ctrl+A` (Windows) atau `Cmd+A` (Mac)
3. **Copy** dengan `Ctrl+C` atau `Cmd+C`

### **Step 2.2: Paste di SQL Editor**
1. Kembali ke Supabase SQL Editor
2. **Klik area editor** (kotak putih besar)
3. **Paste** dengan `Ctrl+V` atau `Cmd+V`
4. Pastikan semua kode ter-paste dengan benar

### **Step 2.3: Jalankan Schema**
1. **Klik tombol "RUN"** (biasanya di pojok kanan bawah editor)
2. **Tunggu proses** - ini akan membuat semua tabel dan struktur database
3. **Lihat hasil** di panel bawah:
   - ✅ **Success**: "Query executed successfully"
   - ❌ **Error**: Akan muncul pesan error merah

### **⚠️ Troubleshooting Schema:**
Jika ada error:
```sql
-- Jika ada tabel yang sudah exists, jalankan ini dulu:
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

---

## **3. Menjalankan Seed Data**

### **Step 3.1: Persiapan UUID**
**PENTING**: Sebelum menjalankan seed, Anda harus punya user UUID!

#### **Option A: Buat User Baru via SQL**
```sql
-- 1. Buat user di auth.users (ganti email & password)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'admin@yourcompany.com', -- GANTI EMAIL INI
  crypt('your_password_123', gen_salt('bf')), -- GANTI PASSWORD INI
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  FALSE,
  '',
  '',
  '',
  ''
);
```

#### **Option B: Buat User via Supabase Auth Dashboard**
1. Di Supabase Dashboard, klik **"Authentication"**
2. Klik tab **"Users"**
3. Klik **"Add user"** 
4. Isi email dan password
5. Klik **"Create user"**

### **Step 3.2: Dapatkan UUID User**
```sql
-- Jalankan query ini untuk mendapatkan UUID
SELECT id, email FROM auth.users WHERE email = 'admin@yourcompany.com';
```

**Copy UUID** yang muncul (format: `a1b2c3d4-e5f6-7890-abcd-ef1234567890`)

### **Step 3.3: Update Seed Data**

#### **Option A: Gunakan Script Otomatis**
```powershell
# Windows - di folder supabase
.\setup-seed.ps1 -UserUUID "PASTE_UUID_DISINI" -Email "admin@yourcompany.com" -FullName "Nama Anda"
```

```bash
# Linux/Mac - di folder supabase  
./setup-seed.sh "PASTE_UUID_DISINI" "admin@yourcompany.com" "Nama Anda"
```

#### **Option B: Edit Manual**
1. Buka `supabase/seed.sql`
2. **Find/Replace** semua `YOUR_USER_UUID_HERE` dengan UUID Anda
3. **Update email dan nama** di bagian app_users

### **Step 3.4: Jalankan Seed Data**
1. **Copy** seluruh isi `seed.sql` yang sudah diupdate
2. **Paste** di SQL Editor Supabase
3. **Klik "RUN"**
4. **Tunggu** sampai selesai (biasanya 10-30 detik)

---

## **4. Menjalankan RLS Policies**

### **Step 4.1: Jalankan Admin Policies**
1. **Copy** isi `supabase/admin_policies.sql`
2. **Paste** di SQL Editor
3. **Klik "RUN"**

### **Step 4.2: Jalankan Public Policies (Optional)**
Jika Anda ingin halaman publik berfungsi:
1. **Copy** isi `supabase/public_policies.sql`  
2. **Paste** di SQL Editor
3. **Klik "RUN"**

---

## **5. Verifikasi Database**

### **Step 5.1: Cek Tabel Tercipta**
```sql
-- Lihat semua tabel yang tercipta
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;
```

**Hasil yang diharapkan**: 20+ tabel seperti `profiles`, `clients`, `projects`, dll.

### **Step 5.2: Cek Data Seed**
```sql
-- Cek apakah data sudah ada
SELECT count(*) as total_packages FROM packages;
SELECT count(*) as total_clients FROM clients;
SELECT count(*) as total_projects FROM projects;
```

**Hasil yang diharapkan**: 
- packages: 6 records
- clients: 8 records  
- projects: beberapa records

### **Step 5.3: Cek RLS Policies**
```sql
-- Lihat RLS policies
SELECT schemaname, tablename, policyname, cmd, qual 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
```

---

## **6. Troubleshooting**

### **❌ Error: "relation already exists"**
**Solusi**: Tabel sudah ada, hapus dulu:
```sql
DROP TABLE IF EXISTS table_name CASCADE;
-- Lalu jalankan ulang schema.sql
```

### **❌ Error: "invalid input syntax for type uuid"**
**Solusi**: UUID format salah, pastikan format:
```
xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### **❌ Error: "permission denied for schema public"**
**Solusi**: 
```sql
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

### **❌ Error: "row-level security policy violated"**
**Solusi**: Pastikan Anda sudah login dengan user yang benar, atau disable RLS sementara:
```sql
ALTER TABLE table_name DISABLE ROW LEVEL SECURITY;
```

### **❌ App tidak menampilkan data**
**Checklist**:
1. ✅ Supabase URL benar di `.env`
2. ✅ User UUID sama di auth.users dan owner_uid
3. ✅ User sudah login di app
4. ✅ RLS policies sudah dijalankan

---

## **7. Test Connection dari App**

### **Step 7.1: Update Environment**
```env
# File: .env atau .env.local
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### **Step 7.2: Test Login**
1. **Jalankan app**: `npm run dev`
2. **Buka browser**: `http://localhost:5173`
3. **Login** dengan email/password yang dibuat tadi
4. **Cek data**: Apakah dashboard menampilkan data dari Supabase?

---

## **🎉 Berhasil!**

Jika semua step diikuti dengan benar, Anda seharusnya melihat:
- ✅ Dashboard dengan data real dari Supabase
- ✅ Halaman publik berfungsi (jika public policies dijalankan)
- ✅ Login/logout berfungsi
- ✅ CRUD operations bekerja

## **📞 Butuh Bantuan?**

Jika masih ada masalah:
1. **Cek Console Browser** (F12) untuk error JavaScript
2. **Cek Network Tab** untuk error API calls
3. **Cek Supabase Logs** di dashboard untuk server errors
4. **Pastikan RLS policies** sesuai dengan user yang login

**Happy coding!** 🚀
