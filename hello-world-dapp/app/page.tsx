

// 'use client';
// import { ethers } from "ethers";
// import { useState, useEffect } from "react";
// import HelloWorldContractABI from "../contracts/HelloWorldContract.json";

// // Correct contract address from your deployment
// const CONTRACT_ADDRESS = "0x82a2ce96da8f45b6c59bec5059f6a3f4516ef653";
// // Polygon Mainnet block explorer base URL (adjust if on a different network)
// const EXPLORER_BASE_URL = "https://polygonscan.com/tx/";

// export default function Home() {
//   const [message, setMessage] = useState<string>("");
//   const [newMessage, setNewMessage] = useState<string>("");
//   const [contract, setContract] = useState<ethers.Contract | null>(null);
//   const [account, setAccount] = useState<string | null>(null);
//   const [error, setError] = useState<string | null>(null);
//   const [txHash, setTxHash] = useState<string | null>(null); // Store transaction hash

//   // Connect to MetaMask and initialize contract
//   const connectWallet = async () => {
//     if (window.ethereum) {
//       try {
//         const provider = new ethers.BrowserProvider(window.ethereum);
//         const accounts = await provider.send("eth_requestAccounts", []);
//         const signer = await provider.getSigner();
//         const ethContract = new ethers.Contract(
//           CONTRACT_ADDRESS,
//           HelloWorldContractABI,
//           signer
//         );

//         setContract(ethContract);
//         setAccount(accounts[0]);
//         setError(null);
//       } catch (error: any) {
//         console.error("Error connecting wallet:", error);
//         setError(`Failed to connect wallet: ${error.message}`);
//       }
//     } else {
//       alert("Please install MetaMask!");
//     }
//   };

//   // Fetch the current message from the contract
//   const fetchMessage = async () => {
//     if (contract) {
//       try {
//         const currentMessage = await contract.getMessage();
//         console.log("Raw response from getMessage:", currentMessage);
//         setMessage(currentMessage);
//         setError(null);
//       } catch (error: any) {
//         console.error("Error fetching message:", error);
//         setError(`Failed to fetch message: ${error.message}`);
//       }
//     }
//   };

//   // Update the message on the contract and store tx hash
//   const updateMessage = async () => {
//     if (contract && newMessage) {
//       try {
//         const tx = await contract.setMessage(newMessage);
//         setTxHash(tx.hash); // Store the transaction hash immediately
//         await tx.wait(); // Wait for transaction confirmation
//         setNewMessage(""); // Clear input
//         fetchMessage(); // Refresh message
//         setError(null);
//       } catch (error: any) {
//         console.error("Error updating message:", error);
//         setError(`Failed to update message: ${error.message}`);
//         setTxHash(null); // Clear tx hash on error
//       }
//     }
//   };

//   // Auto-connect and fetch message on load if wallet is already connected
//   useEffect(() => {
//     if (window.ethereum) {
//       connectWallet().then(() => {
//         fetchMessage();
//       }).catch((err) => {
//         console.error("Initial load error:", err);
//       });
//     }
//   }, []);

//   return (
//     <div style={{ padding: "20px", fontFamily: "Arial" }}>
//       <h1>Hello World DApp</h1>

//       {error && <p style={{ color: "red" }}>{error}</p>}

//       {!account ? (
//         <button onClick={connectWallet}>Connect Wallet</button>
//       ) : (
//         <div>
//           <p>Connected Account: {account}</p>
//           <p>Current Message: {message || "Loading..."}</p>

//           <input
//             type="text"
//             value={newMessage}
//             onChange={(e) => setNewMessage(e.target.value)}
//             placeholder="Enter new message"
//             style={{ marginRight: "10px" }}
//           />
//           <button onClick={updateMessage}>Update Message</button>

//           {txHash && (
//             <p>
//               Transaction confirmed! View on{" "}
//               <a
//                 href={`${EXPLORER_BASE_URL}${txHash}`}
//                 target="_blank"
//                 rel="noopener noreferrer"
//                 style={{ color: "blue", textDecoration: "underline" }}
//               >
//                 Polygonscan
//               </a>
//             </p>
//           )}
//         </div>
//       )}
//     </div>
//   );
// }

'use client';
import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import HelloWorldContractABI from '../contracts/HelloWorldContract.json';
import { ChevronRightIcon, ArrowPathIcon } from '@heroicons/react/24/solid';

const CONTRACT_ADDRESS = '0x82a2ce96da8f45b6c59bec5059f6a3f4516ef653';
const EXPLORER_BASE_URL = 'https://polygonscan.com/tx/';
const POLYGON_CHAIN_ID = '0x89'; // 137 in hex

