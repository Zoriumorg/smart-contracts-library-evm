# Hello World DApp

A simple decentralized application (DApp) built with Next.js and TypeScript to interact with the `HelloWorldContract` smart contract on Ethereum (Sepolia testnet).

## Features
- **Read Message**: Displays the current `message` from the contract.
- **Update Message**: Allows users to set a new `message` (requires gas).

## Prerequisites
- **Node.js**: v18+ (check with `node -v`).
- **MetaMask**: Browser extension for wallet connectivity.
- **Deployed Contract**: Deploy `HelloWorldContract.sol` on Sepolia and note its address.
- **Sepolia Test ETH**: Get from a faucet (e.g., https://sepoliafaucet.com).

## Smart Contract
The contract (`HelloWorldContract.sol`) is deployed at:  
**Address**: `YOUR_CONTRACT_ADDRESS_HERE` (replace with your deployed address).  
**ABI**: Stored in `contracts/HelloWorldContract.json`.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorldContract {
    string public message;
    constructor() { message = "Hello, World!"; }
    function getMessage() public view returns (string memory) { return message; }
    function setMessage(string memory newMessage) public { message = newMessage; }
}
```

## Setup Instructions
1. **Clone the Repo** (if applicable):
   ```bash
   git clone <repo-url>
   cd hello-world-dapp
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Update Contract Address**:
   - Open `pages/index.tsx`.
   - Replace `YOUR_CONTRACT_ADDRESS_HERE` with your deployed contract address.

4. **Run the App**:
   ```bash
   npm run dev
   ```
   - Visit `http://localhost:3000`.

5. **Connect MetaMask**:
   - Switch to Sepolia testnet.
   - Click "Connect Wallet" on the page.

## How It Works
- **Connect Wallet**: Uses `ethers.js` to connect to MetaMask and initialize the contract.
- **Fetch Message**: Calls `getMessage()` (no gas, read-only).
- **Update Message**: Calls `setMessage()` (requires gas, prompts MetaMask).

## Key Files
- `pages/index.tsx`: Main frontend logic.
- `contracts/HelloWorldContract.json`: Contract ABI.
- `styles/globals.css`: Default styles (customize as needed).

## Gas Fees
- **Reading (`getMessage`)**: Free (no transaction).
- **Writing (`setMessage`)**: Costs gas (e.g., ~30,000–50,000 gas on Sepolia, depending on string length and gas price). Check MetaMask for estimates.

## Troubleshooting
- **MetaMask Not Detected**: Ensure it’s installed and logged in.
- **Wrong Network**: Switch to Sepolia in MetaMask.
- **No Test ETH**: Get from a Sepolia faucet.
- **Errors**: Check browser console for logs.

## Next Steps
- Style the UI with CSS or a framework like Tailwind.
- Add error handling (e.g., loading states).
- Deploy to Vercel (`npm run build && vercel`).

Happy coding! Let me know if you need help.
```

---

### Step 8: Replace `CONTRACT_ADDRESS`
In `pages/index.tsx`, replace `YOUR_CONTRACT_ADDRESS_HERE` with your actual contract address from Remix (e.g., `0x1234...`).

---

### What You Get
- **UI**: A simple page showing the current message, an input to update it, and a connect button.
- **Functionality**: Connects to MetaMask, reads from the contract, and writes to it.
- **Type Safety**: TypeScript ensures robust code.

### Testing
- Open `http://localhost:3000`.
- Connect MetaMask (Sepolia).
- See "Hello, World!" as the current message.
- Enter a new message (e.g., "Hi, Blockchain!") and click "Update Message". Confirm the transaction in MetaMask.


## transcation show in this URL 
https://polygonscan.com/tx/0xdfa5a3a667a027ccf54c2a04db74287fc91ac5d01dd4b3c6c282a794846c953b