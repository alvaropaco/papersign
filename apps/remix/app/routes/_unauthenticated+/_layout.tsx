import backgroundPattern from '@documenso/assets/images/background-pattern.png';
import { Link, Outlet } from 'react-router';

import { BrandingLogo } from '~/components/general/branding-logo';
import { PublicLegalLinks } from '~/components/general/public-legal-links';

export default function Layout() {
  return (
    <main className="relative flex min-h-screen flex-col items-center justify-between overflow-hidden px-4 py-8 md:p-10 lg:p-12">
      <div className="absolute -inset-[min(600px,max(400px,60vw))] -z-[1] flex items-center justify-center opacity-70">
        <img
          src={backgroundPattern}
          alt=""
          className="dark:brightness-95 dark:contrast-[70%] dark:hue-rotate-180 dark:invert"
          style={{
            mask: 'radial-gradient(rgba(255, 255, 255, 1) 0%, transparent 80%)',
            WebkitMask: 'radial-gradient(rgba(255, 255, 255, 1) 0%, transparent 80%)',
          }}
        />
      </div>

      <div className="z-10 flex w-full justify-center">
        <Link to="/">
          <BrandingLogo className="h-8 w-auto" />
        </Link>
      </div>

      <div className="flex w-full flex-1 flex-col items-center justify-center py-8">
        <div className="relative flex w-full items-center justify-center">
          <Outlet />
        </div>
      </div>

      <footer className="z-10 mt-8 w-full">
        <PublicLegalLinks />
      </footer>
    </main>
  );
}
