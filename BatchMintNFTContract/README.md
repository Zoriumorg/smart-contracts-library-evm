# BatchMintNFT Smart Contract

## Overview
The `BatchMintNFT` smart contract is an ERC721-compliant non-fungible token (NFT) contract designed for batch minting a limited collection of NFTs (up to 17). It leverages OpenZeppelin's `ERC721URIStorage` for on-chain metadata storage, `Ownable` for access control, and `Counters` for token ID management. The contract supports two minting functions: `batchMint` (to multiple recipients) and `batchMintToSender` (to the caller), with a maximum supply of 17 NFTs. It also includes a `withdraw` function for the owner to retrieve any ETH sent to the contract. This contract is ideal for artists or creators launching small, exclusive NFT collections with off-chain metadata hosted on IPFS.

### Real-World Use Case
The `BatchMintNFT` contract is used to create and distribute unique digital assets, such as digital art, collectibles, or membership tokens, in a controlled and secure manner. Key real-world applications include:
- **Art Collections**: Artists can mint a limited series of digital artworks (e.g., abstract paintings) and distribute them to collectors or retain them for sale on marketplaces like OpenSea.
- **Event Tickets**: Organizers can issue NFT-based tickets with unique metadata for events, ensuring authenticity and transferability.
- **Membership Tokens**: Communities or clubs can mint NFTs as membership passes, granting holders exclusive access to perks or services.
- **Gaming Assets**: Game developers can create unique in-game items or characters as NFTs, with metadata defining their attributes.

The contract’s batch minting capability reduces gas costs compared to minting NFTs individually, making it efficient for small collections. The `onlyOwner` restriction ensures only the creator can mint or withdraw funds, preventing unauthorized actions. By storing metadata URIs on-chain (via `ERC721URIStorage`), the contract links NFTs to off-chain data (e.g., IPFS-hosted JSON files), ensuring permanence and decentralization.

