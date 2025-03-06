# MultiSigWallet

A Solidity-based multi-signature wallet contract that requires multiple owner approvals to execute transactions.

## Overview

This contract implements a multi-signature wallet where:
- Multiple owners can propose and confirm transactions
- A minimum number of confirmations is required to execute transactions
- Owners can deposit ETH and execute transactions to other addresses or contracts
- Provides functionality to revoke confirmations before execution

## Features

- Multi-owner management
- Transaction submission and confirmation system
- Configurable number of required confirmations
- Event logging for all major actions
- ETH deposit capability
- Safety checks and modifiers
- View functions for transparency

## Prerequisites

- Solidity ^0.8.0
- Ethereum development environment (e.g., Remix, Truffle)
- ETH for deployment and testing

## Deployment

1. Deploy the contract with:
   - An array of owner addresses
   - Number of required confirmations

Example:
```solidity
MultiSigWallet wallet = new MultiSigWallet([owner1, owner2, owner3], 2);
```

## Usage

1. **Deposit ETH**: Send ETH to the contract address
2. **Submit Transaction**: Call `submitTransaction(address _to, uint _value, bytes _data)`
3. **Confirm Transaction**: Owners call `confirmTransaction(uint _txIndex)`
4. **Execute Transaction**: Any owner calls `executeTransaction(uint _txIndex)` when enough confirmations are received
5. **Revoke Confirmation**: Owners can call `revokeConfirmation(uint _txIndex)` before execution

## Functions

### Write Functions
- `submitTransaction(address _to, uint _value, bytes _data)`: Submit a new transaction
- `confirmTransaction(uint _txIndex)`: Confirm a pending transaction
- `executeTransaction(uint _txIndex)`: Execute a confirmed transaction
- `revokeConfirmation(uint _txIndex)`: Revoke a previous confirmation

### View Functions
- `getOwners()`: Returns array of owner addresses
- `getTransactionCount()`: Returns total number of transactions
- `getTransaction(uint _txIndex)`: Returns transaction details

## Events
- `Deposit(address sender, uint amount, uint balance)`
- `SubmitTransaction(address owner, uint txIndex, address to, uint value, bytes data)`
- `ConfirmTransaction(address owner, uint txIndex)`
- `RevokeConfirmation(address owner, uint txIndex)`
- `ExecuteTransaction(address owner, uint txIndex)`

## Security Considerations
- Uses modifiers for access control
- Prevents reentrancy with state changes before external calls
- Validates inputs in constructor and functions
- Uses explicit state management

## License
SPDX-License-Identifier: MIT
```

### How to Check the Contract Line-by-Line in Remix IDE

Here's a step-by-step guide to test and verify the MultiSigWallet contract in Remix IDE:

1. **Setup Remix**
   - Go to https://remix.ethereum.org/
   - Create a new file (e.g., `MultiSigWallet.sol`)
   - Copy and paste the contract code
   - Select Solidity compiler version 0.8.0 or higher

2. **Compile the Contract**
   - Go to "Solidity Compiler" tab
   - Click "Compile MultiSigWallet.sol"
   - Ensure no errors appear

3. **Deploy the Contract**
   - Go to "Deploy & Run Transactions" tab
   - Select "JavaScript VM" (test environment)
   - In the constructor parameters, enter:
     - Owners array (e.g., `["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]`)
     - Number of confirmations (e.g., `2`)
   - Click "Deploy"

4. **Line-by-Line Testing**

   a. **Test Constructor (lines 62-81)**
   - After deployment, check:
     - Call `getOwners()` to verify owner list
     - Check `numConfirmationsRequired` value
   - Try deploying with invalid inputs (0 owners, invalid confirmation number) to test require statements

   b. **Test Deposit (lines 84-87)**
   - Switch to an owner account
   - Send ETH using the "Value" field (e.g., 1 ETH)
   - Check "Logs" for Deposit event
   - Verify contract balance increased

   c. **Test Submit Transaction (lines 90-107)**
   - Call `submitTransaction` with:
     - `_to`: Another address
     - `_value`: Amount in wei (e.g., 1000000000000000000 for 1 ETH)
     - `_data`: Empty bytes (`0x`)
   - Check returned txIndex
   - Verify `SubmitTransaction` event in logs
   - Call `getTransaction(0)` to see details

   d. **Test Confirm Transaction (lines 110-125)**
   - Switch between owner accounts
   - Call `confirmTransaction(0)`
   - Verify:
     - `ConfirmTransaction` event
     - `numConfirmations` increases (use `getTransaction`)
     - `isConfirmed` mapping updates
   - Test modifiers by trying with non-owner account

   e. **Test Execute Transaction (lines 128-147)**
   - Get required confirmations first
   - Call `executeTransaction(0)`
   - Verify:
     - ETH transferred to destination
     - `executed` set to true
     - `ExecuteTransaction` event
   - Test failure cases (insufficient confirmations)

   f. **Test Revoke Confirmation (lines 150-162)**
   - Submit new transaction
   - Confirm with one owner
   - Call `revokeConfirmation`
   - Verify:
     - `numConfirmations` decreases
     - `RevokeConfirmation` event
     - `isConfirmed` resets

5. **Debugging Tips**
   - Use "Debug" button next to transactions in the terminal
   - Enable "Solidity State" plugin to see storage variables
   - Watch gas costs for each operation
   - Check Remix's "Logs" for event emissions

6. **Modifier Verification**
   - Test `onlyOwner`: Try functions with non-owner account
   - Test `txExists`: Use invalid txIndex
   - Test `notExecuted`: Try confirming executed tx
   - Test `notConfirmed`: Try double-confirming

