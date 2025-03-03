
"use client"
import { useState, useEffect } from 'react';
import { ethers } from 'ethers'; // Import ethers directly
import Web3Modal from 'web3modal';
import { SimpleStorageABI } from '../lib/SimpleStorageABI';
import { ChevronRightIcon } from '@heroicons/react/24/solid';

export default function Home() {
  const [value, setValue] = useState<string>('');
  const [storedValue, setStoredValue] = useState<string>('');
  const [error, setError] = useState<string>('');
  const [txHash, setTxHash] = useState<string>('');
  const [loading, setLoading] = useState(false);

  // Replace with your deployed contract address
  const contractAddress = '0xf41f53fcadd447d0ea0464637d1a0dfed3b75542';

  const connectWallet = async () => {
    try {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      // Use BrowserProvider for ethers v6
      const provider = new ethers.BrowserProvider(connection);
      return provider;
    } catch (err) {
      setError('Failed to connect wallet');
      throw err;
    }
  };

  const fetchValue = async () => {
    try {
      const provider = await connectWallet();
      const contract = new ethers.Contract(contractAddress, SimpleStorageABI, provider);
      const currentValue = await contract.getValue();
      setStoredValue(currentValue.toString());
    } catch (err) {
      setError('Failed to fetch value');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setTxHash('');
    setLoading(true);

    try {
      const provider = await connectWallet();
      const signer = await provider.getSigner(); // getSigner is async in v6
      const contract = new ethers.Contract(contractAddress, SimpleStorageABI, signer);

      const tx = await contract.setValue(value);
      setTxHash(tx.hash);
      await tx.wait();

      setValue('');
      await fetchValue();
    } catch (err: any) {
      setError(err.message || 'Transaction failed');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchValue();
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-indigo-600 mb-6 text-center">
          Simple Storage DApp
        </h1>

        <div className="mb-6">
          <p className="text-gray-600">Current Stored Value:</p>
          <p className="text-2xl font-semibold text-indigo-800">{storedValue || '0'}</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <input
              type="number"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              placeholder="Enter a number"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              disabled={loading}
            />
          </div>

          <button
            type="submit"
            disabled={loading || !value}
            className="w-full bg-indigo-600 text-white py-2 rounded-lg hover:bg-indigo-700 transition-colors flex items-center justify-center disabled:bg-gray-400"
          >
            {loading ? (
              'Processing...'
            ) : (
              <>
                Store Value
                <ChevronRightIcon className="w-5 h-5 ml-2" />
              </>
            )}
          </button>
        </form>

        {error && (
          <div className="mt-4 p-3 bg-red-100 text-red-700 rounded-lg">
            {error}
          </div>
        )}

        {txHash && (
          <div className="mt-4 p-3 bg-green-100 text-green-700 rounded-lg">
            Success! Transaction Hash:{' '}
            <a
              href={`https://polygonscan.com/tx/${txHash}`}
              target="_blank"
              rel="noopener noreferrer"
              className="underline break-all"
            >
              {txHash}
            </a>
          </div>
        )}
      </div>
    </div>
  );
}