## Prerequisites
Before deploying or testing the contract, ensure you have:
- **Remix IDE**: Access [remix.ethereum.org](https://remix.ethereum.org/) for deployment and testing.
- **MetaMask**: Installed and configured for Sepolia testnet deployment (optional).
- **Test ETH**: Obtain test ETH from a [Sepolia Faucet](https://sepoliafaucet.com/) for testnet deployment.
- **IPFS Metadata**: Prepare 17 JSON metadata files (e.g., `abstract01.json` to `abstract17.json`) hosted on IPFS, with URIs like `ipfs://<CID>/abstractXX.json`. Each file should include:
  ```json
  {
    "name": "Abstract #XX",
    "description": "Abstract painting #XX",
    "image": "ipfs://<ImageCID>/abstractXX.jpg",
    "attributes": [
      { "trait_type": "Type", "value": "Abstract" },
      { "trait_type": "Number", "value": "XX" }
    ]
  }
  ```
- **Pinata Account**: For uploading and pinning metadata to IPFS (sign up at [pinata.cloud](https://pinata.cloud/)).
- **Node.js** (optional): For programmatic IPFS uploads using Pinata’s SDK.

## Metadata Preparation
The contract requires 17 unique metadata URIs for the NFTs, hosted on IPFS. Follow these steps to prepare and upload metadata:

1. **Create Metadata Files**:
   - Generate 17 JSON files (`abstract01.json` to `abstract17.json`) with the structure above.
   - Ensure the `image` field points to IPFS-hosted images (e.g., `ipfs://<ImageCID>/abstractXX.jpg`).
   - Example for `abstract01.json`:
     ```json
     {
       "name": "Abstract #01",
       "description": "Abstract painting #01",
       "image": "ipfs://<ImageCID>/abstract01.jpg",
       "attributes": [
         { "trait_type": "Type", "value": "Abstract" },
         { "trait_type": "Number", "value": "01" }
       ]
     }
     ```

2. **Upload to IPFS Using Pinata**:
   - **Manual Upload**:
     - Log in to Pinata.
     - Click “Upload” and select all 17 JSON files.
     - Pinata generates a CID (Content Identifier).
     - Construct URIs: `ipfs://<CID>/abstractXX.json` (e.g., `ipfs://<CID>/abstract01.json`).
   - **Programmatic Upload** (Node.js):
     - Install dependencies:
       ```bash
       npm install @pinata/sdk fs
       ```
     - Use this script:
       ```javascript
       const fs = require('fs');
       const pinataSDK = require('@pinata/sdk');
       const pinata = new pinataSDK('YOUR_PINATA_API_KEY', 'YOUR_PINATA_SECRET_KEY');

       const metadata = Array.from({ length: 17 }, (_, i) => ({
         name: `Abstract #${(i + 1).toString().padStart(2, '0')}`,
         description: `Abstract painting #${(i + 1).toString().padStart(2, '0')}`,
         image: `ipfs://<ImageCID>/abstract${(i + 1).toString().padStart(2, '0')}.jpg`,
         attributes: [
           { trait_type: "Type", value: "Abstract" },
           { trait_type: "Number", value: `${(i + 1).toString().padStart(2, '0')}` }
         ]
       }));

       async function uploadToPinata() {
         const uris = [];
         for (let i = 0; i < metadata.length; i++) {
           const fileName = `abstract${(i + 1).toString().padStart(2, '0')}.json`;
           fs.writeFileSync(fileName, JSON.stringify(metadata[i]));
           const response = await pinata.pinFileToIPFS(fs.createReadStream(fileName));
           uris.push(`ipfs://${response.IpfsHash}/${fileName}`);
           fs.unlinkSync(fileName);
         }
         console.log(uris);
         return uris;
       }

       uploadToPinata();
       ```
     - Replace `YOUR_PINATA_API_KEY`, `YOUR_PINATA_SECRET_KEY`, and `<ImageCID>` with your values.
     - Run: `node script.js`.
     - Save the output URIs.

3. **Verify URIs**:
   - Test a URI in a browser: `https://ipfs.io/ipfs/<CID>/abstract01.json`.
   - Ensure the JSON loads correctly and the `image` link is accessible.

4. **Placeholder URIs (for Testing)**:
   - If IPFS URIs aren’t ready, use placeholders:
     ```json
     [
       "https://example.com/abstract01.json",
       "https://example.com/abstract02.json",
       ...
       "https://example.com/abstract17.json"
     ]
     ```
   - Replace with IPFS URIs before mainnet deployment.

## Deployment in Remix IDE

### Deploying in JavaScript VM
The JavaScript VM is ideal for testing without real ETH.

1. **Open Remix**:
   - Go to [remix.ethereum.org](https://remix.ethereum.org/).

2. **Load Contract**:
   - In the “File Explorer” tab (left sidebar, folder icon), ensure `BatchMintNFT.sol` is present.
   - If not, create a new file named `BatchMintNFT.sol` and paste your contract code.

3. **Compile Contract**:
   - Go to the “Solidity Compiler” tab (hammer icon).
   - Select compiler version `0.8.20`.
   - Check “Enable optimization” (runs: `200`).
   - Click the blue “Compile BatchMintNFT.sol” button.
   - Verify a green checkmark appears, indicating no compilation errors.

4. **Deploy Contract**:
   - Go to the “Deploy & Run Transactions” tab (play icon).
   - Select “JavaScript VM (London)” in the “Environment” dropdown.
   - Choose an account (e.g., `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`) in the “Account” dropdown.
   - Select `BatchMintNFT` in the contract dropdown.
   - In the input field next to “Deploy”, enter the `initialOwner` address (e.g., `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`).
   - Click the orange “Deploy” button.
   - Check the Remix terminal for output like:
     ```
     [vm] from: 0x5B3...eddC4 to: BatchMintNFT.(constructor) value: 0 wei data: 0x608...eddc4 logs: 1 hash: 0x620...
     ```
   - The deployed contract appears under “Deployed Contracts” with its address (e.g., `0xd9145CCE52D386f254917e481eB44e9943F39138`).

### Deploying to Sepolia Testnet
For real-world testing, deploy to Sepolia.

1. **Set Up MetaMask**:
   - Install MetaMask and add the Sepolia network:
     - Network Name: Sepolia
     - RPC URL: `https://rpc.sepolia.org`
     - Chain ID: `11155111`
     - Currency Symbol: ETH
   - Fund your account with test ETH from [Sepolia Faucet](https://sepoliafaucet.com/).

2. **Compile Contract**:
   - Follow the compilation steps above.

3. **Deploy Contract**:
   - In the “Deploy & Run Transactions” tab, select “Injected Provider - MetaMask” in the “Environment” dropdown.
   - Connect MetaMask and select your account (e.g., `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`).
   - Select `BatchMintNFT` and enter the `initialOwner` address.
   - Click “Deploy” and confirm the transaction in MetaMask (gas limit ~500,000).
   - Check the terminal for the contract address.
   - Verify deployment on [sepolia.etherscan.io](https://sepolia.etherscan.io/) by searching the contract address.

## Testing the Contract
The contract is tested in Remix using the JavaScript VM for simplicity. Below are detailed test cases to verify all functionalities. Ensure metadata URIs are prepared (see “Metadata Preparation”).

### Test Data
- **Owner Address**: `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`
- **Secondary Address**: `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2` (from JavaScript VM accounts)
- **Metadata URIs**: Array of 17 IPFS URIs (e.g., `ipfs://<CID>/abstractXX.json`) or placeholders.
- **Recipient Array** (for `batchMint`):
  ```json
  ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"]
  ```

### Test Cases

1. **Test Case 1: Mint All 17 NFTs to Sender**:
   - **Objective**: Mint all 17 NFTs to the owner using `batchMintToSender`.
   - **Steps**:
     - Expand the deployed `BatchMintNFT` contract under “Deployed Contracts”.
     - Locate the `batchMintToSender` function (orange button).
     - Input the 17 URI array:
       ```json
       ["ipfs://<CID>/abstract01.json","ipfs://<CID>/abstract02.json",...,"ipfs://<CID>/abstract17.json"]
       ```
     - Ensure `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4` is selected in “Account”.
     - Click `batchMintToSender`.
     - Check the terminal for transaction confirmation.
   - **Expected Results**:
     - Call `totalSupply()` (blue button): Returns `17`.
     - Call `ownerOf(0)`: Returns `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
     - Call `ownerOf(16)`: Returns `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
     - Call `tokenURI(0)`: Returns `ipfs://<CID>/abstract01.json`.
     - Call `tokenURI(16)`: Returns `ipfs://<CID>/abstract17.json`.

2. **Test Case 2: Mint 2 NFTs to Different Recipients**:
   - **Objective**: Mint 2 NFTs to different addresses using `batchMint`.
   - **Steps**:
     - Redeploy the contract to reset the token counter (follow “Deploy in JavaScript VM”).
     - Expand the new contract.
     - Locate `batchMint` (orange button).
     - Input a single JSON array with two sub-arrays:
       ```json
       [["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"], ["ipfs://<CID>/abstract01.json", "ipfs://<CID>/abstract02.json"]]
       ```
     - Click `batchMint`.
   - **Expected Results**:
     - Call `totalSupply()`: Returns `2`.
     - Call `ownerOf(0)`: Returns `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
     - Call `ownerOf(1)`: Returns `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`.
     - Call `tokenURI(0)`: Returns `ipfs://<CID>/abstract01.json`.
     - Call `tokenURI(1)`: Returns `ipfs://<CID>/abstract02.json`.

3. **Test Case 3: Exceed Max Supply**:
   - **Objective**: Verify the contract prevents minting beyond 17 NFTs.
   - **Steps**:
     - After Test Case 2 (2 NFTs minted), call `batchMintToSender` with 16 URIs:
       ```json
       ["ipfs://<CID>/abstract03.json",...,"ipfs://<CID>/abstract18.json"]
       ```
     - Click `batchMintToSender`.
   - **Expected Results**:
     - Transaction reverts with “Exceeds max supply” (check terminal).

4. **Test Case 4: Invalid Inputs**:
   - **Objective**: Test error handling for invalid inputs.
   - **Sub-Cases**:
     - **Mismatched Arrays**:
       - Input:
         ```json
         [["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"], ["ipfs://<CID>/abstract01.json", "ipfs://<CID>/abstract02.json"]]
         ```
       - Click `batchMint`.
       - **Expected**: Reverts with “Arrays length mismatch”.
     - **Invalid Recipient**:
       - Input:
         ```json
         [["0x0000000000000000000000000000000000000000", "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"], ["ipfs://<CID>/abstract01.json", "ipfs://<CID>/abstract02.json"]]
         ```
       - Click `batchMint`.
       - **Expected**: Reverts with “Invalid recipient address”.
     - **Empty URIs**:
       - Input: `[]` for `batchMintToSender`.
       - Click `batchMintToSender`.
       - **Expected**: Reverts with “No URIs provided”.

5. **Test Case 5: Non-Owner Access**:
   - **Objective**: Ensure only the owner can mint.
   - **Steps**:
     - Select `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2` in “Account”.
     - Call `batchMint` with:
       ```json
       [["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"], ["ipfs://<CID>/abstract01.json", "ipfs://<CID>/abstract02.json"]]
       ```
     - Click `batchMint`.
   - **Expected Results**:
     - Reverts with “Ownable: caller is not the owner”.

6. **Test Case 6: Withdraw ETH**:
   - **Objective**: Test withdrawing ETH sent to the contract.
   - **Steps**:
     - Send 0.1 ETH to the contract:
       - In “Deploy & Run Transactions”, set “Value” to `100000000000000000` (0.1 ETH in wei).
       - Call `totalSupply` to send ETH.
       - Or run in the terminal:
         ```javascript
         remix.call('web3Provider', 'sendTransaction', {
           from: '0x5B38Da6a701c568545dCfcB03FcB875f56beddC4',
           to: '<ContractAddress>',
           value: web3.utils.toWei('0.1', 'ether')
         })
         ```
     - Select `0x5B38Da6a701c568545dCfcB03FcB875f56beddC4`.
     - Click `withdraw` (orange button).
   - **Expected Results**:
     - Transaction succeeds.
     - Run `remix.call('web3Provider', 'getBalance', ['<ContractAddress>'])` in the terminal; returns `0`.
     - Call `withdraw` again; reverts with “No funds to withdraw”.

## Troubleshooting
- **“Exceeds max supply”**:
  - Cause: Attempted to mint more than 17 NFTs.
  - Solution: Redeploy the contract or check `totalSupply()` to see remaining NFTs.
- **“Arrays length mismatch”**:
  - Cause: `recipients` and `tokenURIs` arrays have different lengths in `batchMint`.
  - Solution: Ensure equal lengths (e.g., 2 recipients, 2 URIs).
- **“Error encoding arguments”**:
  - Cause: Incorrect JSON input format for `batchMint`.
  - Solution: Use a single JSON array with two sub-arrays (e.g., `[["0x5B3..."], ["ipfs://..."]]`).
- **URI Not Accessible**:
  - Cause: IPFS metadata not pinned or uploaded.
  - Solution: Re-upload via Pinata and test URIs in a browser.
- **Transaction Fails on Sepolia**:
  - Cause: Insufficient gas or test ETH.
  - Solution: Increase gas limit (~1.5M for 17 NFTs) or request more test ETH.

## Post-Deployment
- **Verify NFTs**:
  - Check metadata by calling `tokenURI(0)` or viewing NFTs on a testnet marketplace (e.g., OpenSea Sepolia).
- **Contract Verification**:
  - Use Remix’s “Contract Verification” plugin to verify the contract on [sepolia.etherscan.io](https://sepolia.etherscan.io/).
- **Mainnet Deployment**:
  - After testing, deploy on Ethereum mainnet with pinned IPFS URIs for permanence.
- **Marketplace Integration**:
  - List NFTs on platforms like OpenSea by setting the contract address and ensuring metadata is accessible.

## Why Use This Contract?
- **Efficiency**: Batch minting reduces gas costs compared to individual minting.
- **Security**: `onlyOwner` ensures only the creator can mint or withdraw funds.
- **Flexibility**: Supports minting to multiple recipients or the owner, with dynamic URI assignment during minting.
- **Scalability**: Suitable for small collections (17 NFTs), with on-chain URI storage for reliability.
- **Decentralization**: Integrates with IPFS for immutable, decentralized metadata storage.

## License
The contract is licensed under the MIT License, allowing free use, modification, and distribution.
