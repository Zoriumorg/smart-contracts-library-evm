# GameItems ERC1155 Contract

## Contract Overview

This is an ERC1155 multi-token standard contract for game items, inheriting from OpenZeppelin's ERC1155 implementation. The contract includes:
- 5 predefined token types (GOLD, SILVER, THOR'S HAMMER, SWORD, SHIELD)
- Initial minting of tokens in the constructor
- Standard ERC1155 functionality for token management

### Token IDs
- GOLD (ID: 0): Common currency token
- SILVER (ID: 1): Common currency token
- THORS_HAMMER (ID: 2): Unique/rare item
- SWORD (ID: 3): Common equipment
- SHIELD (ID: 4): Common equipment

### Initial Token Distribution
- GOLD: 10^18 tokens
- SILVER: 10^27 tokens
- THOR'S HAMMER: 1 token
- SWORD: 10^9 tokens
- SHIELD: 10^9 tokens

All tokens are initially minted to the deployer's address.


## Testing in Remix

### 1. Setup in Remix

1. Open Remix IDE (https://remix.ethereum.org)
2. Create a new file named `GameItems.sol`
3. Copy and paste the contract code above
4. In the "Solidity Compiler" tab:
   - Select compiler version 0.8.20
   - Enable auto-compile or click "Compile GameItems.sol"
5. In the "Deploy & Run Transactions" tab:
   - Select "Injected Provider" or "Remix VM" as the environment
   - Select "GameItems" contract from the contract dropdown

### 2. Deployment

1. Click the "Deploy" button
2. If using Remix VM, the contract will deploy immediately
3. If using a testnet/mainnet, confirm the transaction in your wallet
4. Note the deployed contract address in the "Deployed Contracts" section

### 3. Testing Main Functions

#### balanceOf
- Checks the balance of a specific token for an address
- Parameters:
  - account: Address to check (e.g., your wallet address)
  - id: Token ID (0-4)
- Testing:
  1. Expand the deployed contract in Remix
  2. Find "balanceOf" function
  3. Input:
     - account: Deployer's address (should have initial tokens)
     - id: 0 (GOLD)
  4. Click "Call"
  5. Result: Should show 10^18 for GOLD
  6. Repeat for other token IDs (1-4)

#### balanceOfBatch
- Checks multiple token balances for multiple addresses
- Parameters:
  - accounts: Array of addresses
  - ids: Array of token IDs
- Testing:
  1. Find "balanceOfBatch" function
  2. Input:
     - accounts: ["0xDeployerAddress", "0xAnotherAddress"]
     - ids: [0, 1, 2] (GOLD, SILVER, THOR'S HAMMER)
  3. Click "Call"
  4. Result: Array of balances for each account/token pair

#### setApprovalForAll
- Approves an operator to manage all tokens
- Parameters:
  - operator: Address to approve
  - approved: true/false
- Testing:
  1. Find "setApprovalForAll" function
  2. Input:
     - operator: Another address
     - approved: true
  3. Click "Transact"
  4. Confirm transaction
  5. Use "isApprovedForAll" to verify:
     - owner: Deployer's address
     - operator: Approved address
     - Click "Call"
     - Should return "true"

#### safeTransferFrom
- Transfers a specific amount of a token
- Parameters:
  - from: Sender address
  - to: Recipient address
  - id: Token ID (0-4)
  - amount: Amount to transfer
  - data: Empty bytes ("0x")
- Testing:
  1. Find "safeTransferFrom" function
  2. Input:
     - from: Deployer's address
     - to: Another address
     - id: 0 (GOLD)
     - amount: 1000
     - data: 0x
  3. Click "Transact"
  4. Confirm transaction
  5. Verify using balanceOf for both addresses

#### safeBatchTransferFrom
- Transfers multiple token types
- Parameters:
  - from: Sender address
  - to: Recipient address
  - ids: Array of token IDs
  - amounts: Array of amounts
  - data: Empty bytes ("0x")
- Testing:
  1. Find "safeBatchTransferFrom" function
  2. Input:
     - from: Deployer's address
     - to: Another address
     - ids: [0, 1] (GOLD, SILVER)
     - amounts: [1000, 2000]
     - data: 0x
  3. Click "Transact"
  4. Confirm transaction
  5. Verify using balanceOfBatch

### 4. Important Notes

- All transfer functions require sufficient balance
- Approval is needed for transfers by operators
- THOR'S HAMMER (ID: 2) has only 1 token, making it effectively an NFT
- Use different accounts in Remix VM to test transfers and approvals
- Monitor gas costs for batch operations
- Remember that token amounts are in wei (smallest unit)

### 5. Common Errors and Solutions

- "Insufficient balance":
  - Check sender's balance using balanceOf
  - Ensure amount doesn't exceed available tokens
- "Not approved":
  - Use setApprovalForAll or approve first
  - Verify approval with isApprovedForAll
- "Invalid token ID":
  - Only use token IDs 0-4
  - Check spelling of constants
