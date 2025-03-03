'use client';
import React from 'react';
import { useAccount } from 'wagmi';

export default function Home() {
  const { isConnected } = useAccount();

  return (
    <main className="min-h-screen px-8 py-0 pb-12 flex flex-1 flex-col items-center">
      <header className="w-full py-4 flex justify-between items-center">
        <div className="w-full py-4 flex justify-between items-center">
         
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