// src/context/AppKitProvider.tsx
'use client'

import React, { ReactNode } from 'react'
import { wagmiAdapter, projectId } from '@/config/wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { createAppKit } from '@reown/appkit/react'
import { mainnet, polygon } from '@reown/appkit/networks'
import { cookieToInitialState, WagmiProvider } from 'wagmi'

// Initialize query client
const queryClient = new QueryClient()

// App metadata
const metadata = {
  name: 'Multi Storage DApp',
  description: 'Store and retrieve values on blockchain',
  url: 'https://multi-storage-dapp.vercel.app',
  icons: ['https://avatars.githubusercontent.com/u/179229932']
}

// Create AppKit modal
const modal = createAppKit({
  adapters: [wagmiAdapter],
  projectId,
  networks: [mainnet, polygon],
  defaultNetwork: mainnet,
  metadata,
  features: {
    analytics: true
  }
})

interface ContextProviderProps {
  children: ReactNode;
  cookies: string | null;
}

export default function AppKitProvider({ children, cookies }: ContextProviderProps) {
  const initialState = cookieToInitialState(wagmiAdapter.wagmiConfig, cookies)

  return (
    <WagmiProvider config={wagmiAdapter.wagmiConfig} initialState={initialState}>
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    </WagmiProvider>
  )
}