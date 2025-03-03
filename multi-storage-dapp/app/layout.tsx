// src/app/layout.tsx
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'

import AppKitProvider from '@/context/AppKitProvider'
import { headers } from 'next/headers'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Multi Storage DApp',
  description: 'Store and retrieve values on blockchain'
}

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const headersObj = await headers();
  const cookies = headersObj.get('cookie')

  return (
    <html lang="en">
      <body className={inter.className}>
        <AppKitProvider cookies={cookies}>
          {children}
        </AppKitProvider>
      </body>
    </html>
  )
}