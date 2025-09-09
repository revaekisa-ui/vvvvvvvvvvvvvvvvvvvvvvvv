

import React, { useState, useEffect, useRef } from 'react';
import { ViewType, Client, Project, TeamMember, Transaction, Package, AddOn, TeamProjectPayment, Profile, FinancialPocket, TeamPaymentRecord, Lead, RewardLedgerEntry, User, Card, Asset, ClientFeedback, Contract, RevisionStatus, NavigationAction, Notification, SocialMediaPost, PromoCode, SOP, CardType, PocketType, VendorData } from './types';
import { DEFAULT_USER_PROFILE, HomeIcon, FolderKanbanIcon, UsersIcon, DollarSignIcon, PlusIcon, lightenColor, darkenColor, hexToHsl } from './constants';
import { supabase } from './supabaseClient';
import { supa } from './supabaseApi';
import Sidebar from './components/Sidebar';
import Dashboard from './components/Dashboard';
import { Leads } from './components/Leads';
import Booking from './components/Booking';
import Clients from './components/Clients';
import { Projects } from './components/Projects';
import { Freelancers } from './components/Freelancers';
import Finance from './components/Finance';
import Packages from './components/Packages';
import { Assets } from './components/Assets';
import Settings from './components/Settings';
import { CalendarView } from './components/CalendarView';
import Login from './components/Login';
import PublicBookingForm from './components/PublicBookingForm';
import PublicPackages from './components/PublicPackages';
import PublicFeedbackForm from './components/PublicFeedbackForm';
import PublicRevisionForm from './components/PublicRevisionForm';
import PublicLeadForm from './components/PublicLeadForm';
import Header from './components/Header';
import SuggestionForm from './components/SuggestionForm';
import ClientReports from './components/ClientKPI';
import GlobalSearch from './components/GlobalSearch';
import Contracts from './components/Contracts';
import ClientPortal from './components/ClientPortal';
import FreelancerPortal from './components/FreelancerPortal';
import { SocialPlanner } from './components/SocialPlanner';
import PromoCodes from './components/PromoCodes';
import SOPManagement from './components/SOP';
import Homepage from './components/Homepage';

