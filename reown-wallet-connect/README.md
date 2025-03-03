# Reown Wallet Connect - Next.js Integration with Reown AppKit

This project demonstrates how to integrate [Reown AppKit](https://docs.reown.com/appkit/overview) into a Next.js frontend to enable seamless Web3 wallet connections using Wagmi. It supports connecting to multiple blockchain networks (e.g., Mainnet, Arbitrum, Polygon) and provides a simple UI to connect wallets and switch networks.

## Features
- Wallet connection via Reown AppKit
- Network switching (Mainnet, Arbitrum, Polygon)
- Server-Side Rendering (SSR) support
- Social logins (Google, X, GitHub, Discord, Farcaster) and email authentication
- Responsive and customizable UI

## Prerequisites
- **Node.js**: Version 18.x or higher
- **Next.js**: Version 15.2.0 or compatible
- A [Reown Cloud](https://cloud.reown.com) account to obtain a `projectId`

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/reown-wallet-connect.git
   cd reown-wallet-connect
   ```

2. **Install Dependencies**
   Run the following command to install all required packages:
   ```bash
   npm install
   ```

3. **Set Up Environment Variables**
   - Create a `.env.local` file in the root directory.
   - Add your Reown AppKit `projectId` obtained from [Reown Cloud](https://cloud.reown.com):
     ```env
     NEXT_PUBLIC_PROJECT_ID=your_project_id_here
     ```
   - Example:
     ```
     NEXT_PUBLIC_PROJECT_ID=e126b6f65417f7a5a77337b84ce57112
     ```

## Project Structure
```
reown-wallet-connect/
├── context/
│   └── index.tsx        # ContextProvider for Wagmi and AppKit setup
├── config/
│   └── index.ts         # WagmiAdapter configuration
├── app/
│   ├── globals.css      # Global styles
│   ├── layout.tsx       # Root layout with ContextProvider
│   └── page.tsx         # Home page with wallet connect UI
├── package.json         # Dependencies and scripts
├── .env.local           # Environment variables (not tracked)
└── README.md            # This file
```

## Integration Steps

### 1. Configure Wagmi Adapter
The Wagmi Adapter is set up in `config/index.ts` to handle blockchain networks and SSR compatibility.

- **File**: `config/index.ts`
- **Key Configurations**:
  - `projectId`: Loaded from environment variables.
  - `networks`: Supports Mainnet, Arbitrum, and Polygon (customizable).
  - `storage`: Uses `cookieStorage` for SSR.



### 2. Set Up Context Provider
The `ContextProvider` in `context/index.tsx` initializes Reown AppKit and wraps the app with Wagmi and React Query providers.

- **File**: `context/index.tsx`
- **Key Configurations**:
  - `createAppKit`: Initializes the wallet modal with adapters, networks, and metadata.
  - `metadata`: Defines app info (name, description, URL, icons).
  - `features`: Enables analytics, email, and social logins.



### 3. Wrap the App with ContextProvider
The root layout (`app/layout.tsx`) wraps the app with the `ContextProvider` for global access to wallet functionality.

- **File**: `app/layout.tsx`


### 4. Add Wallet UI to the Home Page
The home page (`app/page.tsx`) includes the `<w3m-button />` for wallet connection and `<w3m-network-button />` for network switching.

- **File**: `app/page.tsx`

```ts
'use client';
import React from 'react';
import { useAccount } from 'wagmi';

export default function Home() {
  const { isConnected } = useAccount();

  return (
    <main className="min-h-screen px-8 py-0 pb-12 flex flex-1 flex-col items-center">
      <header className="w-full py-4 flex justify-between items-center">
        <div className="w-full py-4 flex justify-between items-center">
          {/* Add header content if needed */}
        </div>
      </header>
      <w3m-button />
      {isConnected && (
        <div className="grid bg-white border border-gray-200 rounded-lg overflow-hidden shadow-sm">
          <w3m-network-button />
        </div>
      )}
    </main>
  );
}
```

## Usage

1. **Run the Development Server**
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000) in your browser.

2. **Connect a Wallet**
   - Click the `<w3m-button />` to open the wallet modal.
   - Choose a wallet (e.g., MetaMask) or use social/email login.

3. **Switch Networks**
   - Once connected, the `<w3m-network-button />` appears.
   - Use it to switch between Mainnet, Arbitrum, and Polygon.

## Customization
- **Networks**: Add or remove networks in `config/index.ts` and `context/index.tsx` by updating the `networks` array.
- **Metadata**: Update the `metadata` object in `context/index.tsx` with your app’s details.
- **Features**: Modify the `features` object in `createAppKit` to enable/disable social logins, email, etc.
- **Styling**: Adjust `globals.css` or component classes for UI customization.

## Dependencies
- `@reown/appkit`: Core AppKit library
- `@reown/appkit-adapter-wagmi`: Wagmi adapter for AppKit
- `wagmi`: Web3 library for wallet interactions
- `@tanstack/react-query`: State management for async data
- `next`: Next.js framework

See `package.json` for full dependency list and versions.

## Troubleshooting
- **Project ID Error**: Ensure `NEXT_PUBLIC_PROJECT_ID` is set in `.env.local`.
- **SSR Issues**: Verify `ssr: true` in `WagmiAdapter` and cookie handling in `ContextProvider`.
- **Modal Not Showing**: Confirm `createAppKit` is called in `context/index.tsx`.

## Resources
- [Reown AppKit Docs](https://docs.reown.com/appkit/next/core/installation)
- [Wagmi Documentation](https://wagmi.sh/)
- [Next.js Documentation](https://nextjs.org/docs)



