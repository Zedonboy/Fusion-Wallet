import { Inter } from 'next/font/google'
import localFont from 'next/font/local'
import clsx from 'clsx'
import Script from 'next/script'

import { Providers } from '@/app/providers'
import { Layout } from '@/components/Layout'

import '@/styles/tailwind.css'

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
})

// Use local version of Lexend so that we can use OpenType features
const lexend = localFont({
  src: '../fonts/lexend.woff2',
  display: 'swap',
  variable: '--font-lexend',
})

export const metadata = {
  title: {
    template: '%s - Docs',
    default: 'Fusion Wallet - Documentation',
  },
  description:
    'Fusion Wallet is a comprehensive cryptocurrency wallet solution with advanced security features, multi-chain support, and seamless user experience. Built with Flutter for cross-platform compatibility and enhanced performance.',
}

export default function RootLayout({ children }) {
  return (
    <html
      lang="en"
      className={clsx('h-full antialiased', inter.variable, lexend.variable)}
      suppressHydrationWarning
    >
      <head>
        <Script
          id='firebase-script'
          type="module"
          strategy="afterInteractive"
          dangerouslySetInnerHTML={{
            __html: `
              import { initializeApp } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-app.js";
              import { getAnalytics } from "https://www.gstatic.com/firebasejs/11.8.1/firebase-analytics.js";

              const firebaseConfig = {
                apiKey: "AIzaSyDFN7UK5tBf1uH_GRb_tqLCsnDA12ojWxE",
                authDomain: "fusion-docs-83fec.firebaseapp.com",
                projectId: "fusion-docs-83fec",
                storageBucket: "fusion-docs-83fec.firebasestorage.app",
                messagingSenderId: "597344932857",
                appId: "1:597344932857:web:64eae3e98f416a5dc7a328",
                measurementId: "G-WFDRRK0K9R"
              };

              const app = initializeApp(firebaseConfig);
              const analytics = getAnalytics(app);
            `,
          }}
        />
      </head>
      <body className="flex min-h-full bg-white dark:bg-slate-900">
        <Providers>
          <Layout>{children}</Layout>
        </Providers>
      </body>
    </html>
  )
}