// Simple debounce hook to avoid spamming Supabase on rapid state changes
function useDebouncedEffect(effect: () => void | Promise<void>, deps: any[], delay = 400) {
  const timeoutRef = useRef<number | undefined>(undefined);
  useEffect(() => {
    // @ts-ignore - window typing
    timeoutRef.current && clearTimeout(timeoutRef.current);
    // @ts-ignore - window typing
    timeoutRef.current = window.setTimeout(() => {
      void effect();
    }, delay);
    // @ts-ignore - window typing
    return () => timeoutRef.current && clearTimeout(timeoutRef.current);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, deps);
}

const AccessDenied: React.FC<{onBackToDashboard: () => void}> = ({ onBackToDashboard }) => (
    <div className="
        flex flex-col items-center justify-center 
        h-full 
        text-center 
        p-4 sm:p-6 md:p-8
        animate-fade-in
    ">
        <div className="
            w-16 h-16 sm:w-20 sm:h-20
            rounded-full 
            bg-red-100 dark:bg-red-900/20
            flex items-center justify-center
            mb-4 sm:mb-6
        ">
            <svg className="w-8 h-8 sm:w-10 sm:h-10 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
            </svg>
        </div>
        <h2 className="
            text-xl sm:text-2xl 
            font-bold 
            text-red-600 dark:text-red-400 
            mb-2 sm:mb-3
        ">
            Akses Ditolak
        </h2>
        <p className="
            text-brand-text-secondary 
            mb-6 sm:mb-8 
            max-w-md
            leading-relaxed
        ">
            Anda tidak memiliki izin untuk mengakses halaman ini.
        </p>
        <button 
            onClick={onBackToDashboard} 
            className="button-primary"
        >
            Kembali ke Dashboard
        </button>
    </div>
);

const BottomNavBar: React.FC<{ activeView: ViewType; handleNavigation: (view: ViewType) => void }> = ({ activeView, handleNavigation }) => {
    const navItems = [
        { view: ViewType.DASHBOARD, label: 'Beranda', icon: HomeIcon },
        { view: ViewType.PROJECTS, label: 'Proyek', icon: FolderKanbanIcon },
        { view: ViewType.CLIENTS, label: 'Klien', icon: UsersIcon },
        { view: ViewType.FINANCE, label: 'Keuangan', icon: DollarSignIcon },
    ];

    return (
        <nav className="
            bottom-nav 
            xl:hidden
            bg-brand-surface/95 
            backdrop-blur-xl
            border-t border-brand-border/50
        ">
            <div className="
                flex justify-around items-center 
                h-16
                px-2
            " 
            style={{
                paddingBottom: 'var(--safe-area-inset-bottom, 0px)'
            }}>
                {navItems.map(item => (
                    <button
                        key={item.view}
                        onClick={() => handleNavigation(item.view)}
                        className={`
                            flex flex-col items-center justify-center 
                            w-full h-full
                            px-2 py-2
                            rounded-xl
                            transition-all duration-200 
                            min-w-[64px] min-h-[48px]
                            relative
                            group
                            ${activeView === item.view 
                                ? 'text-brand-accent bg-brand-accent/10' 
                                : 'text-brand-text-secondary hover:text-brand-text-primary hover:bg-brand-input/50 active:bg-brand-input'
                            }
                        `}
                        aria-label={item.label}
                    >
                        {/* Enhanced Icon */}
                        <div className="
                            relative
                            mb-1
                        ">
                            <item.icon className={`
                                w-5 h-5 sm:w-6 sm:h-6
                                transition-all duration-200
                                ${activeView === item.view ? 'transform scale-110' : 'group-active:scale-95'}
                            `} />
                            
                            {/* Active indicator dot */}
                            {activeView === item.view && (
                                <div className="
                                    absolute -top-1 -right-1
                                    w-2 h-2
                                    bg-brand-accent
                                    animate-pulse-soft
                                " />
                            )}
                        </div>
                        
                        {/* Enhanced Label */}
                        <span className={`
                            text-xs font-semibold
                            leading-tight
                            transition-all duration-200
                            ${activeView === item.view ? 'font-bold' : ''}
                        `}>
                            {item.label}
                        </span>
                        
                        {/* Background highlight */}
                        <div className={`
                            absolute inset-0
                            rounded-xl
                            transition-all duration-300
                            ${activeView === item.view 
                                ? 'bg-gradient-to-t from-brand-accent/10 to-transparent' 
                                : 'bg-transparent group-hover:bg-brand-input/30'
                            }
                        `} />
                    </button>
                ))}
            </div>
        </nav>
    );
};

const App: React.FC = () => {
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(false);
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [activeView, setActiveView] = useState<ViewType>(ViewType.HOMEPAGE);
  const [notification, setNotification] = useState<string>('');
  const [initialAction, setInitialAction] = useState<NavigationAction | null>(null);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [route, setRoute] = useState(window.location.hash || '#/home');
  const [isSearchOpen, setIsSearchOpen] = useState(false);

  // --- State Initialization ---
  const [users, setUsers] = useState<User[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [teamMembers, setTeamMembers] = useState<TeamMember[]>([]);
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [teamProjectPayments, setTeamProjectPayments] = useState<TeamProjectPayment[]>([]);
  const [teamPaymentRecords, setTeamPaymentRecords] = useState<TeamPaymentRecord[]>([]);
  const [pockets, setPockets] = useState<FinancialPocket[]>([]);
  const [profile, setProfile] = useState<Profile>(JSON.parse(JSON.stringify(DEFAULT_USER_PROFILE)));
  const [leads, setLeads] = useState<Lead[]>([]);
  const [rewardLedgerEntries, setRewardLedgerEntries] = useState<RewardLedgerEntry[]>([]);
  const [cards, setCards] = useState<Card[]>([]);
  const [assets, setAssets] = useState<Asset[]>([]);
  const [contracts, setContracts] = useState<Contract[]>([]);
  const [clientFeedback, setClientFeedback] = useState<ClientFeedback[]>([]);
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [socialMediaPosts, setSocialMediaPosts] = useState<SocialMediaPost[]>([]);
  const [promoCodes, setPromoCodes] = useState<PromoCode[]>([]);
  const [sops, setSops] = useState<SOP[]>([]);
  const [packages, setPackages] = useState<Package[]>([]);
  const [addOns, setAddOns] = useState<AddOn[]>([]);


    // --- [NEW] MOCK EMAIL SERVICE ---
    const sendEmailNotification = (recipientEmail: string, notification: Notification) => {
        console.log(`
        ========================================
        [SIMULASI EMAIL] Mengirim notifikasi ke: ${recipientEmail}
        ----------------------------------------
        Judul: ${notification.title}
        Pesan: ${notification.message}
        Waktu: ${new Date(notification.timestamp).toLocaleString('id-ID')}
        ========================================
        `);
    };

    // --- [NEW] CENTRALIZED NOTIFICATION HANDLER ---
    const addNotification = (newNotificationData: Omit<Notification, 'id' | 'timestamp' | 'isRead'>) => {
        const newNotification: Notification = {
            id: crypto.randomUUID(),
            timestamp: new Date().toISOString(),
            isRead: false,
            ...newNotificationData
        };

        setNotifications(prev => [newNotification, ...prev]);

        if (profile.email) {
            sendEmailNotification(profile.email, newNotification);
        } else {
            console.warn('[SIMULASI EMAIL] Gagal: Alamat email vendor tidak diatur di Pengaturan Profil.');
        }
    };

  useEffect(() => {
    const handleHashChange = () => {
        const newRoute = window.location.hash || '#/home';
        setRoute(newRoute);
        if (!isAuthenticated) {
            const isPublicRoute = newRoute.startsWith('#/public') || newRoute.startsWith('#/feedback') || newRoute.startsWith('#/suggestion-form') || newRoute.startsWith('#/revision-form') || newRoute.startsWith('#/portal') || newRoute.startsWith('#/freelancer-portal') || newRoute.startsWith('#/login') || newRoute === '#/home' || newRoute === '#';
            if (!isPublicRoute) {
                window.location.hash = '#/home';
            }
        } else {
            const isAuthLandingPage = newRoute.startsWith('#/login') || newRoute === '#/home' || newRoute === '#';
            if (isAuthLandingPage) {
                window.location.hash = '#/dashboard';
            }
        }
    };
    window.addEventListener('hashchange', handleHashChange);
    handleHashChange(); // Initial check
    return () => window.removeEventListener('hashchange', handleHashChange);
  }, [isAuthenticated]);

  useEffect(() => {
      const path = (route.split('?')[0].split('/')[1] || 'home').toLowerCase();
      const newView = Object.values(ViewType).find(v => 
          v.toLowerCase().replace(/ /g, '-') === path
      );
      if (newView) {
          setActiveView(newView);
      } else if (path === 'team') { // Handle 'Freelancer' mapping to 'team' route
          setActiveView(ViewType.TEAM);
      }
  }, [route]);
  
  useEffect(() => {
        const styleElement = document.getElementById('public-theme-style');
        const isPublicRoute = route.startsWith('#/public') || route.startsWith('#/portal') || route.startsWith('#/freelancer-portal');
        
        document.body.classList.toggle('app-theme', !isPublicRoute);
        document.body.classList.toggle('public-page-body', isPublicRoute);

        if (isPublicRoute) {
            const brandColor = profile.brandColor || '#3b82f6';
            
            if (styleElement) {
                const hoverColor = darkenColor(brandColor, 10);
                const brandHsl = hexToHsl(brandColor);
                styleElement.innerHTML = `
                    :root {
                        --public-accent: ${brandColor};
                        --public-accent-hover: ${hoverColor};
                        --public-accent-hsl: ${brandHsl};
                    }
                `;
            }
        } else if (styleElement) {
            styleElement.innerHTML = '';
        }

    }, [route, profile.brandColor]);

  const showNotification = (message: string, duration: number = 3000) => {
    setNotification(message);
    setTimeout(() => {
      setNotification('');
    }, duration);
  };

  // Sync Supabase auth session to local app auth state
  useEffect(() => {
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (_event, session) => {
      const user = session?.user;
      if (user) {
        try {
          const { data: appUser } = await supabase.from('app_users').select('*').eq('id', user.id).maybeSingle();
          const mappedUser: User = {
            id: user.id,
            email: user.email || '',
            password: '',
            fullName: (appUser?.full_name as string) || (user.user_metadata?.full_name as string) || user.email || 'User',
            role: ((appUser?.role as string) === 'Admin' ? 'Admin' : 'Member'),
            permissions: (appUser?.permissions as any) || undefined,
            isApproved: appUser?.is_approved !== false,
          };
          setCurrentUser(mappedUser);
          setIsAuthenticated(true);
        } catch (e) {
          console.error('[Supabase] Failed to map app user', e);
          setCurrentUser(null);
          setIsAuthenticated(false);
        }
      } else {
        setCurrentUser(null);
        setIsAuthenticated(false);
      }
    });
    return () => {
      try { subscription.unsubscribe(); } catch {}
    };
  }, []);

  // Load data from Supabase when configured
  const initialSupabaseLoadDone = useRef(false);

  useEffect(() => {
    const toCamel = (s: string) => s.replace(/_[a-z]/g, (g) => g[1].toUpperCase());
    const camelize = (obj: any) => {
      if (!obj || typeof obj !== 'object' || Array.isArray(obj)) return obj;
      const out: any = {};
      for (const k of Object.keys(obj)) out[toCamel(k)] = camelize(obj[k]);
      return out;
    };
    const camelizeArray = <T,>(arr: any[]): T[] => (arr || []).map((x) => camelize(x)) as T[];

    const load = async () => {
      try {
        const [
          { data: clientsData },
          { data: teamMembersData },
          { data: packagesData },
          { data: addOnsData },
          { data: cardsData },
          { data: pocketsData },
          { data: leadsData },
          { data: assetsData },
          { data: promoCodesData },
          { data: sopsData },
          { data: projectsData },
          { data: transactionsData },
          { data: contractsData },
          { data: feedbackData },
          { data: notificationsData },
          { data: postsData },
          { data: profileData },
          { data: projectTeamData },
          { data: projectAddOnsData },
          { data: projectRevisionsData },
          { data: printingItemsData },
        ] = await Promise.all([
          supabase.from('clients').select('*'),
          supabase.from('team_members').select('*'),
          supabase.from('packages').select('*'),
          supabase.from('add_ons').select('*'),
          supabase.from('cards').select('*'),
          supabase.from('pockets').select('*'),
          supabase.from('leads').select('*'),
          supabase.from('assets').select('*'),
          supabase.from('promo_codes').select('*'),
          supabase.from('sops').select('*'),
          supabase.from('projects').select('*'),
          supabase.from('transactions').select('*'),
          supabase.from('contracts').select('*'),
          supabase.from('client_feedback').select('*'),
          supabase.from('notifications').select('*'),
          supabase.from('social_media_posts').select('*'),
          supabase.from('profiles').select('*').limit(1),
          supabase.from('project_team').select('*'),
          supabase.from('project_add_ons').select('*'),
          supabase.from('project_revisions').select('*'),
          supabase.from('printing_items').select('*'),
        ]);

        // Compose project join information
        const addOnIndex = new Map((addOnsData || []).map((a: any) => [a.id, a]));
        const teamByProject = new Map<string, any[]>();
        (projectTeamData || []).forEach((row: any) => {
          const key = row.project_id as string;
          if (!teamByProject.has(key)) teamByProject.set(key, []);
          teamByProject.get(key)!.push(row);
        });
        const addOnsByProject = new Map<string, any[]>();
        (projectAddOnsData || []).forEach((row: any) => {
          const key = row.project_id as string;
          if (!addOnsByProject.has(key)) addOnsByProject.set(key, []);
          addOnsByProject.get(key)!.push(row);
        });
        const revByProject = new Map<string, any[]>();
        (projectRevisionsData || []).forEach((row: any) => {
          const key = row.project_id as string;
          if (!revByProject.has(key)) revByProject.set(key, []);
          revByProject.get(key)!.push(row);
        });
        const printByProject = new Map<string, any[]>();
        (printingItemsData || []).forEach((row: any) => {
          const key = row.project_id as string;
          if (!printByProject.has(key)) printByProject.set(key, []);
          printByProject.get(key)!.push(row);
        });

        setClients(camelizeArray<Client>(clientsData || []));
        setTeamMembers(camelizeArray<TeamMember>(teamMembersData || []));
        setPackages(camelizeArray<Package>(packagesData || []));
        setAddOns(camelizeArray<AddOn>(addOnsData || []));
        setCards(camelizeArray<Card>(cardsData || []));
        setPockets(camelizeArray<FinancialPocket>(pocketsData || []));
        setLeads(camelizeArray<Lead>(leadsData || []));
        setAssets(camelizeArray<Asset>(assetsData || []));
        setPromoCodes(camelizeArray<PromoCode>(promoCodesData || []));
        setSops(camelizeArray<SOP>(sopsData || []));
        // Merge joins into projects
        const mergedProjects: Project[] = camelizeArray<Project>(projectsData || []).map((p: any) => {
          const teamRows = teamByProject.get(p.id) || [];
          const addOnRows = addOnsByProject.get(p.id) || [];
          const revisionsRows = revByProject.get(p.id) || [];
          const printingRows = printByProject.get(p.id) || [];

          const team = teamRows.map((t: any) => ({
            memberId: t.member_id as string,
            name: t.name as string,
            role: t.role as string,
            fee: Number(t.fee) || 0,
            reward: t.reward != null ? Number(t.reward) : undefined,
            subJob: t.sub_job || undefined,
          }));

          const addOns = addOnRows.map((r: any) => {
            const a = addOnIndex.get(r.add_on_id);
            return a ? { id: a.id as string, name: a.name as string, price: Number(a.price) || 0 } : { id: r.add_on_id as string, name: 'Add-on', price: 0 };
          });

          const revisions = revisionsRows.map((r: any) => camelize(r));
          const printingDetails = printingRows.map((r: any) => camelize(r));

          return { ...p, team, addOns, revisions, printingDetails } as Project;
        });
        setProjects(mergedProjects);
        setTransactions(camelizeArray<Transaction>(transactionsData || []));
        setContracts(camelizeArray<Contract>(contractsData || []));
        setClientFeedback(camelizeArray<ClientFeedback>(feedbackData || []));
        setNotifications(camelizeArray<Notification>(notificationsData || []));
        setSocialMediaPosts(camelizeArray<SocialMediaPost>(postsData || []));
        if (profileData && profileData.length > 0) setProfile(camelize(profileData[0]) as Profile);
      } catch (e) {
        console.error('[Supabase] Failed to load data', e);
      }
    };

    load().finally(() => {
      initialSupabaseLoadDone.current = true;
    });
  }, []);

  const handleSetProfile = (value: React.SetStateAction<Profile>) => {
    setProfile(value);
  };

  const handleLoginSuccess = (user: User) => {
    setIsAuthenticated(true);
    setCurrentUser(user);
    window.location.hash = '#/dashboard';
  };
  
  const handleLogout = () => {
    supabase.auth.signOut().finally(() => {
        setIsAuthenticated(false);
        setCurrentUser(null);
        window.location.hash = '#/home';
    });
  };

  const handleMarkAsRead = (notificationId: string) => {
    setNotifications(prev => prev.map(n => n.id === notificationId ? { ...n, isRead: true } : n));
  };
  
  const handleMarkAllAsRead = () => {
    setNotifications(prev => prev.map(n => ({ ...n, isRead: true })));
  };

  const handleNavigation = (view: ViewType, action?: NavigationAction, notificationId?: string) => {
        const pathMap: { [key in ViewType]: string } = {
            [ViewType.HOMEPAGE]: 'home',
            [ViewType.DASHBOARD]: 'dashboard',
            [ViewType.PROSPEK]: 'prospek',
            [ViewType.BOOKING]: 'booking',
            [ViewType.CLIENTS]: 'clients',
            [ViewType.PROJECTS]: 'projects',
            [ViewType.TEAM]: 'team',
            [ViewType.FINANCE]: 'finance',
            [ViewType.CALENDAR]: 'calendar',
            [ViewType.SOCIAL_MEDIA_PLANNER]: 'social-media-planner',
            [ViewType.PACKAGES]: 'packages',
            [ViewType.ASSETS]: 'assets',
            [ViewType.CONTRACTS]: 'contracts',
            [ViewType.PROMO_CODES]: 'promo-codes',
            [ViewType.SOP]: 'sop',
            [ViewType.CLIENT_REPORTS]: 'client-reports',
            [ViewType.SETTINGS]: 'settings',
        };

    const newRoute = `#/${pathMap[view] || view.toLowerCase().replace(/ /g, '-')}`;

    window.location.hash = newRoute;

    setActiveView(view);
    setInitialAction(action || null);
    setIsSidebarOpen(false); // Close sidebar on navigation
    setIsSearchOpen(false); // Close search on navigation
    if (notificationId) {
        handleMarkAsRead(notificationId);
    }
  };

  const hasPermission = (view: ViewType) => {
    if (!currentUser) return false;
    if (currentUser.role === 'Admin') return true;
    if (view === ViewType.DASHBOARD) return true;
    return currentUser.permissions?.includes(view) || false;
  };
  
  const handleUpdateRevision = (projectId: string, revisionId: string, updatedData: { freelancerNotes: string; driveLink: string; status: RevisionStatus; }) => {
    setProjects(prevProjects => {
        const project = prevProjects.find(p => p.id === projectId);
        if (!project) return prevProjects;

        const revision = project.revisions?.find(r => r.id === revisionId);
        if (!revision) return prevProjects;

        if (updatedData.status === RevisionStatus.COMPLETED && revision.status !== RevisionStatus.COMPLETED) {
            const freelancer = teamMembers.find(tm => tm.id === revision.freelancerId);
            addNotification({
                title: 'Revisi Telah Diselesaikan',
                message: `${freelancer?.name || 'Seorang freelancer'} telah menyelesaikan tugas revisi untuk proyek "${project.projectName}".`,
                icon: 'revision',
                link: { view: ViewType.PROJECTS, action: { type: 'VIEW_PROJECT_DETAILS', id: projectId } }
            });
        }
        
        return prevProjects.map(p => 
            p.id === projectId 
                ? { ...p, revisions: p.revisions?.map(r => r.id === revisionId ? { ...r, ...updatedData, completedDate: new Date().toISOString() } : r) } 
                : p
        );
    });
  };

  const renderView = () => {
    if (!hasPermission(activeView)) {
        return <AccessDenied onBackToDashboard={() => setActiveView(ViewType.DASHBOARD)} />;
    }
    switch (activeView) {
      case ViewType.DASHBOARD:
        return <Dashboard 
          projects={projects} 
          clients={clients} 
          transactions={transactions} 
          teamMembers={teamMembers}
          cards={cards}
          pockets={pockets}
          handleNavigation={handleNavigation}
          leads={leads}
          teamProjectPayments={teamProjectPayments}
          packages={packages}
          assets={assets}
          clientFeedback={clientFeedback}
          contracts={contracts}
          currentUser={currentUser}
          projectStatusConfig={profile.projectStatusConfig}
        />;
      case ViewType.PROSPEK:
        return <Leads
            leads={leads} setLeads={setLeads}
            clients={clients} setClients={setClients}
            projects={projects} setProjects={setProjects}
            packages={packages} addOns={addOns}
            transactions={transactions} setTransactions={setTransactions}
            userProfile={profile} setProfile={handleSetProfile} showNotification={showNotification}
            cards={cards} setCards={setCards}
            pockets={pockets} setPockets={setPockets}
            promoCodes={promoCodes} setPromoCodes={setPromoCodes}
        />;
      case ViewType.BOOKING:
        return <Booking
            leads={leads}
            clients={clients}
            projects={projects}
            setProjects={setProjects}
            packages={packages}
            userProfile={profile}
            setProfile={setProfile}
            handleNavigation={handleNavigation}
            showNotification={showNotification}
        />;
      case ViewType.CLIENTS:
        return <Clients
          clients={clients} setClients={setClients}
          projects={projects} setProjects={setProjects}
          packages={packages} addOns={addOns}
          transactions={transactions} setTransactions={setTransactions}
          userProfile={profile}
          showNotification={showNotification}
          initialAction={initialAction} setInitialAction={setInitialAction}
          cards={cards} setCards={setCards}
          pockets={pockets} setPockets={setPockets}
          contracts={contracts}
          handleNavigation={handleNavigation}
          clientFeedback={clientFeedback}
          promoCodes={promoCodes} setPromoCodes={setPromoCodes}
          onSignInvoice={(pId, sig) => setProjects(prev => prev.map(p => p.id === pId ? { ...p, invoiceSignature: sig } : p))}
          onSignTransaction={(tId, sig) => setTransactions(prev => prev.map(t => t.id === tId ? { ...t, vendorSignature: sig } : t))}
          addNotification={addNotification}
        />;
      case ViewType.PROJECTS:
        return <Projects 
          projects={projects} setProjects={setProjects}
          clients={clients}
          packages={packages}
          teamMembers={teamMembers}
          teamProjectPayments={teamProjectPayments} setTeamProjectPayments={setTeamProjectPayments}
          transactions={transactions} setTransactions={setTransactions}
          initialAction={initialAction} setInitialAction={setInitialAction}
          profile={profile}
          showNotification={showNotification}
          cards={cards}
          setCards={setCards}
        />;
      case ViewType.TEAM:
        return (
          <Freelancers
            teamMembers={teamMembers}
            setTeamMembers={setTeamMembers}
            teamProjectPayments={teamProjectPayments}
            setTeamProjectPayments={setTeamProjectPayments}
            teamPaymentRecords={teamPaymentRecords}
            setTeamPaymentRecords={setTeamPaymentRecords}
            transactions={transactions}
            setTransactions={setTransactions}
            userProfile={profile}
            showNotification={showNotification}
            initialAction={initialAction}
            setInitialAction={setInitialAction}
            projects={projects}
            setProjects={setProjects}
            rewardLedgerEntries={rewardLedgerEntries}
            setRewardLedgerEntries={setRewardLedgerEntries}
            pockets={pockets}
            setPockets={setPockets}
            cards={cards}
            setCards={setCards}
            onSignPaymentRecord={(rId, sig) => setTeamPaymentRecords(prev => prev.map(r => r.id === rId ? { ...r, vendorSignature: sig } : r))}
          />
        );
      case ViewType.FINANCE:
        return <Finance 
          transactions={transactions} setTransactions={setTransactions}
          pockets={pockets} setPockets={setPockets}
          projects={projects}
          profile={profile}
          cards={cards} setCards={setCards}
          teamMembers={teamMembers}
          rewardLedgerEntries={rewardLedgerEntries}
        />;
      case ViewType.PACKAGES:
        return <Packages packages={packages} setPackages={setPackages} addOns={addOns} setAddOns={setAddOns} projects={projects} profile={profile} />;
      case ViewType.ASSETS:
        return <Assets assets={assets} setAssets={setAssets} profile={profile} showNotification={showNotification} />;
      case ViewType.CONTRACTS:
        return <Contracts 
            contracts={contracts} setContracts={setContracts}
            clients={clients} projects={projects} profile={profile}
            showNotification={showNotification}
            initialAction={initialAction} setInitialAction={setInitialAction}
            packages={packages}
            onSignContract={(cId, sig, signer) => setContracts(prev => prev.map(c => c.id === cId ? { ...c, [signer === 'vendor' ? 'vendorSignature' : 'clientSignature']: sig } : c))}
        />;
      case ViewType.SOP:
        return <SOPManagement sops={sops} setSops={setSops} profile={profile} showNotification={showNotification} />;
      case ViewType.SETTINGS:
        return <Settings 
          profile={profile} setProfile={handleSetProfile} 
          transactions={transactions} setTransactions={setTransactions}
          projects={projects} setProjects={setProjects}
          packages={packages} setPackages={setPackages}
          sops={sops} setSops={setSops}
          users={users}
          setUsers={setUsers}
          currentUser={currentUser}
          showNotification={showNotification}
        />;
      case ViewType.CALENDAR:
        return <CalendarView projects={projects} setProjects={setProjects} teamMembers={teamMembers} profile={profile} />;
      case ViewType.CLIENT_REPORTS:
        return <ClientReports 
            clients={clients}
            leads={leads}
            projects={projects}
            feedback={clientFeedback}
            setFeedback={setClientFeedback}
            showNotification={showNotification}
        />;
      case ViewType.SOCIAL_MEDIA_PLANNER:
        return <SocialPlanner posts={socialMediaPosts} setPosts={setSocialMediaPosts} projects={projects} showNotification={showNotification} />;
      case ViewType.PROMO_CODES:
        return <PromoCodes promoCodes={promoCodes} setPromoCodes={setPromoCodes} projects={projects} showNotification={showNotification} />;
      default:
        return <div />;
    }
  };
  
  // --- Supabase sync watchers ---
  // Track previously synced ids for delete detection
  const prevIds = useRef({
    clients: new Set<string>(),
    leads: new Set<string>(),
    packages: new Set<string>(),
    addOns: new Set<string>(),
    cards: new Set<string>(),
    pockets: new Set<string>(),
    assets: new Set<string>(),
    promoCodes: new Set<string>(),
    sops: new Set<string>(),
    transactions: new Set<string>(),
    contracts: new Set<string>(),
    teamMembers: new Set<string>(),
    teamProjectPayments: new Set<string>(),
    teamPaymentRecords: new Set<string>(),
    clientFeedback: new Set<string>(),
    notifications: new Set<string>(),
    posts: new Set<string>(),
    projects: new Set<string>(),
  });

  const canSync = isAuthenticated && initialSupabaseLoadDone.current;
  const lastSyncError = useRef<string | null>(null);
  const notifySyncError = (label: string, e: any) => {
    if (lastSyncError.current !== label) {
      lastSyncError.current = label;
      showNotification(label);
      setTimeout(() => {
        if (lastSyncError.current === label) lastSyncError.current = null;
      }, 5000);
    }
    console.error(label, e);
  };

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncClients(clients, prevIds.current.clients).then((s) => (prevIds.current.clients = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: clients', e));
  }, [clients, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncLeads(leads, prevIds.current.leads).then((s) => (prevIds.current.leads = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: leads', e));
  }, [leads, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncPackages(packages, prevIds.current.packages).then((s) => (prevIds.current.packages = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: packages', e));
  }, [packages, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncAddOns(addOns, prevIds.current.addOns).then((s) => (prevIds.current.addOns = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: add_ons', e));
  }, [addOns, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncCards(cards, prevIds.current.cards).then((s) => (prevIds.current.cards = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: cards', e));
  }, [cards, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncPockets(pockets, prevIds.current.pockets).then((s) => (prevIds.current.pockets = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: pockets', e));
  }, [pockets, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncAssets(assets, prevIds.current.assets).then((s) => (prevIds.current.assets = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: assets', e));
  }, [assets, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncPromoCodes(promoCodes, prevIds.current.promoCodes).then((s) => (prevIds.current.promoCodes = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: promo_codes', e));
  }, [promoCodes, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncSops(sops, prevIds.current.sops).then((s) => (prevIds.current.sops = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: sops', e));
  }, [sops, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncTransactions(transactions, prevIds.current.transactions).then((s) => (prevIds.current.transactions = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: transactions', e));
  }, [transactions, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncContracts(contracts, prevIds.current.contracts).then((s) => (prevIds.current.contracts = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: contracts', e));
  }, [contracts, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncTeamMembers(teamMembers, prevIds.current.teamMembers).then((s) => (prevIds.current.teamMembers = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: team_members', e));
  }, [teamMembers, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncTeamProjectPayments(teamProjectPayments, prevIds.current.teamProjectPayments).then((s) => (prevIds.current.teamProjectPayments = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: team_project_payments', e));
  }, [teamProjectPayments, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncTeamPaymentRecords(teamPaymentRecords, prevIds.current.teamPaymentRecords).then((s) => (prevIds.current.teamPaymentRecords = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: team_payment_records', e));
  }, [teamPaymentRecords, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncClientFeedback(clientFeedback, prevIds.current.clientFeedback).then((s) => (prevIds.current.clientFeedback = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: client_feedback', e));
  }, [clientFeedback, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncNotifications(notifications, prevIds.current.notifications).then((s) => (prevIds.current.notifications = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: notifications', e));
  }, [notifications, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncPosts(socialMediaPosts, prevIds.current.posts).then((s) => (prevIds.current.posts = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: social_media_posts', e));
  }, [socialMediaPosts, canSync]);

  useDebouncedEffect(() => {
    if (!canSync) return;
supa.syncProjects(projects, prevIds.current.projects).then((s) => (prevIds.current.projects = s)).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: projects', e));
  }, [projects, canSync]);

  // profile (single row)
  useDebouncedEffect(() => {
    if (!canSync) return;
    supa.upsertProfile(profile).then((id) => {
      if (!profile.id || profile.id.length === 0) {
        setProfile((prev) => ({ ...prev, id }));
      }
}).catch((e) => notifySyncError('[Supabase] Gagal sinkronisasi: profile', e));
  }, [profile, canSync]);

  // --- ROUTING LOGIC ---
  if (route.startsWith('#/home') || route === '#/') return <Homepage />;
  if (route.startsWith('#/login')) return <Login onLoginSuccess={handleLoginSuccess} />;
  
  if (route.startsWith('#/public-packages')) {
    return <PublicPackages
        packages={packages}
        addOns={addOns}
        userProfile={profile}
        showNotification={showNotification}
        setClients={setClients}
        setProjects={setProjects}
        setTransactions={setTransactions}
        setCards={setCards}
        setLeads={setLeads}
        addNotification={addNotification}
        cards={cards}
        promoCodes={promoCodes}
        setPromoCodes={setPromoCodes}
    />;
  }
  if (route.startsWith('#/public-booking')) {
    const allDataForForm = { clients, projects, teamMembers, transactions, teamProjectPayments, teamPaymentRecords, pockets, profile, leads, rewardLedgerEntries, cards, assets, contracts, clientFeedback, notifications, socialMediaPosts, promoCodes, sops, packages, addOns };
    return <PublicBookingForm {...allDataForForm} userProfile={profile} showNotification={showNotification} setClients={setClients} setProjects={setProjects} setTransactions={setTransactions} setCards={setCards} setPockets={setPockets} setPromoCodes={setPromoCodes} setLeads={setLeads} addNotification={addNotification} />;
  }
  if (route.startsWith('#/public-lead-form')) {
    return <PublicLeadForm setLeads={setLeads} userProfile={profile} showNotification={showNotification} addNotification={addNotification} />;
  }
  
  if (route.startsWith('#/feedback')) return <PublicFeedbackForm setClientFeedback={setClientFeedback} />;
  if (route.startsWith('#/suggestion-form')) return <SuggestionForm setLeads={setLeads} addNotification={addNotification} />;
  if (route.startsWith('#/revision-form')) return <PublicRevisionForm projects={projects} teamMembers={teamMembers} onUpdateRevision={handleUpdateRevision} />;
  if (route.startsWith('#/portal/')) {
    const accessId = route.split('/portal/')[1];
    return <ClientPortal accessId={accessId} clients={clients} projects={projects} setClientFeedback={setClientFeedback} showNotification={showNotification} contracts={contracts} transactions={transactions} userProfile={profile} packages={packages} onClientConfirmation={(pId, stage) => setProjects(prev => prev.map(p => p.id === pId ? {...p, [`is${stage.charAt(0).toUpperCase() + stage.slice(1)}ConfirmedByClient`]: true} : p))} onClientSubStatusConfirmation={(pId, sub, note) => setProjects(prev => prev.map(p => p.id === pId ? {...p, confirmedSubStatuses: [...(p.confirmedSubStatuses || []), sub], clientSubStatusNotes: {...(p.clientSubStatusNotes || {}), [sub]: note}} : p))} onSignContract={(cId, sig, signer) => setContracts(prev => prev.map(c => c.id === cId ? {...c, [signer === 'vendor' ? 'vendorSignature' : 'clientSignature']: sig } : c))} />;
  }
  if (route.startsWith('#/freelancer-portal/')) {
     const accessId = route.split('/freelancer-portal/')[1];
     return <FreelancerPortal accessId={accessId} teamMembers={teamMembers} projects={projects} teamProjectPayments={teamProjectPayments} teamPaymentRecords={teamPaymentRecords} rewardLedgerEntries={rewardLedgerEntries} showNotification={showNotification} onUpdateRevision={handleUpdateRevision} sops={sops} userProfile={profile} addNotification={addNotification} />;
  }

  if (!isAuthenticated) return <Login onLoginSuccess={handleLoginSuccess} />;

  return (
    <div className="
        flex h-screen 
        bg-brand-bg 
        text-brand-text-primary
        overflow-hidden
    ">
      <Sidebar 
        activeView={activeView} 
        setActiveView={(view) => handleNavigation(view)} 
        isOpen={isSidebarOpen} 
        setIsOpen={setIsSidebarOpen}
        currentUser={currentUser}
      />
      
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header 
            pageTitle={activeView} 
            toggleSidebar={() => setIsSidebarOpen(!isSidebarOpen)}
            setIsSearchOpen={setIsSearchOpen}
            notifications={notifications}
            handleNavigation={handleNavigation}
            handleMarkAllAsRead={handleMarkAllAsRead}
            currentUser={currentUser}
            profile={profile}
            handleLogout={handleLogout}
        />
        
        <main className="
            flex-1 
            overflow-x-hidden 
            overflow-y-auto 
            p-3 sm:p-4 md:p-6 lg:p-8 
            pb-20 xl:pb-8
            overscroll-contain
        " 
        style={{ 
            WebkitOverflowScrolling: 'touch',
            paddingBottom: 'calc(5rem + var(--safe-area-inset-bottom, 0px))'
        }}>
            <div className="animate-fade-in">
                {renderView()}
            </div>
        </main>
      </div>
      
      {/* Enhanced Notification Toast */}
      {notification && (
        <div className="
            fixed top-4 right-4 
            sm:top-6 sm:right-6
            bg-brand-accent 
            text-white 
            py-3 px-4 sm:py-4 sm:px-6
            rounded-xl 
            shadow-2xl 
            z-50 
            animate-fade-in-out
            backdrop-blur-sm
            border border-brand-accent-hover/20
            max-w-sm
            break-words
        "
        style={{
            top: 'calc(1rem + var(--safe-area-inset-top, 0px))',
            right: 'calc(1rem + var(--safe-area-inset-right, 0px))'
        }}>
          <div className="flex items-center gap-3">
            <div className="w-2 h-2 bg-white rounded-full animate-pulse-soft" />
            <span className="font-medium text-sm sm:text-base">{notification}</span>
          </div>
        </div>
      )}
      
      <GlobalSearch 
        isOpen={isSearchOpen} 
        onClose={() => setIsSearchOpen(false)} 
        clients={clients}
        projects={projects}
        teamMembers={teamMembers}
        handleNavigation={handleNavigation}
      />
      
      <BottomNavBar activeView={activeView} handleNavigation={handleNavigation} />
    </div>
  );
};

export default App;