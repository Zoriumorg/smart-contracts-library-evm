# ERC20WithSnapshot Token

The `ERC20WithSnapshot` project is a custom ERC-20 token built with OpenZeppelin v4.9.3, featuring snapshot functionality for governance purposes and an optional token burning mechanism. Deployed on the Polygon Mumbai Testnet, this contract extends the standard ERC-20 token with additional capabilities while maintaining security and reliability.

## Features
- **Standard ERC-20 Functions**: Transfer, approve, allowance, and balance tracking.
- **Snapshot Mechanism**: Record token balances at specific points in time for governance or auditing.
- **Burn Functionality**: Allows token holders to destroy their tokens.
- **Ownership**: Restricts snapshot creation to the contract owner.

## Prerequisites
- **Remix IDE**: Web-based Solidity IDE ([remix.ethereum.org](https://remix.ethereum.org/)).
- **MetaMask**: Browser wallet extension for Ethereum-compatible networks.
- **Polygon Mumbai Testnet**:
  - RPC URL: `https://rpc-mumbai.maticvigil.com`
  - Chain ID: `80001`
  - Symbol: `MATIC`
  - Block Explorer: [Polygon Blockscout](https://polygon.blockscout.com/)
- **Test MATIC**: Obtain from [Polygon Faucet](https://faucet.polygon.technology/).

## Deployment Steps

Follow these steps to deploy the `ERC20WithSnapshot` contract to Polygon Mumbai Testnet:

1. **Open Remix IDE**:
   - Visit [Remix](https://remix.ethereum.org/).
   - In the "File Explorer" tab, click the "+" button to create a file named `ERC20WithSnapshot.sol`.

2. **Compile the Contract**:
   - Navigate to the "Solidity Compiler" tab (left sidebar).
   - Select Solidity version `0.8.0` (compatible up to `0.8.19`).
   - Click "Compile ERC20WithSnapshot.sol". Confirm no errors appear in the console.

3. **Configure MetaMask**:
   - Install MetaMask if not already installed.
   - Add Polygon Mumbai Testnet:
     - Network Name: `Mumbai Testnet`
     - RPC URL: `https://rpc-mumbai.maticvigil.com`
     - Chain ID: `80001`
     - Currency Symbol: `MATIC`
   - Fund your wallet with test MATIC from the [Polygon Faucet](https://faucet.polygon.technology/).

4. **Deploy the Contract**:
   - Go to the "Deploy & Run Transactions" tab in Remix.
   - Set "Environment" to "Injected Provider - MetaMask".
   - Connect MetaMask (ensure it’s on Mumbai Testnet) and select your account.
   - In the "Contract" dropdown, choose `ERC20WithSnapshot`.
   - Provide constructor parameters:
     - `name`: `"Snapshot Token"`
     - `symbol`: `"SNAP"`
     - `initialSupply`: `1000000000000000000000` (1,000 tokens, 18 decimals).
   - Click "Deploy" and approve the transaction in MetaMask (ensure sufficient MATIC for gas).

5. **Verify Deployment**:
   - After successful deployment, the contract address appears under "Deployed Contracts" in Remix.
   - Copy the address and verify it on [Polygon Blockscout](https://polygon.blockscout.com/) by searching the address.

## Testing the Contract

Test the contract’s functionality using Remix and MetaMask. Below are detailed steps and test cases.

### Testing Steps

1. **Initial Balance Check**:
   - Expand the deployed contract in Remix under "Deployed Contracts".
   - Call `balanceOf` with your MetaMask address (e.g., `0xYourAddress`).
   - Click "Call" to execute.
   - **Expected Output**: `1000000000000000000000` (1,000 tokens).

2. **Transfer Tokens**:
   - Use the `transfer` function:
     - `to`: A second address (e.g., another MetaMask account, `0xRecipientAddress`).
     - `amount`: `10000000000000000000` (10 tokens).
   - Click "Transact" and confirm in MetaMask.
   - Verify:
     - Call `balanceOf` for `0xRecipientAddress`.
     - **Expected Output**: `10000000000000000000` (10 tokens).

3. **Create a Snapshot**:
   - Call `snapshot()` (only callable by the owner, i.e., the deploying account).
   - Click "Transact" and confirm in MetaMask.
   - **Expected Output**: A snapshot ID (e.g., `1`). Note this ID for later use.

4. **Check Historical Balance**:
   - Use `balanceOfAt`:
     - `account`: Your MetaMask address (e.g., `0xYourAddress`).
     - `snapshotId`: The ID from the snapshot (e.g., `1`).
   - Click "Call".
   - **Expected Output**: `990000000000000000000` (990 tokens, reflecting balance after transferring 10 tokens).

5. **Burn Tokens**:
   - Call `burn`:
     - `amount`: `5000000000000000000` (5 tokens).
   - Click "Transact" and confirm in MetaMask.
   - Verify:
     - Call `balanceOf` for your address.
     - **Expected Output**: `985000000000000000000` (985 tokens).

6. **Add Token to MetaMask**:
   - In MetaMask, click "Add Token" > "Custom Token".
   - Input:
     - Contract address (from Remix).
     - Symbol: `SNAP`.
     - Decimals: `18`.
   - Confirm and verify your balance matches Remix output.

### Test Cases

| **Test Case**            | **Action**                          | **Input**                              | **Expected Outcome**                     | **Pass/Fail Criteria**                  |
|---------------------------|-------------------------------------|----------------------------------------|------------------------------------------|-----------------------------------------|
| **Initial Supply**        | Call `balanceOf(owner)`            | Owner address                         | `1000000000000000000000` (1,000 tokens) | Matches initial supply                  |
| **Transfer Success**      | Call `transfer(recipient, 10)`     | Recipient address, `10 * 10^18`       | Recipient balance = `10 * 10^18`        | Balance updates correctly               |
| **Transfer Fail (Insufficient Balance)** | Call `transfer(recipient, 2000)` | Recipient address, `2000 * 10^18` | Transaction reverts                    | Reverts due to insufficient funds      |
| **Snapshot Creation**     | Call `snapshot()` (owner)          | None                                  | Returns snapshot ID (e.g., `1`)         | ID increments, callable by owner only   |
| **Snapshot Non-Owner Fail** | Call `snapshot()` (non-owner)    | None                                  | Transaction reverts                    | Reverts with "Ownable: caller is not the owner" |
| **Historical Balance**    | Call `balanceOfAt(owner, 1)`       | Owner address, snapshot ID `1`        | `990000000000000000000` (990 tokens)   | Matches balance at snapshot time       |
| **Burn Success**          | Call `burn(5)`                     | `5 * 10^18`                          | Owner balance = `985000000000000000000` | Balance decreases by 5 tokens          |
| **Burn Fail (Excess)**    | Call `burn(2000)`                  | `2000 * 10^18`                       | Transaction reverts                    | Reverts due to insufficient balance    |

## Screenshots

Below are visual examples of the contract deployment and interactions:

### Deployment in Remix
![Deployment Screenshot](./screenshots/deploy.png)

### Snapshot Creation
![Snapshot Screenshot](./screenshots/ERC20contract.png)

*Note*: Replace these placeholders with actual screenshots taken during your deployment and testing.

## Blockscout Transactions

Example transactions from Polygon Mumbai Testnet:

1. **[Deployment Transaction](https://polygon.blockscout.com/tx/0x5d18eabfdf6d93d3ac1ca8ba7a3836a3cc82680305798949117ecacec9540054)**  
   - Initial deployment of the contract.
2. **[Transfer Transaction](https://polygon.blockscout.com/tx/0xc27a243b58258ef5d17a99967010e7741c8a8b7e95f1ace4334db189738e5a42)**  
   - Transfer of tokens to another address.
3. **[Snapshot Transaction](https://polygon.blockscout.com/tx/0xbe121c229b261b61d4418320ed6e1dae4416eb67cd08740e088a5450298b3bc7)**  
   - Creation of a snapshot by the owner.
4. **[Burn Transaction](https://polygon.blockscout.com/tx/0x85179f8a6a35821767790c563ecb0f709c3e6ca7bec8bb141e2552a5c5c08e6d)**  
   - Burning of tokens by a holder.

## Troubleshooting
- **Compilation Errors**: Verify Solidity version is `^0.8.0` and imports use `@openzeppelin/contracts@4.9.3`.
- **Gas Issues**: Ensure sufficient test MATIC in your MetaMask wallet.
- **Ownership Restrictions**: Only the deploying account can call `snapshot()`. Switch to the owner account if needed.
- **Transaction Failures**: Check Remix logs or Blockscout for revert reasons (e.g., insufficient balance).

## Contributing
Feel free to fork this project, submit issues, or propose enhancements via pull requests.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
