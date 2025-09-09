import React, { useEffect } from 'react';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  size?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl' | '5xl';
}

const XIcon = (props: React.SVGProps<SVGSVGElement>) => (
    <svg {...props} xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M18 6 6 18"></path><path d="m6 6 12 12"></path></svg>
);

const Modal: React.FC<ModalProps> = ({ isOpen, onClose, title, children, footer, size = '2xl' }) => {
  
  // Enhanced keyboard and body scroll handling
  useEffect(() => {
    if (isOpen) {
      // Prevent body scroll when modal is open
      document.body.style.overflow = 'hidden';
      document.body.style.paddingRight = 'var(--scrollbar-width, 0px)';
      
      const handleKeyDown = (e: KeyboardEvent) => {
        if (e.key === 'Escape') {
          onClose();
        }
      };
      
      document.addEventListener('keydown', handleKeyDown);
      
      return () => {
        document.removeEventListener('keydown', handleKeyDown);
        document.body.style.overflow = '';
        document.body.style.paddingRight = '';
      };
    }
  }, [isOpen, onClose]);

  if (!isOpen) return null;
  
  const sizeClasses = {
    sm: 'max-w-sm w-full',
    md: 'max-w-md w-full',
    lg: 'max-w-lg w-full',
    xl: 'max-w-xl w-full',
    '2xl': 'max-w-2xl w-full',
    '3xl': 'max-w-3xl w-full',
    '4xl': 'max-w-4xl w-full',
    '5xl': 'max-w-5xl w-full',
  };

  return (
    <div 
      className="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex justify-center items-center p-4 sm:p-6 md:p-8 transition-all duration-300" 
      onClick={onClose} 
      role="dialog" 
      aria-modal="true" 
      aria-labelledby="modal-title"
      style={{
        paddingTop: 'calc(1rem + var(--safe-area-inset-top, 0px))',
        paddingBottom: 'calc(1rem + var(--safe-area-inset-bottom, 0px))',
        paddingLeft: 'calc(1rem + var(--safe-area-inset-left, 0px))',
        paddingRight: 'calc(1rem + var(--safe-area-inset-right, 0px))',
      }}
    >
      <div 
        className={`
          bg-brand-surface text-brand-text-primary 
          rounded-2xl sm:rounded-3xl 
          shadow-2xl 
          ${sizeClasses[size]} 
          max-h-[calc(100vh-2rem)] 
          sm:max-h-[calc(100vh-4rem)] 
          md:max-h-[calc(100vh-6rem)]
          flex flex-col 
          transform transition-all duration-300 
          animate-scale-in 
          border border-brand-border/50
          backdrop-blur-xl
        `} 
        onClick={e => e.stopPropagation()}
      >
        {/* Enhanced Header with better mobile spacing */}
        <div className="
          flex justify-between items-center 
          p-4 sm:p-6 
          border-b border-brand-border/50 
          flex-shrink-0
          bg-brand-surface/90 backdrop-blur-sm
          rounded-t-2xl sm:rounded-t-3xl
        ">
          <h3 
            id="modal-title" 
            className="
              text-lg sm:text-xl 
              font-semibold 
              text-brand-text-light
              truncate
              pr-4
            "
          >
            {title}
          </h3>
          <button 
            onClick={onClose} 
            className="
              text-brand-text-secondary 
              hover:text-brand-text-light 
              active:text-brand-text-light
              p-2
              rounded-full 
              hover:bg-brand-input 
              active:bg-brand-input
              transition-all duration-200
              flex-shrink-0
              min-w-[44px] min-h-[44px]
              flex items-center justify-center
              focus:outline-none
              focus:ring-2 focus:ring-brand-accent/20
              focus:bg-brand-input
              -mr-2
            " 
            aria-label="Close modal"
            type="button"
          >
            <XIcon className="w-5 h-5" />
          </button>
        </div>
        
        {/* Enhanced Content Area with better scrolling */}
        <div className="
          p-4 sm:p-6 
          overflow-y-auto 
          flex-1
          modal-content-area
          overscroll-contain
          scroll-smooth
        " 
        style={{
          WebkitOverflowScrolling: 'touch',
          scrollbarWidth: 'thin'
        }}>
          {children}
        </div>
        
        {/* Enhanced Footer */}
        {footer && (
          <div className="
            flex justify-end items-center 
            p-4 sm:p-6 
            bg-brand-bg/50 
            border-t border-brand-border/50 
            rounded-b-2xl sm:rounded-b-3xl 
            flex-shrink-0
            backdrop-blur-sm
            gap-3
          ">
            {footer}
          </div>
        )}
      </div>
      
      <style>{`
        @keyframes scaleIn {
          from { 
            transform: scale(0.95) translateY(10px); 
            opacity: 0; 
          }
          to { 
            transform: scale(1) translateY(0); 
            opacity: 1; 
          }
        }
        
        .animate-scale-in {
          animation: scaleIn 0.3s cubic-bezier(0.4, 0, 0.2, 1) forwards;
        }
        
        /* Enhanced mobile modal styles */
        @media (max-width: 640px) {
          .modal-content-area {
            /* Better mobile scrolling */
            -webkit-overflow-scrolling: touch;
            overscroll-behavior: contain;
          }
        }
        
        /* Enhanced scrollbar for modal content */
        .modal-content-area::-webkit-scrollbar {
          width: 6px;
        }
        
        .modal-content-area::-webkit-scrollbar-track {
          background: transparent;
        }
        
        .modal-content-area::-webkit-scrollbar-thumb {
          background: var(--color-border);
          border-radius: 3px;
        }
        
        .modal-content-area::-webkit-scrollbar-thumb:hover {
          background: var(--color-text-secondary);
        }
        
        /* iOS specific optimizations */
        @supports (-webkit-touch-callout: none) {
          .modal-content-area {
            -webkit-overflow-scrolling: touch;
          }
        }
      `}</style>
    </div>
  );
};

export default Modal;