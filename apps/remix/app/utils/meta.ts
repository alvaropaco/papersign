import { APP_NAME, NEXT_PUBLIC_WEBAPP_URL } from '@documenso/lib/constants/app';
import { i18n, type MessageDescriptor } from '@lingui/core';

export const appMetaTags = (title?: MessageDescriptor) => {
  const description =
    'Send, sign, and manage documents with Papersign. Create reusable templates, collaborate with your team, and integrate electronic signatures into your workflows.';

  return [
    {
      title: title ? `${i18n._(title)} - ${APP_NAME}` : APP_NAME,
    },
    {
      name: 'description',
      content: description,
    },
    {
      name: 'keywords',
      content:
        'Papersign, electronic signatures, digital signatures, document signing, reusable templates, document workflows, signing API',
    },
    {
      name: 'author',
      content: APP_NAME,
    },
    {
      name: 'robots',
      content: 'index, follow',
    },
    {
      property: 'og:site_name',
      content: APP_NAME,
    },
    {
      property: 'og:title',
      content: 'Papersign - Electronic signatures and document workflows',
    },
    {
      property: 'og:description',
      content: description,
    },
    {
      property: 'og:image',
      content: `${NEXT_PUBLIC_WEBAPP_URL()}/opengraph-image.jpg`,
    },
    {
      property: 'og:type',
      content: 'website',
    },
    {
      name: 'twitter:card',
      content: 'summary_large_image',
    },
    {
      name: 'twitter:description',
      content: description,
    },
    {
      name: 'twitter:image',
      content: `${NEXT_PUBLIC_WEBAPP_URL()}/opengraph-image.jpg`,
    },
  ];
};
