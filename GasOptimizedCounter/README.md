# GasOptimizedCounter

## Overview
`GasOptimizedCounter` is a simple, gas-efficient Solidity smart contract that implements a counter with increment and decrement functionality. It is designed to minimize gas costs using modern Solidity optimizations while maintaining basic functionality. The contract includes:
- A public `count` variable to track the counter value.
- Functions to `increment` and `decrement` the counter.
- An event `CountChanged` to log updates.
- Basic error handling to prevent negative counts.

This contract is ideal for learning about gas optimization techniques in Solidity and can be tested easily in Remix.



## Features
- **Public Counter**: The `count` variable is `public`, providing a free getter function.
- **Increment**: Increases the counter by 1 with minimal gas usage.
- **Decrement**: Decreases the counter by 1, with a check to prevent negative values.
- **Event Logging**: Emits `CountChanged` event after each update for transparency.

---

## Gas Optimizations Used
The contract incorporates several gas-saving techniques:
- **`unchecked` Blocks**: Skips unnecessary overflow/underflow checks (safe in Solidity 0.8.0+), reducing gas costs.
- **`external` Functions**: Uses `external` instead of `public` for functions called externally, lowering gas consumption.
- **`public` Variable**: Relies on the automatic getter for `count` instead of a custom function, avoiding extra code.
- **Simple Logic**: Minimizes storage operations and complex computations for efficiency.

---

## Prerequisites
- A web browser to access Remix IDE.
- Basic understanding of Solidity and Ethereum smart contracts.

---

## How to Test the Contract in Remix

### Step 1: Setup Remix
1. Open Remix in your browser: [remix.ethereum.org](https://remix.ethereum.org).
2. In the **File Explorer** (left panel), click the "+" button to create a new file.
3. Name the file `GasOptimizedCounter.sol` and paste the contract code above.
4. Save the file (Ctrl + S or Cmd + S).

### Step 2: Compile the Contract
1. Navigate to the **Solidity Compiler** tab (left sidebar, hammer icon).
2. Select a compiler version of `0.8.0` or higher (e.g., 0.8.24).
3. Click **Compile GasOptimizedCounter.sol**.
   - Check the console below for any errors (should be none if copied correctly).

### Step 3: Deploy the Contract
1. Go to the **Deploy & Run Transactions** tab (left sidebar, play icon).
2. Set the **Environment** to `JavaScript VM (London)` (a simulated blockchain with fake ETH).
3. Ensure the contract dropdown shows `GasOptimizedCounter`.
4. Click **Deploy**.
   - The deployed contract will appear under "Deployed Contracts" in the panel below.

### Step 4: Test the Functions
Expand the `GasOptimizedCounter` contract under "Deployed Contracts" to interact with its functions:
- **`count`**: Displays the current counter value.
- **`increment`**: Increases the counter by 1.
- **`decrement`**: Decreases the counter by 1.

#### Test Case 1: Check Initial Value
1. Click the `count` button.
   - **Expected Output**: `0`.
   - **Explanation**: The constructor initializes `count` to 0.

#### Test Case 2: Increment the Counter
1. Click the `increment` button.
2. Click `count` again.
   - **Expected Output**: `1`.
   - **Explanation**: `increment` adds 1 to `count` and emits `CountChanged(1)`.
3. Check the Remix console (bottom) for the `CountChanged` event with `newCount: 1`.

#### Test Case 3: Multiple Increments
1. Click `increment` two more times.
2. Click `count`.
   - **Expected Output**: `3`.
   - **Explanation**: Each call increments `count` (1 → 2 → 3).

#### Test Case 4: Decrement the Counter
1. Click `decrement`.
2. Click `count`.
   - **Expected Output**: `2`.
   - **Explanation**: `decrement` reduces `count` from 3 to 2.
3. Verify the `CountChanged` event in the console with `newCount: 2`.

#### Test Case 5: Attempt Decrement Below Zero
1. Click `decrement` twice (current count is 2).
   - First click: `count` becomes 1.
   - Second click: `count` becomes 0.
2. Click `decrement` again.
   - **Expected Output**: Transaction fails with "Counter cannot be negative".
   - **Explanation**: The `require(count > 0)` prevents negative values.
3. Click `count` to confirm it remains `0`.

### Step 5: Check Gas Usage
1. After each transaction (e.g., `increment` or `decrement`), review the Remix console.
2. Look for "gas used" in the transaction receipt:
   - **`increment`**: Approximately 25,000–30,000 gas.
   - **`decrement`**: Approximately 30,000–35,000 gas (higher due to `require`).
   - These low costs reflect the gas optimizations.

### Step 6: View Events
1. In the console, expand the "logs" section of any transaction.
2. Verify the `CountChanged` event:
   - Example: `args: { newCount: 3 }`.
   - Confirms the event is emitted correctly.

---

## Additional Notes
- **JavaScript VM**: Provides a simulated blockchain for free testing with fake ETH.
- **Error Handling**: If a transaction reverts (e.g., decrementing below 0), check the console for the error message.
- **Gas Comparison**: To see the impact of `unchecked`, remove it, recompile, and redeploy—gas costs will increase slightly.

---

## License
This project is licensed under the MIT License - see the `SPDX-License-Identifier` in the contract for details.

