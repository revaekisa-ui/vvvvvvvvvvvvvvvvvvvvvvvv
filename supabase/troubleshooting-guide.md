# 🔧 **Troubleshooting Guide - Supabase Setup**

## 🚨 **Error Umum & Solusinya**

### **1. Error saat Menjalankan Schema**

#### **❌ "relation already exists"**
```
ERROR: relation "profiles" already exists
```

**💡 Solusi:**
```sql
-- Reset database sepenuhnya
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Lalu jalankan ulang schema.sql
```

#### **❌ "function gen_random_uuid() does not exist"**
```
ERROR: function gen_random_uuid() does not exist
```

**💡 Solusi:**
```sql
-- Enable extension dulu
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Lalu jalankan ulang schema.sql
```

---

### **2. Error saat Menjalankan Seed Data**

#### **❌ "invalid input syntax for type uuid"**
```
ERROR: invalid input syntax for type uuid: "YOUR_USER_UUID_HERE"
```

**💡 Solusi:**
1. Pastikan Anda sudah replace `YOUR_USER_UUID_HERE` dengan UUID yang valid
2. Format UUID harus: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
3. Gunakan script helper:
   ```bash
   # Windows
   .\setup-seed.ps1 -UserUUID "your-real-uuid-here"
   
   # Linux/Mac
   ./setup-seed.sh "your-real-uuid-here"
   ```

#### **❌ "duplicate key value violates unique constraint"**
```
ERROR: duplicate key value violates unique constraint "profiles_pkey"
```

**💡 Solusi:**
```sql
-- Hapus data lama terlebih dahulu
TRUNCATE TABLE profiles CASCADE;
TRUNCATE TABLE app_users CASCADE;
-- (ulangi untuk tabel lain yang error)

-- Atau reset semua data:
TRUNCATE TABLE profiles, app_users, packages, add_ons, cards, clients, 
team_members, projects, transactions, contracts, leads, assets, 
promo_codes, sops, social_media_posts, client_feedback, 
notifications CASCADE;

-- Lalu jalankan ulang seed.sql
```

---

### **3. Error Authentication**

#### **❌ User tidak bisa login**
**Symptoms**: Login form tidak berhasil, redirect ke login lagi

**💡 Debugging:**
1. **Cek user ada di database:**
   ```sql
   SELECT id, email, created_at FROM auth.users;
   ```

2. **Cek app_users mapping:**
   ```sql
   SELECT * FROM app_users;
   ```

3. **Pastikan UUID sama:**
   ```sql
   SELECT 
     u.id as auth_user_id, 
     u.email, 
     au.id as app_user_id,
     au.owner_uid
   FROM auth.users u
   LEFT JOIN app_users au ON u.id = au.id;
   ```

**💡 Solusi jika UUID tidak match:**
```sql
-- Update app_users dengan UUID yang benar
UPDATE app_users 
SET id = (SELECT id FROM auth.users WHERE email = 'your-email@example.com'),
    owner_uid = (SELECT id FROM auth.users WHERE email = 'your-email@example.com')
WHERE email = 'your-email@example.com';
```

---

### **4. Error Row Level Security (RLS)**

#### **❌ "permission denied for relation"**
```
ERROR: permission denied for relation "profiles"
```

**💡 Solusi:**
1. **Pastikan RLS policies sudah dijalankan:**
   ```sql
   -- Cek policies yang ada
   SELECT tablename, policyname FROM pg_policies WHERE schemaname = 'public';
   ```

2. **Jika policies belum ada, jalankan:**
   ```sql
   -- Copy paste dari admin_policies.sql dan public_policies.sql
   ```

3. **Untuk debugging, disable RLS sementara:**
   ```sql
   -- HATI-HATI: Hanya untuk testing!
   ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;
   ALTER TABLE app_users DISABLE ROW LEVEL SECURITY;
   -- (lakukan untuk tabel lain)
   
   -- Jangan lupa enable kembali:
   ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
   ALTER TABLE app_users ENABLE ROW LEVEL SECURITY;
   ```

---

### **5. Error di Aplikasi**

