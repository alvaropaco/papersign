import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';
import Image from 'next/image';

export function baseOptions(): BaseLayoutProps {
  return {
    nav: {
      title: (
        <span className="flex h-6 items-center">
          <Image
            src="/logo.png"
            alt="papersign.io"
            width={560}
            height={102}
            className="h-6 w-auto dark:hidden"
            priority
          />
          <Image
            src="/logo-dark.png"
            alt="papersign.io"
            width={560}
            height={102}
            className="hidden h-6 w-auto dark:block"
            priority
          />
        </span>
      ),
    },
    githubUrl: 'https://github.com/alvaropaco/papersign',
  };
}
