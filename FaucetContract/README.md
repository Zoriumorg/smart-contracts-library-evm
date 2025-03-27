# FaucetContract - Solidity Smart Contract

## Overview
The `FaucetContract` is a simple Ethereum smart contract designed to distribute small amounts of Ether to users. It is typically used in testnet environments to provide developers with funds for testing decentralized applications (dApps) or other smart contracts. The contract includes a cooldown mechanism to prevent abuse and allows anyone to deposit Ether to keep it funded.

### Features
- **Token Distribution:** Users can request a fixed amount of Ether (default: 0.1 Ether).
- **Cooldown Period:** A lock time (default: 1 day) restricts users from requesting funds too frequently.
- **Deposit Functionality:** Anyone can deposit Ether to fund the faucet.
- **Owner Withdrawal:** The contract owner can withdraw all funds as a safety feature.
- **Balance Check:** A view function to check the contract's Ether balance.

### Contract Details
- **Solidity Version:** `^0.8.0`
- **License:** MIT
- **Deployment Date:** N/A (Test locally or on a testnet)

---

## Prerequisites
- **Remix IDE:** Access [Remix IDE](https://remix.ethereum.org/) in your browser.
- **Solidity Compiler:** Version `0.8.0` or higher.
- **Ethereum Environment:** Use Remix's JavaScript VM (simulated blockchain) for testing.

---

## Installation and Deployment

1. **Open Remix IDE:**
   - Navigate to [Remix Ethereum IDE](https://remix.ethereum.org/).
   - Create a new file named `FaucetContract.sol`.

2. **Copy the Contract:**
   - Paste the provided Solidity code into `FaucetContract.sol`.

3. **Compile the Contract:**
   - Go to the **Solidity Compiler** tab.
   - Select version `0.8.0` (or compatible).
   - Click **Compile FaucetContract.sol**. Ensure no errors appear.

4. **Deploy the Contract:**
   - Go to the **Deploy & Run Transactions** tab.
   - Set the environment to **JavaScript VM (London)** (provides 100 Ether per account).
   - Click **Deploy**. Note the deployed contract address in the "Deployed Contracts" section.

---

## Functions
| Function           | Description                                      | Parameters         | Access       |
|--------------------|--------------------------------------------------|--------------------|--------------|
| `requestTokens()`  | Requests 0.1 Ether if cooldown has passed.       | None               | Public       |
| `deposit()`        | Deposits Ether into the faucet.                  | None (payable)     | Public       |
| `withdrawAll()`    | Withdraws all Ether (owner only).                | None               | Owner Only   |
| `getBalance()`     | Returns the contract’s Ether balance.            | None               | Public (View)|
| `receive()`        | Fallback function to accept Ether deposits.     | None (payable)     | External     |

### Events
- `Withdrawal(address indexed to, uint256 amount)`: Emitted when a user receives Ether.
- `Deposit(address indexed from, uint256 amount)`: Emitted when Ether is deposited.

---

## Testing in Remix IDE

### Setup
- **Environment:** Use **JavaScript VM (London)** for testing (each account starts with 100 Ether).
- **Accounts:** Remix provides multiple test accounts—use at least two for testing (owner and user).

### Test Cases

#### 1. Deploy the Contract
- **Steps:**
  1. Deploy the contract using the first account (Account 1).
  2. Verify the `owner` variable matches Account 1’s address.
- **Expected Result:** Contract deploys successfully, and `owner` is set to the deployer’s address.

#### 2. Deposit Ether into the Faucet
- **Steps:**
  1. In Remix, set the “Value” field to `1 Ether` (1000000000000000000 wei).
  2. Call the `deposit` function from Account 1.
  3. Call `getBalance()` to check the contract balance.
- **Expected Result:** 
  - Balance increases to 1 Ether.
  - `Deposit` event is emitted with `msg.sender` as Account 1 and `amount` as 1 Ether.

#### 3. Request Tokens (Successful)
- **Steps:**
  1. Switch to Account 2.
  2. Call `requestTokens()`.
  3. Check Account 2’s balance (top of the “Deploy & Run” tab).
  4. Call `nextAccessTime(Account 2)` to verify the cooldown timestamp.
- **Expected Result:**
  - Account 2 receives 0.1 Ether.
  - `Withdrawal` event is emitted.
  - `nextAccessTime` is updated to `block.timestamp + 1 days`.
  - Contract balance decreases by 0.1 Ether.

#### 4. Request Tokens (Cooldown Failure)
- **Steps:**
  1. Using Account 2, call `requestTokens()` again immediately.
- **Expected Result:**
  - Transaction reverts with “Cooldown period active” error.
  - No Ether is sent, and balance remains unchanged.

#### 5. Request Tokens (Insufficient Funds)
- **Steps:**
  1. Switch to Account 1 (owner).
  2. Call `withdrawAll()` to drain the contract.
  3. Switch to Account 3 and call `requestTokens()`.
- **Expected Result:**
  - Transaction reverts with “Faucet is out of funds” error.
  - No Ether is sent.

#### 6. Owner Withdraws All Funds
- **Steps:**
  1. Fund the contract with 1 Ether using `deposit()` from Account 1.
  2. Call `withdrawAll()` from Account 1.
  3. Check `getBalance()` and Account 1’s balance.
- **Expected Result:**
  - Contract balance becomes 0.
  - Account 1’s balance increases by 1 Ether.

#### 7. Non-Owner Withdraw Attempt
- **Steps:**
  1. Fund the contract with 1 Ether.
  2. Switch to Account 2 and call `withdrawAll()`.
- **Expected Result:**
  - Transaction reverts with “Only owner can withdraw” error.
  - Contract balance remains unchanged.

#### 8. Direct Ether Transfer (receive())
- **Steps:**
  1. Set “Value” to `0.5 Ether`.
  2. Send a transaction to the contract address (leave function field blank).
  3. Call `getBalance()`.
- **Expected Result:**
  - Balance increases by 0.5 Ether.
  - `Deposit` event is emitted.

---

### Detailed Testing Steps in Remix

1. **Deploy and Fund:**
   - Deploy with Account 1.
   - Send 2 Ether via `deposit()` (Value: 2 Ether).

2. **Test Token Request:**
   - Switch to Account 2.
   - Call `requestTokens()`.
   - Verify balance changes and event logs in the Remix terminal.

3. **Test Cooldown:**
   - Call `requestTokens()` again with Account 2.
   - Check the terminal for the revert message.

4. **Drain and Test Empty Faucet:**
   - Switch to Account 1, call `withdrawAll()`.
   - Switch to Account 3, call `requestTokens()` (should fail).

5. **Test Owner Restrictions:**
   - Fund again with 1 Ether.
   - Switch to Account 2, call `withdrawAll()` (should fail).
   - Switch to Account 1, call `withdrawAll()` (should succeed).

6. **Test Fallback:**
   - Send 0.5 Ether directly to the contract address.
   - Check logs for the `Deposit` event.

---

## Notes
- **Cooldown Limitation:** Remix’s JavaScript VM doesn’t allow time manipulation easily. For full cooldown testing, reduce `lockTime` to `60` (1 minute) or deploy on a testnet like Ropsten with a tool like Hardhat.
- **Gas Costs:** Monitor gas usage in the Remix terminal for optimization insights.
- **Security:** This is a basic implementation. In production, consider adding reentrancy guards (e.g., OpenZeppelin’s `ReentrancyGuard`).

