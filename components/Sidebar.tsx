import React, { useMemo, useState, useEffect } from 'react';
import { ViewType, User } from '../types';
import { NAV_ITEMS, LogOutIcon, MoonIcon, SunIcon, UsersIcon } from '../constants';

interface SidebarProps {
  activeView: ViewType;
  setActiveView: (view: ViewType) => void;
  isOpen: boolean;
  setIsOpen: (isOpen: boolean) => void;
  currentUser: User | null;
}

const Sidebar: React.FC<SidebarProps> = ({ activeView, setActiveView, isOpen, setIsOpen, currentUser }) => {
  const [theme, setTheme] = useState(() => {
    if (typeof window !== 'undefined' && window.localStorage) {
      return localStorage.getItem('theme') || 'light';
    }
    return 'light';
  });

  useEffect(() => {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    localStorage.setItem('theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prevTheme => prevTheme === 'light' ? 'dark' : 'light');
  };

  const visibleNavItems = useMemo(() => {
    if (!currentUser) return [];
    if (currentUser.role === 'Admin') {
      return NAV_ITEMS;
    }
    // Member role
    const memberPermissions = new Set(currentUser.permissions || []);
    memberPermissions.add(ViewType.DASHBOARD); // Always show dashboard
    return NAV_ITEMS.filter(item => memberPermissions.has(item.view));
  }, [currentUser]);

  // Handle scroll lock when sidebar is open on mobile
  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    
    return () => {
      document.body.style.overflow = '';
    };
  }, [isOpen]);

  return (
    <>
      {/* Enhanced Backdrop with better blur */}
      <div 
        className={`
          fixed inset-0 
          bg-black/50 
          backdrop-blur-sm
          z-30 
          xl:hidden 
          transition-all duration-300 ease-out
          ${isOpen ? 'opacity-100 visible' : 'opacity-0 invisible'}
        `}
        onClick={() => setIsOpen(false)}
      />

      {/* Enhanced Sidebar Container */}
      <aside 
        id="sidebar" 
        className={`
          fixed xl:relative 
          inset-y-0 left-0 
          w-72 sm:w-80 xl:w-64
          bg-brand-surface 
          flex-col flex-shrink-0 flex 
          z-40 
          transform transition-all duration-300 ease-out
          xl:translate-x-0
          border-r border-brand-border/50
          shadow-2xl xl:shadow-none
          ${isOpen ? 'translate-x-0' : '-translate-x-full'}
        `}
        style={{
          paddingTop: 'var(--safe-area-inset-top, 0px)',
          paddingBottom: 'var(--safe-area-inset-bottom, 0px)',
          paddingLeft: 'var(--safe-area-inset-left, 0px)',
        }}
      >
        {/* Enhanced Header with Logo */}
        <div className="
          h-16 sm:h-20 
          flex items-center 
          px-4 sm:px-6 
          border-b border-brand-border/50
          bg-brand-surface
        ">
          <div className="flex items-center gap-3">
            {/* Logo/Brand Icon */}
            <div className="
              w-8 h-8 
              rounded-xl 
              bg-gradient-to-br from-brand-accent to-brand-accent-hover
              flex items-center justify-center
              shadow-lg
            ">
              <span className="text-white font-bold text-sm">V</span>
            </div>
            
            {/* Brand Text with Enhanced Typography */}
            <span className="
              text-lg sm:text-xl 
              font-extrabold 
              text-gradient
              select-none
            ">
              Vena Pictures
            </span>
          </div>
        </div>
        
        {/* Enhanced Navigation with Better Scrolling */}
        <nav className="
          flex-1 
          px-3 sm:px-4 
          py-4 sm:py-6 
          overflow-y-auto 
          overscroll-contain
        " 
        style={{ WebkitOverflowScrolling: 'touch' }}>
          <ul className="space-y-1">
            {visibleNavItems.map((item, index) => (
              <li key={item.view}>
                <a
                  href="#"
                  onClick={(e) => {
                    e.preventDefault();
                    setActiveView(item.view);
                    setIsOpen(false); // Auto-close on mobile
                  }}
                  className={`
                    flex items-center 
                    px-3 sm:px-4 
                    py-3 sm:py-3.5 
                    my-1 
                    text-sm font-semibold 
                    rounded-xl 
                    transition-all duration-200
                    group
                    relative
                    overflow-hidden
                    min-h-[48px]
                    ${activeView === item.view
                      ? 'bg-brand-accent text-white shadow-lg shadow-brand-accent/25' 
                      : 'text-brand-text-primary hover:bg-brand-input active:bg-brand-input/80'
                    }
                  `}
                  style={{ 
                    animationDelay: `${index * 50}ms`,
                    animation: isOpen ? 'slideInLeft 0.3s ease-out forwards' : 'none'
                  }}
                >
                  {/* Background shimmer effect for active item */}
                  {activeView === item.view && (
                    <div className="
                      absolute inset-0 
                      bg-gradient-to-r 
                      from-transparent 
                      via-white/10 
                      to-transparent 
                      -translate-x-full 
                      group-hover:translate-x-full 
                      transition-transform duration-1000
                    " />
                  )}
                  
                  {/* Enhanced Icon Container */}
                  <div className="
                    w-6 sm:w-7 
                    mr-3 sm:mr-4 
                    flex-shrink-0 
                    flex items-center justify-center
                    relative
                  ">
                    <item.icon className={`
                      w-5 h-5 sm:w-6 sm:h-6
                      transition-all duration-200
                      ${activeView !== item.view ? 'text-brand-text-secondary group-hover:text-brand-text-primary' : 'text-white'}
                    `} />
                  </div>
                  
                  {/* Enhanced Label */}
                  <span className="
                    flex-1 
                    truncate
                    relative
                    leading-tight
                  ">
                    {item.label}
                  </span>
                  
                  {/* Active indicator */}
                  {activeView === item.view && (
                    <div className="
                      w-1.5 h-6 
                      bg-white/30 
                      rounded-full
                      flex-shrink-0
                    " />
                  )}
                </a>
              </li>
            ))}
          </ul>
        </nav>
        
        {/* Enhanced Footer Section */}
        <div className="
          px-4 sm:px-6 
          py-4 sm:py-6 
          flex-shrink-0 
          border-t border-brand-border/50
          bg-brand-surface
        ">
          {/* Enhanced User Profile */}
          {currentUser && (
            <div className="
              flex items-center 
              gap-3 
              mb-4 sm:mb-6
              p-3
              rounded-xl
              bg-brand-input/50
              border border-brand-border/30
            ">
              <div className="
                w-10 h-10 sm:w-12 sm:h-12 
                rounded-full 
                bg-gradient-to-br from-brand-accent/20 to-brand-accent/10
                flex items-center justify-center
                border-2 border-brand-accent/20
                flex-shrink-0
              ">
                <UsersIcon className="w-5 h-5 sm:w-6 sm:h-6 text-brand-accent" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="
                  font-semibold 
                  text-sm sm:text-base 
                  text-brand-text-light
                  truncate
                  leading-tight
                ">
                  {currentUser.fullName}
                </p>
                <p className="
                  text-xs sm:text-sm 
                  text-brand-text-secondary
                  truncate
                  leading-tight
                ">
                  {currentUser.role}
                </p>
              </div>
            </div>
          )}
          
          {/* Enhanced Action Buttons */}
          <div className="flex items-center gap-2">
            {/* Enhanced Theme Toggle Button */}
            <button
              onClick={toggleTheme}
              className="
                p-3 sm:p-3.5
                rounded-xl 
                text-brand-text-primary 
                hover:bg-brand-input 
                active:bg-brand-input/80
                transition-all duration-200
                flex-shrink-0
                min-w-[48px] min-h-[48px]
                flex items-center justify-center
                group
                flex-1
              "
              aria-label={`Ganti ke mode ${theme === 'light' ? 'gelap' : 'terang'}`}
            >
              {theme === 'light' ? (
                <MoonIcon className="
                  w-5 h-5 sm:w-6 sm:h-6 
                  text-brand-text-secondary 
                  group-hover:text-brand-text-primary
                  transition-colors duration-200
                " />
              ) : (
                <SunIcon className="
                  w-5 h-5 sm:w-6 sm:h-6 
                  text-brand-text-secondary 
                  group-hover:text-brand-text-primary
                  transition-colors duration-200
                " />
              )}
            </button>
          </div>
        </div>
      </aside>
      
      <style>{`
        @keyframes slideInLeft {
          from {
            opacity: 0;
            transform: translateX(-20px);
          }
          to {
            opacity: 1;
            transform: translateX(0);
          }
        }
        
        /* Enhanced scrollbar for navigation */
        nav::-webkit-scrollbar {
          width: 6px;
        }
        
        nav::-webkit-scrollbar-track {
          background: transparent;
        }
        
        nav::-webkit-scrollbar-thumb {
          background: var(--color-border);
          border-radius: 3px;
        }
        
        nav::-webkit-scrollbar-thumb:hover {
          background: var(--color-text-secondary);
        }
        
        /* iOS momentum scrolling */
        @supports (-webkit-touch-callout: none) {
          nav {
            -webkit-overflow-scrolling: touch;
          }
        }
      `}</style>
    </>
  );
};

export default Sidebar;
