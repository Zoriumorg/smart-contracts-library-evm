# Simple Storage DApp

A decentralized application built with Next.js, TypeScript, and Tailwind CSS that interacts with a SimpleStorage smart contract on Ethereum.

## Features
- Store a single integer value on the blockchain
- Retrieve the current stored value
- Elegant UI with error handling and transaction tracking
- Connects via MetaMask

## Prerequisites
- Node.js (v16+)
- MetaMask browser extension
- Deployed SimpleStorage contract (see contract section)

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd simple-storage-dapp
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure contract address**
   - Deploy the `SimpleStorage.sol` contract in Remix
   - Copy the deployed address
   - Update `contractAddress` in `pages/index.tsx`

4. **Run locally**
   ```bash
   npm run dev
   ```
   Open `http://localhost:3000` in your browser

## Deployment
- Build: `npm run build`
- Deploy to Vercel: `vercel`

## Project Structure
- `pages/index.tsx`: Main frontend component
- `lib/SimpleStorageABI.ts`: Contract ABI
- `styles/globals.css`: Tailwind CSS configuration
- `tailwind.config.js`: Tailwind setup

## Usage
1. Connect MetaMask to a test network (e.g., Sepolia)
2. Enter a number in the input field
3. Click "Store Value"
4. View transaction status and current value

## Error Handling
- Displays errors for failed wallet connections or transactions
- Shows transaction hash with Etherscan link on success

## Dependencies
- `ethers`: Ethereum library
- `web3modal`: Wallet connection
- `tailwindcss`: Styling
- `@heroicons/react`: Icons
```

### Notes:
- Replace `YOUR_CONTRACT_ADDRESS_HERE` in `index.tsx` with your deployed contract address.
- The frontend uses Sepolia testnet by default; adjust the Etherscan link if using a different network.
- Test with MetaMask funded with test ETH (e.g., from Sepolia faucet).

