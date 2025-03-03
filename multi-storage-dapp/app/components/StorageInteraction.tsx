'use client';

import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import { createConfig, WagmiProvider, useAccount, useDisconnect } from 'wagmi';
import { http, createPublicClient } from 'viem';
import { sepolia } from 'wagmi/chains';
import { Web3Modal } from '@web3modal/wagmi';
import MultiStorageContract from '../../abis/MultiStorageContract.json';

// Constants
const CONTRACT_ADDRESS = '0x8b85679f592cd1d2af0c022f4ce7ce850ff569f0';
const EXAMPLE_ADDRESS = '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4';

// Configure Wagmi with Viem
const projectId = 'a96edd3b4f16fffb290e8f26f8728b80'; // Your WalletConnect Project ID
const publicClient = createPublicClient({
  chain: sepolia,
  transport: http(), // Use Viem's HTTP transport for public RPC
});
const wagmiConfig = createConfig({
  chains: [sepolia],
  autoConnect: true,
  publicClient,
});
const modal = new Web3Modal({ projectId, wagmiConfig });

export default function StorageManager() {
  const [value, setValue] = useState('');
  const [str, setStr] = useState('');
  const [storedValue, setStoredValue] = useState('');
  const [storedString, setStoredString] = useState('');
  const [exampleValue, setExampleValue] = useState('');
  const [exampleString, setExampleString] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const { address, isConnected } = useAccount();
  const { disconnect } = useDisconnect();

  const getProvider = (): ethers.providers.Web3Provider => {
    if (typeof window !== 'undefined' && window.ethereum) {
      return new ethers.providers.Web3Provider(window.ethereum);
    }
    throw new Error('No wallet detected');
  };

  const storeValue = async () => {
    try {
      setError('');
      setSuccess('');
      const provider = getProvider();
      const signer = provider.getSigner();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, MultiStorageContract, signer);
      const tx = await contract.storeValue(ethers.BigNumber.from(value));
      await tx.wait();
      setSuccess(`Stored value ${value} successfully!`);
      setValue('');
    } catch (err: any) {
      setError('Error storing value: ' + (err.message || err));
    }
  };

  const storeString = async () => {
    try {
      setError('');
      setSuccess('');
      const provider = getProvider();
      const signer = provider.getSigner();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, MultiStorageContract, signer);
      const tx = await contract.storeString(str);
      await tx.wait();
      setSuccess(`Stored string "${str}" successfully!`);
      setStr('');
    } catch (err: any) {
      setError('Error storing string: ' + (err.message || err));
    }
  };

  const getStoredData = async () => {
    try {
      setError('');
      const provider = getProvider();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, MultiStorageContract, provider);
      if (address) {
        const val = await contract.getValue(address);
        const strVal = await contract.getString(address);
        setStoredValue(val.toString());
        setStoredString(strVal);
      }
    } catch (err: any) {
      setError('Error fetching data: ' + (err.message || err));
    }
  };

  const getExampleData = async () => {
    try {
      const provider = getProvider();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, MultiStorageContract, provider);
      const val = await contract.getValue(EXAMPLE_ADDRESS);
      const strVal = await contract.getString(EXAMPLE_ADDRESS);
      setExampleValue(val.toString());
      setExampleString(strVal);
    } catch (err: any) {
      setError('Error fetching example data: ' + (err.message || err));
    }
  };

  useEffect(() => {
    if (isConnected && address) {
      getStoredData();
      getExampleData();
    }
  }, [isConnected, address]);

  return (
    <WagmiProvider config={wagmiConfig}>
      <div className="w-full max-w-lg mx-auto bg-white rounded-xl shadow-lg p-6">
        <h1 className="text-3xl font-bold text-gray-800 mb-6 text-center">Multi Storage DApp</h1>

        {/* Wallet Connection */}
        <div className="mb-6">
          {isConnected ? (
            <div className="flex items-center justify-between">
              <span className="text-sm text-gray-600">
                Connected: {address?.slice(0, 6)}...{address?.slice(-4)}
              </span>
              <button
                onClick={() => disconnect()}
                className="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition"
              >
                Disconnect
              </button>
            </div>
          ) : (
            <button
              onClick={() => modal.open()}
              className="w-full px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
            >
              Connect Wallet
            </button>
          )}
        </div>

        {/* Store Value */}
        <div className="mb-6">
          <input
            type="number"
            value={value}
            onChange={(e) => setValue(e.target.value)}
            placeholder="Enter number (e.g., 50)"
            className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            onClick={storeValue}
            disabled={!isConnected || !value}
            className="w-full mt-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition disabled:bg-gray-400"
          >
            Store Value
          </button>
        </div>

        {/* Store String */}
        <div className="mb-6">
          <input
            type="text"
            value={str}
            onChange={(e) => setStr(e.target.value)}
            placeholder="Enter string (e.g., Ankita)"
            className="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            onClick={storeString}
            disabled={!isConnected || !str}
            className="w-full mt-2 px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition disabled:bg-gray-400"
          >
            Store String
          </button>
        </div>

        {/* Get Stored Data */}
        <button
          onClick={getStoredData}
          disabled={!isConnected}
          className="w-full mb-6 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition disabled:bg-gray-400"
        >
          Get Your Stored Data
        </button>

        {/* Display Data */}
        {(storedValue || storedString) && (
          <div className="mb-6 p-4 bg-gray-50 rounded-lg">
            <h2 className="text-lg font-semibold text-gray-700">Your Data</h2>
            {storedValue && <p className="text-gray-600">Value: {storedValue}</p>}
            {storedString && <p className="text-gray-600">String: {storedString}</p>}
          </div>
        )}

        {(exampleValue || exampleString) && (
          <div className="mb-6 p-4 bg-blue-50 rounded-lg">
            <h2 className="text-lg font-semibold text-gray-700">Example Data</h2>
            <p className="text-gray-600">
              Address: {EXAMPLE_ADDRESS.slice(0, 6)}...{EXAMPLE_ADDRESS.slice(-4)}
            </p>
            <p className="text-gray-600">Value: {exampleValue}</p>
            <p className="text-gray-600">String: {exampleString}</p>
          </div>
        )}

        {/* Messages */}
        {error && (
          <div className="p-3 bg-red-100 text-red-700 rounded-lg mb-4">{error}</div>
        )}
        {success && (
          <div className="p-3 bg-green-100 text-green-700 rounded-lg mb-4">{success}</div>
        )}
      </div>
    </WagmiProvider>
  );
}