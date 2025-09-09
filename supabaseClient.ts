import { createClient } from '@supabase/supabase-js';

// Initialize Supabase client for Vite (browser)
const supabaseUrl = (import.meta as any).env?.VITE_SUPABASE_URL as string;
const supabaseAnonKey = (import.meta as any).env?.VITE_SUPABASE_ANON_KEY as string;

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('[Supabase] Missing VITE_SUPABASE_URL or VITE_SUPABASE_ANON_KEY. The app will fall back to local mocks if not configured.');
}

// Export a single source-of-truth flag so UI components can check config state
export const isSupabaseConfigured = Boolean(supabaseUrl && supabaseAnonKey);
console.info(`[Supabase] configured=${isSupabaseConfigured}`);

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
  },
});