export default function Home() {
  const [message, setMessage] = useState<string>('');
  const [newMessage, setNewMessage] = useState<string>('');
  const [account, setAccount] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [txHash, setTxHash] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const checkNetwork = async (): Promise<boolean> => {
    if (!window.ethereum) return false;
    const chainId = await window.ethereum.request({ method: 'eth_chainId' });
    if (chainId !== POLYGON_CHAIN_ID) {
      try {
        await window.ethereum.request({
          method: 'wallet_switchEthereumChain',
          params: [{ chainId: POLYGON_CHAIN_ID }],
        });
        return true;
      } catch (switchError: any) {
        if (switchError.code === 4902) {
          setError('Please add Polygon Mainnet to MetaMask.');
        } else {
          setError('Please switch to Polygon Mainnet in MetaMask.');
        }
        return false;
      }
    }
    return true;
  };

  const connectWallet = async () => {
    if (!window.ethereum) {
      setError('Please install MetaMask!');
      return;
    }

    try {
      const isNetworkCorrect = await checkNetwork();
      if (!isNetworkCorrect) return;

      const provider = new ethers.BrowserProvider(window.ethereum);
      const accounts = await provider.send('eth_requestAccounts', []);
      setAccount(accounts[0]);
      setError(null);
      return provider;
    } catch (err: any) {
      setError(`Failed to connect wallet: ${err.message}`);
      throw err;
    }
  };

  const getContract = async (provider: ethers.BrowserProvider, signer = false) => {
    const signerOrProvider = signer ? await provider.getSigner() : provider;
    return new ethers.Contract(CONTRACT_ADDRESS, HelloWorldContractABI, signerOrProvider);
  };

  const fetchMessage = async () => {
    try {
      const provider = await connectWallet();
      if (!provider) return;
      const contract = await getContract(provider);
      const currentMessage = await contract.getMessage();
      setMessage(currentMessage);
    } catch (err: any) {
      setError(`Failed to fetch message: ${err.message}`);
    }
  };

  const updateMessage = async () => {
    if (!newMessage) {
      setError('Please enter a message');
      return;
    }

    setLoading(true);
    setError(null);
    setTxHash(null);

    try {
      const provider = await connectWallet();
      if (!provider) return;
      const contract = await getContract(provider, true);
      const tx = await contract.setMessage(newMessage);
      setTxHash(tx.hash);
      await tx.wait();
      setNewMessage('');
      await fetchMessage();
    } catch (err: any) {
      if (err.code === 4001) {
        setError('Transaction rejected by user in MetaMask.');
      } else {
        setError(`Transaction failed: ${err.message}`);
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (window.ethereum) {
      fetchMessage();
    }
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-50 to-indigo-100 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-xl p-8 w-full max-w-md">
        <h1 className="text-3xl font-bold text-purple-600 mb-6 text-center">
          Hello World DApp
        </h1>

        {!account ? (
          <button
            onClick={connectWallet}
            className="w-full bg-purple-600 text-white py-2 rounded-lg hover:bg-purple-700 transition-colors flex items-center justify-center"
          >
            Connect Wallet
            <ChevronRightIcon className="w-5 h-5 ml-2" />
          </button>
        ) : (
          <>
            <div className="mb-6">
              <p className="text-gray-600">Connected Account:</p>
              <p className="text-sm text-purple-800 truncate">{account}</p>
            </div>

            <div className="mb-6">
              <p className="text-gray-600">Current Message:</p>
              <p className="text-xl font-semibold text-purple-800">
                {message || 'Loading...'}
              </p>
            </div>

            <div className="space-y-4">
              <input
                type="text"
                value={newMessage}
                onChange={(e) => setNewMessage(e.target.value)}
                placeholder="Enter new message"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                disabled={loading}
              />
              <button
                onClick={updateMessage}
                disabled={loading || !newMessage}
                className="w-full bg-purple-600 text-white py-2 rounded-lg hover:bg-purple-700 transition-colors flex items-center justify-center disabled:bg-gray-400"
              >
                {loading ? (
                  <>
                    <ArrowPathIcon className="w-5 h-5 mr-2 animate-spin" />
                    Processing...
                  </>
                ) : (
                  <>
                    Update Message
                    <ChevronRightIcon className="w-5 h-5 ml-2" />
                  </>
                )}
              </button>
            </div>
          </>
        )}

        {error && (
          <div className="mt-4 p-3 bg-red-100 text-red-700 rounded-lg">
            {error}
          </div>
        )}

        {txHash && (
          <div className="mt-4 p-3 bg-green-100 text-green-700 rounded-lg">
            Success! View on{' '}
            <a
              href={`${EXPLORER_BASE_URL}${txHash}`}
              target="_blank"
              rel="noopener noreferrer"
              className="underline break-all"
            >
              Polygonscan
            </a>
          </div>
        )}
      </div>
    </div>
  );
}