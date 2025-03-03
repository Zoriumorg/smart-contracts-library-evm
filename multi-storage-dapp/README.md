
# MultiStorageContract

A simple Solidity smart contract that allows users to store and retrieve an integer and a string associated with their Ethereum address. This project includes a Next.js + TypeScript frontend to interact with the contract on an EVM-compatible blockchain.

## Overview

The `MultiStorageContract` is a decentralized storage system where:
- Each Ethereum address can store one `uint256` (integer) and one `string`.
- Events are emitted when values are stored for tracking purposes.
- A frontend built with Next.js and TypeScript connects to the contract, enabling users to store and retrieve data via a web interface.

This project is ideal for learning smart contract development and blockchain frontend integration.

## Smart Contract: MultiStorageContract

### Code
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiStorageContract {
    // Mapping to store address => integer values
    mapping(address => uint256) public addressToValue;
    
    // Mapping to store address => string values
    mapping(address => string) public addressToString;
    
    // Declare events
    event ValueStored(address indexed user, uint256 value);
    event StringStored(address indexed user, string value);
    
    // Store an integer value
    function storeValue(uint256 _value) public {
        addressToValue[msg.sender] = _value;
        emit ValueStored(msg.sender, _value);
    }
    
    // Store a string value
    function storeString(string memory _str) public {
        addressToString[msg.sender] = _str;
        emit StringStored(msg.sender, _str);
    }
    
    // Get stored integer value for an address
    function getValue(address _addr) public view returns (uint256) {
        return addressToValue[_addr];
    }
    
    // Get stored string value for an address
    function getString(address _addr) public view returns (string memory) {
        return addressToString[_addr];
    }
}
```

### How It Works
- **Storage**: 
  - `addressToValue`: Maps an address to an integer.
  - `addressToString`: Maps an address to a string.
- **Functions**:
  - `storeValue(uint256 _value)`: Stores an integer for the caller’s address.
  - `storeString(string memory _str)`: Stores a string for the caller’s address.
  - `getValue(address _addr)`: Retrieves the integer for a given address.
  - `getString(address _addr)`: Retrieves the string for a given address.
- **Events**: 
  - `ValueStored`: Emitted when an integer is stored.
  - `StringStored`: Emitted when a string is stored.

### Testing with Remix
1. **Open Remix**:
   - Go to [Remix IDE](https://remix.ethereum.org/).
2. **Create File**:
   - In "File Explorer", click the "+" button and name it `MultiStorageContract.sol`.
   - Paste the contract code above.
3. **Compile**:
   - Go to "Solidity Compiler" tab (hammer icon).
   - Select version `0.8.20`.
   - Click "Compile MultiStorageContract.sol".
4. **Deploy**:
   - Go to "Deploy & Run Transactions" tab (play button icon).
   - Environment: Select "Injected Provider - MetaMask" (connect MetaMask to a testnet like Sepolia with test ETH).
   - Click "Deploy" (no constructor arguments required).
   - Confirm the transaction in MetaMask.
5. **Interact**:
   - **Fields to Fill**:
     - `storeValue`: Enter a number (e.g., `42`) in the `_value` field and click the button.
     - `storeString`: Enter a string (e.g., `"Hello"`) in the `_str` field and click the button.
     - `getValue`: Enter an Ethereum address (e.g., your MetaMask address) in the `_addr` field and click to retrieve the stored integer.
     - `getString`: Enter an Ethereum address in the `_addr` field and click to retrieve the stored string.
   - Check the Remix console for event logs (`ValueStored`, `StringStored`).

## Frontend: Next.js + TypeScript Setup

### Prerequisites
- **Node.js**: Version 18+ recommended.
- **MetaMask**: Browser extension for wallet interaction.
- **Testnet**: Access to a testnet (e.g., Sepolia) with test ETH.

### Setup Instructions
1. **Initialize Next.js Project**:
   ```bash
   npx create-next-app@latest multi-storage-dapp --typescript
   cd multi-storage-dapp
   ```
   - Answer prompts: Enable TypeScript, ESLint, Tailwind (optional), etc.
2. **Install Dependencies**:
   ```bash
   npm install ethers
   ```
   - `ethers`: Library to interact with the Ethereum blockchain.
3. **Get Contract ABI**:
   - In Remix, after compiling `MultiStorageContract.sol`, go to the "Solidity Compiler" tab.
   - Click "ABI" (copy the JSON) and save it as `abi.json` in `public/` or a dedicated folder (e.g., `lib/`).
   - Example ABI (shortened):
     ```json
     [
       {"inputs":[{"internalType":"uint256","name":"_value","type":"uint256"}],"name":"storeValue","outputs":[],"stateMutability":"nonpayable","type":"function"},
       {"inputs":[{"internalType":"string","name":"_str","type":"string"}],"name":"storeString","outputs":[],"stateMutability":"nonpayable","type":"function"},
       {"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"getValue","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
       {"inputs":[{"internalType":"address","name":"_addr","type":"address"}],"name":"getString","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"}
     ]
     ```
4. **Create Frontend**:
   - Replace `app/page.tsx` with the following:
     ```tsx
     "use client";

     import { useState, useEffect } from "react";
     import { ethers } from "ethers";
     import abi from "../lib/abi.json"; // Adjust path if different

     const CONTRACT_ADDRESS = "YOUR_DEPLOYED_CONTRACT_ADDRESS"; // Replace after deployment

     export default function Home() {
       const [provider, setProvider] = useState<ethers.BrowserProvider | null>(null);
       const [signer, setSigner] = useState<ethers.Signer | null>(null);
       const [contract, setContract] = useState<ethers.Contract | null>(null);
       const [account, setAccount] = useState<string | null>(null);
       const [intValue, setIntValue] = useState<string>("");
       const [strValue, setStrValue] = useState<string>("");
       const [fetchAddr, setFetchAddr] = useState<string>("");
       const [storedInt, setStoredInt] = useState<string>("");
       const [storedStr, setStoredStr] = useState<string>("");

       useEffect(() => {
         if (typeof window.ethereum !== "undefined") {
           const init = async () => {
             const provider = new ethers.BrowserProvider(window.ethereum);
             const signer = await provider.getSigner();
             const contract = new ethers.Contract(CONTRACT_ADDRESS, abi, signer);
             const accounts = await provider.send("eth_requestAccounts", []);
             setProvider(provider);
             setSigner(signer);
             setContract(contract);
             setAccount(accounts[0]);
           };
           init().catch(console.error);
         }
       }, []);

       const storeInteger = async () => {
         if (contract && intValue) {
           await contract.storeValue(intValue);
           alert("Integer stored!");
         }
       };

       const storeString = async () => {
         if (contract && strValue) {
           await contract.storeString(strValue);
           alert("String stored!");
         }
       };

       const getStoredData = async () => {
         if (contract && fetchAddr) {
           const int = await contract.getValue(fetchAddr);
           const str = await contract.getString(fetchAddr);
           setStoredInt(int.toString());
           setStoredStr(str);
         }
       };

       return (
         <div style={{ padding: "20px" }}>
           <h1>MultiStorage dApp</h1>
           <p>Connected Account: {account || "Not connected"}</p>

           <h2>Store Data</h2>
           <div>
             <input
               type="number"
               value={intValue}
               onChange={(e) => setIntValue(e.target.value)}
               placeholder="Enter integer"
             />
             <button onClick={storeInteger}>Store Integer</button>
           </div>
           <div>
             <input
               value={strValue}
               onChange={(e) => setStrValue(e.target.value)}
               placeholder="Enter string"
             />
             <button onClick={storeString}>Store String</button>
           </div>

           <h2>Retrieve Data</h2>
           <div>
             <input
               value={fetchAddr}
               onChange={(e) => setFetchAddr(e.target.value)}
               placeholder="Enter address"
             />
             <button onClick={getStoredData}>Get Data</button>
           </div>
           <p>Stored Integer: {storedInt}</p>
           <p>Stored String: {storedStr}</p>
         </div>
       );
     }
     ```
5. **Add ABI**:
   - Create `lib/abi.json` and paste the ABI from Remix.
6. **Run Frontend**:
   ```bash
   npm run dev
   ```
   - Open `http://localhost:3000` in a browser with MetaMask connected to the same network as the deployed contract.

### Configuration
- Replace `YOUR_DEPLOYED_CONTRACT_ADDRESS` in `page.tsx` with the address from Remix after deployment.
- Ensure MetaMask is connected to the testnet where the contract is deployed (e.g., Sepolia).

## Usage
1. **Deploy Contract**: Follow Remix instructions to deploy to a testnet.
2. **Start Frontend**: Run `npm run dev` and connect MetaMask.
3. **Interact**:
   - Enter an integer (e.g., `42`) and click "Store Integer".
   - Enter a string (e.g., `"Hello"`) and click "Store String".
   - Enter an address and click "Get Data" to retrieve stored values.