#### **❌ App menampilkan mock data**
**Symptoms**: Data di app tidak sesuai dengan database

**💡 Debugging:**
1. **Cek environment variables:**
   ```bash
   # .env atau .env.local harus berisi:
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```

2. **Cek browser console:**
   - Tekan F12
   - Lihat tab Console untuk error JavaScript
   - Lihat tab Network untuk error API calls

3. **Test koneksi Supabase:**
   ```javascript
   // Buka browser console di app dan jalankan:
   console.log('Supabase URL:', import.meta.env.VITE_SUPABASE_URL);
   console.log('USE_SUPABASE:', Boolean(import.meta.env.VITE_SUPABASE_URL));
   ```

#### **❌ "Failed to load data" di console**
**Symptoms**: Error di browser console saat fetch data

**💡 Solusi:**
1. **Cek koneksi database:**
   ```sql
   -- Test basic query
   SELECT COUNT(*) FROM profiles;
   ```

2. **Cek user login status:**
   ```javascript
   // Di browser console
   supabase.auth.getUser().then(console.log);
   ```

3. **Cek RLS policies:**
   ```sql
   -- Pastikan user yang login punya akses
   SELECT owner_uid FROM profiles LIMIT 1;
   ```

---

### **6. Error Network/Connection**

#### **❌ "fetch failed" atau "NetworkError"**
**💡 Solusi:**
1. **Cek URL Supabase benar:**
   - Format: `https://abcdefgh.supabase.co`
   - Tidak ada slash di akhir
   - Tidak ada /rest/v1 di akhir

2. **Cek Anon Key benar:**
   - Copy dari Supabase Dashboard > Settings > API
   - Pastikan yang "anon" bukan "service_role"

3. **Cek firewall/antivirus:**
   - Pastikan tidak memblokir koneksi ke *.supabase.co

---

## 🛠️ **Tools untuk Debugging**

### **1. SQL Queries Berguna**
```sql
-- Lihat semua tabel
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Lihat struktur tabel
\d profiles

-- Lihat semua users
SELECT id, email, created_at FROM auth.users;

-- Lihat data profiles
SELECT id, owner_uid, full_name, email FROM profiles;

-- Reset semua data (HATI-HATI!)
TRUNCATE TABLE profiles, app_users, packages, add_ons, cards, clients CASCADE;
```

### **2. Browser Console Commands**
```javascript
// Test Supabase connection
console.log('Supabase client:', supabase);

// Test auth status
supabase.auth.getUser().then(data => console.log('Current user:', data));

// Test basic query
supabase.from('profiles').select('*').then(data => console.log('Profiles:', data));

// Check environment
console.log('ENV vars:', {
  url: import.meta.env.VITE_SUPABASE_URL,
  key: import.meta.env.VITE_SUPABASE_ANON_KEY?.substring(0, 20) + '...'
});
```

---

## 📞 **Masih Butuh Bantuan?**

### **Langkah Debugging Sistematis:**

1. **✅ Cek Supabase Project:**
   - Project aktif dan tidak di-pause
   - Database tidak penuh (free tier ada limit)

2. **✅ Cek SQL Schema:**
   - Semua tabel tercipta
   - Functions dan triggers ada

3. **✅ Cek Auth Setup:**
   - User ada di auth.users
   - app_users mapping benar
   - UUID match

4. **✅ Cek RLS Policies:**
   - Policies sudah dijalankan
   - User punya akses ke data

5. **✅ Cek App Config:**
   - Environment variables benar
   - No JavaScript errors
   - Network calls berhasil

### **Jika Masih Error:**
1. **Screenshot error message** (lengkap)
2. **Copy paste error text** dari console
3. **Catat langkah yang sudah dilakukan**
4. **Buat issue di GitHub** atau tanyakan di forum

---

**💡 Tips**: Kebanyakan error bisa diselesaikan dengan memastikan UUID user match antara `auth.users.id` dan semua `owner_uid` di tabel-tabel data. Pastikan ini dulu sebelum debugging yang lain!

**Happy debugging!** 🚀
