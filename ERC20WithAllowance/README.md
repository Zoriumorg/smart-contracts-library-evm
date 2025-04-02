# ERC20WithAllowance - ERC-20 Token with Allowance Management

`ERC20WithAllowance` is a Solidity smart contract implementing the ERC-20 token standard with support for token approvals and allowances. This contract allows token holders to authorize spenders to transfer tokens on their behalf, a fundamental mechanism for decentralized applications (dApps) like exchanges and lending platforms.

## Overview

- **Token Name**: ERC20WithAllowance
- **Symbol**: EWA
- **Decimals**: 18
- **Features**: Basic ERC-20 functionality (`transfer`, `approve`, `transferFrom`, `allowance`) plus `increaseAllowance` and `decreaseAllowance` for safer allowance management.
- **License**: MIT

## Prerequisites

- **Remix IDE**: Access Remix at [remix.ethereum.org](https://remix.ethereum.org/).
- **Ethereum Wallet**: Use MetaMask or another wallet connected to Remix for deployment and interaction.
- **Network**: Deploy on a testnet (e.g., Sepolia, Goerli) or a local blockchain (e.g., Remix VM).

## Contract Details

### Source Code

The contract is written in Solidity `^0.8.20` and is located in `ERC20WithAllowance.sol`. Key components include:

- **State Variables**:
  - `name`, `symbol`, `decimals`: Token metadata.
  - `totalSupply`: Total token supply.
  - `balanceOf`: Mapping of account balances.
  - `_allowances`: Nested mapping for spender allowances.

- **Events**:
  - `Transfer(address indexed from, address indexed to, uint256 value)`: Emitted on token transfers.
  - `Approval(address indexed owner, address indexed spender, uint256 value)`: Emitted on allowance updates.

- **Functions**:
  - `constructor(uint256 initialSupply)`: Mints initial supply to the deployer.
  - `transfer(address to, uint256 amount)`: Transfers tokens from the caller.
  - `approve(address spender, uint256 amount)`: Sets an allowance for a spender.
  - `transferFrom(address from, address to, uint256 amount)`: Transfers tokens on behalf of an owner.
  - `allowance(address owner, address spender)`: Returns the remaining allowance.
  - `increaseAllowance(address spender, uint256 addedValue)`: Increases an existing allowance.
  - `decreaseAllowance(address spender, uint256 subtractedValue)`: Decreases an existing allowance.

## Deployment in Remix

### Steps

1. **Open Remix**:
   - Go to [remix.ethereum.org](https://remix.ethereum.org/).
   - Create a new file named `ERC20WithAllowance.sol` and paste the contract code.

2. **Compile the Contract**:
   - In the "Solidity Compiler" tab, select version `0.8.20`.
   - Click "Compile ERC20WithAllowance.sol".

3. **Deploy the Contract**:
   - Go to the "Deploy & Run Transactions" tab.
   - Select "Injected Provider - MetaMask" (or Remix VM for local testing).
   - In the constructor input, enter an `initialSupply` (e.g., `1000` for 1000 tokens with 18 decimals).
   - Click "Deploy" and confirm the transaction in MetaMask.

4. **Interact with the Contract**:
   - Once deployed, the contract instance appears under "Deployed Contracts".
   - Expand it to access all public functions and variables.

## Usage in Remix

### Basic Operations

- **Check Total Supply**: Call `totalSupply` to verify the initial supply (e.g., `1000 * 10^18`).
- **Check Balance**: Call `balanceOf` with the deployer’s address to confirm the initial balance.
- **Transfer Tokens**: Use `transfer` with a recipient address and amount (e.g., `1000000000000000000` for 1 token).
- **Approve Spender**: Call `approve` with a spender address and amount.
- **Check Allowance**: Use `allowance` with the owner and spender addresses.
- **Transfer From**: Switch to the spender’s account in Remix and call `transferFrom` with the owner’s address, recipient, and amount.
- **Adjust Allowance**: Use `increaseAllowance` or `decreaseAllowance` to modify permissions.

### Example Workflow

1. Deploy with `initialSupply = 1000`.
2. Transfer 100 tokens to `0xAccount2`: `transfer(0xAccount2, 100000000000000000000)`.
3. Approve `0xAccount3` to spend 50 tokens: `approve(0xAccount3, 50000000000000000000)`.
4. From `0xAccount3`, call `transferFrom(0xDeployer, 0xAccount4, 50000000000000000000)`.

## Test Cases

Below are test cases to verify the contract’s functionality in Remix. Use multiple accounts (e.g., via Remix’s account dropdown or MetaMask).

### 1. Deployment and Initialization
- **Test**: Deploy with `initialSupply = 1000`.
- **Expected**: 
  - `totalSupply` returns `1000 * 10^18`.
  - `balanceOf(deployer)` returns `1000 * 10^18`.
- **Steps**: 
  - Deploy the contract.
  - Call `totalSupply` and `balanceOf` with the deployer’s address.

### 2. Token Transfer
- **Test**: Transfer 100 tokens to `Account2`.
- **Expected**: 
  - `balanceOf(deployer)` decreases by `100 * 10^18`.
  - `balanceOf(Account2)` increases by `100 * 10^18`.
  - `Transfer` event emitted.
- **Steps**: 
  - Call `transfer(Account2, 100000000000000000000)`.
  - Check balances and event logs.

### 3. Approval and Allowance Check
- **Test**: Approve `Account3` to spend 50 tokens.
- **Expected**: 
  - `allowance(deployer, Account3)` returns `50 * 10^18`.
  - `Approval` event emitted.
- **Steps**: 
  - Call `approve(Account3, 50000000000000000000)`.
  - Call `allowance(deployer, Account3)`.

### 4. TransferFrom
- **Test**: `Account3` transfers 30 tokens from `deployer` to `Account4`.
- **Expected**: 
  - `balanceOf(deployer)` decreases by `30 * 10^18`.
  - `balanceOf(Account4)` increases by `30 * 10^18`.
  - `allowance(deployer, Account3)` decreases to `20 * 10^18`.
  - `Transfer` event emitted.
- **Steps**: 
  - Switch to `Account3`.
  - Call `transferFrom(deployer, Account4, 30000000000000000000)`.
  - Verify balances and allowance.

### 5. Increase Allowance
- **Test**: Increase `Account3`’s allowance by 10 tokens.
- **Expected**: 
  - `allowance(deployer, Account3)` increases to `30 * 10^18`.
  - `Approval` event emitted.
- **Steps**: 
  - Call `increaseAllowance(Account3, 10000000000000000000)`.
  - Check `allowance(deployer, Account3)`.

### 6. Decrease Allowance
- **Test**: Decrease `Account3`’s allowance by 15 tokens.
- **Expected**: 
  - `allowance(deployer, Account3)` decreases to `15 * 10^18`.
  - `Approval` event emitted.
- **Steps**: 
  - Call `decreaseAllowance(Account3, 15000000000000000000)`.
  - Check `allowance(deployer, Account3)`.

### 7. Edge Cases
- **Transfer to Zero Address**:
  - Call `transfer(0x0, 1000000000000000000)`.
  - **Expected**: Reverts with "ERC20: transfer to the zero address".
- **Transfer Exceeding Balance**:
  - Call `transfer(Account2, totalSupply + 1)` from a low-balance account.
  - **Expected**: Reverts with "ERC20: transfer amount exceeds balance".
- **Approve Zero Address**:
  - Call `approve(0x0, 1000000000000000000)`.
  - **Expected**: Reverts with "ERC20: approve to the zero address".
- **TransferFrom Exceeding Allowance**:
  - Call `transferFrom(deployer, Account4, 20000000000000000000)` from `Account3` with 15 token allowance.
  - **Expected**: Reverts with "ERC20: transfer amount exceeds allowance".
- **Decrease Allowance Below Zero**:
  - Call `decreaseAllowance(Account3, 20000000000000000000)` with current allowance of 15.
  - **Expected**: Reverts with "ERC20: decreased allowance below zero".

## Troubleshooting

- **Transaction Fails**: Check gas limits and ensure correct parameter formats (e.g., amounts in wei).
- **Allowance Not Updating**: Verify event logs and ensure the correct `spender` address is used.
- **Reverts**: Read error messages in Remix’s console for specific revert reasons.

## Security Considerations

- **Reentrancy**: This basic implementation lacks reentrancy protection. Use OpenZeppelin’s `ReentrancyGuard` for production.
- **Allowance Race Conditions**: `approve` overwrites existing allowances; use `increaseAllowance`/`decreaseAllowance` to avoid front-running risks.
- **Audits**: For real-world use, conduct a professional security audit.

## License

This project is licensed under the MIT License. See the `SPDX-License-Identifier` in the contract.

