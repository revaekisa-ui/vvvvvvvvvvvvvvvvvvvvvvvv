# 📸 **Vena Pictures Dashboard**

> **Production-ready photography business management system with full Supabase integration**

A comprehensive dashboard for photography businesses featuring project management, client relations, team coordination, and financial tracking. **100% integrated with Supabase** - no mock data in production!

## ✨ **Features**

### 🎯 **Core Business Management**
- 📋 **Project Management** - Complete project lifecycle with custom statuses
- 👥 **Client Management** - Client profiles with booking history
- 🤝 **Team Management** - Freelancer coordination and payments
- 💰 **Financial Tracking** - Income, expenses, and payment management
- 📅 **Calendar Integration** - Schedule and deadline management
- 📱 **Social Media Planning** - Content scheduling and management

### 🌐 **Public Features**
- 📦 **Public Package Display** - Showcase your services
- 📝 **Online Booking Form** - Client self-service booking
- 🎯 **Lead Management** - Capture and convert prospects
- 💬 **Client Portal** - Project updates and communication
- 📊 **Feedback System** - Client satisfaction tracking

### 🔐 **Security & Multi-tenancy**
- 🛡️ **Row Level Security (RLS)** - Secure multi-tenant architecture
- 👤 **Role-based Access Control** - Admin/Member permissions
- 🔑 **Supabase Authentication** - Production-ready auth system
- 🚫 **No Signup Page** - Users managed via admin panel

## 🚀 **Quick Setup**

### **Prerequisites**
- Node.js 18+ 
- Supabase account
- PostgreSQL knowledge (basic)

### **1. Installation**
```bash
npm install
```

### **2. Supabase Setup**
1. Create a new Supabase project
2. Get your project URL and anon key
3. Follow the detailed setup in [`supabase/setup-instructions.md`](./supabase/setup-instructions.md)

### **3. Environment Configuration**
Create `.env.local`:
```env
# Supabase Configuration
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here

# Optional: Gemini AI for advanced features
GEMINI_API_KEY=your-gemini-key

# Production settings
NODE_ENV=production
```

### **4. Database Setup**

#### **Option A: Automated Setup (Recommended)**
```bash
# Windows (PowerShell)
cd supabase
.\setup-seed.ps1 -UserUUID "your-user-uuid-here" -Email "admin@yourcompany.com" -FullName "Your Name"

# Linux/Mac
cd supabase
chmod +x setup-seed.sh
./setup-seed.sh "your-user-uuid-here" "admin@yourcompany.com" "Your Name"
```

#### **Option B: Manual Setup**
See detailed instructions in [`supabase/setup-instructions.md`](./supabase/setup-instructions.md)

### **5. Run Application**
```bash
npm run dev
```

## 🎯 **Production Deployment**

### **Build for Production**
```bash
npm run build
npm run preview  # Test production build locally
```

### **Environment Variables for Production**
```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-production-anon-key
NODE_ENV=production
```

## 📁 **Project Structure**

```
├── 📂 supabase/              # Database & Setup
│   ├── schema.sql            # Complete database schema
│   ├── seed.sql              # Sample data (customizable)
│   ├── *_policies.sql        # RLS security policies
│   ├── setup-instructions.md # Detailed setup guide
│   └── setup-seed.*          # Automated setup scripts
├── 📂 components/            # React components
├── 📂 app/                   # App-specific files
├── supabaseClient.ts         # Supabase configuration
├── supabaseApi.ts           # Database operations
├── types.ts                 # TypeScript definitions
└── constants.tsx            # UI constants & mock data (fallback only)
```

## 🔧 **Development**

### **Key Files**
- `App.tsx` - Main application with conditional Supabase/local data
- `supabaseClient.ts` - Supabase configuration
- `supabaseApi.ts` - Database CRUD operations
- `constants.tsx` - UI components and fallback data
- `types.ts` - TypeScript type definitions

### **Data Flow**
1. **Production**: App ↔ Supabase (100% integrated)
2. **Development**: App ↔ Supabase OR localStorage (for demo)
3. **Fallback**: Mock data only when Supabase unavailable

## 🛡️ **Security Features**

### **Implemented Security**
- ✅ Row Level Security (RLS) on all tables
- ✅ Multi-tenant data isolation
- ✅ Role-based access control
- ✅ Secure authentication with Supabase Auth
- ✅ No sensitive data in client-side code
- ✅ Production credentials properly secured

### **Security Best Practices**
- Never commit `.env` files
- Use environment-specific Supabase keys
- Regular security policy audits
- Proper user role management

## 📞 **Support**

For setup issues or questions:
1. Check [`supabase/setup-instructions.md`](./supabase/setup-instructions.md)
2. Verify your Supabase connection
3. Check browser console for errors
4. Ensure RLS policies are correctly applied

## 🎉 **Ready for Production!**

This dashboard is **production-ready** with:
- ✅ Complete Supabase integration
- ✅ Secure multi-tenant architecture 
- ✅ Professional UI/UX
- ✅ Comprehensive business features
- ✅ Mobile-responsive design
- ✅ No mock data dependencies

**Deploy with confidence!** 🚀
