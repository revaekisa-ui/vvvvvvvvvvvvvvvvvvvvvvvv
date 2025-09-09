# 🚀 **Supabase Setup Instructions**

## **Quick Setup Guide**

### **Step 1: Get Your User UUID**
1. Create a user in Supabase (either via Dashboard Auth or SQL)
2. Get the user UUID by running this SQL in Supabase SQL Editor:
   ```sql
   SELECT id, email FROM auth.users WHERE email = 'your-email@example.com';
   ```
3. Copy the UUID value

### **Step 2: Update Seed File**
1. Open `supabase/seed.sql`
2. **Find/Replace ALL** occurrences of `YOUR_USER_UUID_HERE` with your actual UUID
3. Also update the email and name in the `app_users` section:
   ```sql
   -- Line 66-67: Update these values
   values ('YOUR_ACTUAL_UUID','YOUR_ACTUAL_UUID','your-actual-email@example.com','Your Actual Name','Admin','{}', true);
   ```

### **Step 3: Run SQL Scripts**
Execute in this order in your Supabase SQL Editor:

1. **Schema** (creates all tables):
   ```sql
   -- Copy and paste content from: supabase/schema.sql
   ```

2. **Seed Data** (populates with demo data):
   ```sql
   -- Copy and paste content from: supabase/seed.sql
   -- (after replacing YOUR_USER_UUID_HERE)
   ```

3. **Admin Policies** (for admin functions):
   ```sql
   -- Copy and paste content from: supabase/admin_policies.sql
   ```

4. **Public Policies** (for public pages):
   ```sql
   -- Copy and paste content from: supabase/public_policies.sql
   ```

### **Step 4: Test Connection**
1. Make sure your `.env` file has the correct values:
   ```env
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```
2. Start your app: `npm run dev`
3. Login with your created user credentials

---

## **Troubleshooting**

### **Issue: RLS Policy Error**
If you get RLS errors:
```sql
-- Make sure you're logged in as the owner user
-- Or temporarily disable RLS for testing:
ALTER TABLE table_name DISABLE ROW LEVEL SECURITY;
```

### **Issue: No Data Showing**
Check if:
1. User UUID matches between `auth.users` and all `owner_uid` columns
2. You're logged in with the correct user
3. RLS policies are properly applied

### **Issue: App Shows Mock Data**
- Ensure `VITE_SUPABASE_URL` is set in `.env`
- Check browser console for Supabase connection errors

---

## **Production Setup**

### **Environment Variables**
For production, make sure you have:
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-production-anon-key
NODE_ENV=production
```

### **Security Checklist**
- ✅ RLS enabled on all tables
- ✅ Proper policies for multi-tenant access
- ✅ Demo credentials hidden in production
- ✅ API keys properly secured
- ✅ User registration handled via admin panel only

---

**🎉 Your Vena Pictures Dashboard should now be fully integrated with Supabase!**
