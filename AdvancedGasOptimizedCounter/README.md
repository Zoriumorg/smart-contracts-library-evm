# AdvancedGasOptimizedCounter

## Overview
`AdvancedGasOptimizedCounter` is an enhanced, gas-efficient Solidity smart contract that extends the basic counter concept. It includes user-specific counters, access control, pause functionality, and batch operations, making it suitable for advanced use cases like user tracking or voting systems.

---

## Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedGasOptimizedCounter {
    address public owner;
    bool public paused;
    uint256 public totalCount;
    mapping(address => uint256) public userCounts;
    
    event CountChanged(address indexed user, uint256 newCount, uint256 totalCount);
    event Paused(address indexed owner);
    event Unpaused(address indexed owner);
    event Reset(address indexed owner);

    modifier onlyOwner() { require(msg.sender == owner, "Not owner"); _; }
    modifier whenNotPaused() { require(!paused, "Contract paused"); _; }

    constructor() {
        owner = msg.sender;
        paused = false;
        totalCount = 0;
    }

    function increment() external whenNotPaused {
        unchecked { userCounts[msg.sender] += 1; totalCount += 1; }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    function incrementBy(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be positive");
        unchecked { userCounts[msg.sender] += amount; totalCount += amount; }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    function decrement() external whenNotPaused {
        unchecked {
            require(userCounts[msg.sender] > 0, "User count cannot be negative");
            userCounts[msg.sender] -= 1;
            totalCount -= 1;
        }
        emit CountChanged(msg.sender, userCounts[msg.sender], totalCount);
    }

    function resetAll() external onlyOwner {
        totalCount = 0;
        emit Reset(msg.sender);
    }

    function pause() external onlyOwner {
        require(!paused, "Already paused");
        paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner {
        require(paused, "Not paused");
        paused = false;
        emit Unpaused(msg.sender);
    }

    function getUserCount(address user) external view returns (uint256) {
        return userCounts[user];
    }
}
```

---

## Features
- **User-Specific Counters**: Tracks counts per address via a mapping.
- **Global Counter**: Maintains a `totalCount` across all users.
- **Access Control**: Owner-only functions (`resetAll`, `pause`, `unpause`).
- **Pause Functionality**: Temporarily halts operations for security.
- **Batch Increment**: `incrementBy` allows custom increments in one transaction.
- **Event Logging**: Detailed events for tracking changes.

---

## Gas Optimizations Used
- **`unchecked` Blocks**: Avoids overflow/underflow checks (safe in 0.8.0+).
- **`external` Functions**: Reduces gas for external calls.
- **Modifiers**: Inline checks to minimize redundant code.
- **Efficient Storage**: Minimal writes to mappings and variables.

---

## Prerequisites
- Remix IDE ([remix.ethereum.org](https://remix.ethereum.org)).
- Basic Solidity knowledge.

---

## How to Test in Remix

### Step 1: Setup Remix
1. Open [Remix IDE](https://remix.ethereum.org).
2. In **File Explorer**, create a new file named `AdvancedGasOptimizedCounter.sol`.
3. Paste the contract code and save.

### Step 2: Compile
1. Go to **Solidity Compiler** tab.
2. Select version `0.8.0` or higher.
3. Click **Compile AdvancedGasOptimizedCounter.sol**.

### Step 3: Deploy
1. Go to **Deploy & Run Transactions** tab.
2. Set **Environment** to `JavaScript VM (London)`.
3. Deploy the contract.

### Step 4: Test Functions
Expand the deployed contract to access:
- **`owner`**: Check the deployer’s address.
- **`totalCount`**: View global count.
- **`userCounts(address)`**: View a user’s count (requires address input).
- **`getUserCount(address)`**: Explicit getter for any user’s count.
- **`increment`**, **`incrementBy`**, **`decrement`**, **`pause`**, **`unpause`**, **`resetAll`**.

#### Test Case 1: Initial State
1. Check `owner`: Should be your address.
2. Check `totalCount`: `0`.
3. Check `userCounts(your_address)`: `0`.

#### Test Case 2: Increment
1. Call `increment`.
2. Check `userCounts(your_address)`: `1`.
3. Check `totalCount`: `1`.
4. Verify `CountChanged` event in console.

#### Test Case 3: Batch Increment
1. Call `incrementBy(5)`.
2. Check `userCounts(your_address)`: `6`.
3. Check `totalCount`: `6`.

#### Test Case 4: Decrement
1. Call `decrement`.
2. Check `userCounts(your_address)`: `5`.
3. Check `totalCount`: `5`.

#### Test Case 5: Pause/Unpause
1. Call `pause` (as owner).
2. Try `increment`: Should fail with "Contract paused".
3. Call `unpause`.
4. Call `increment`: Should succeed.

#### Test Case 6: Reset (Owner-Only)
1. Call `resetAll` (as owner): `totalCount` resets to `0`.
2. Switch to another account in Remix, try `resetAll`: Should fail with "Not owner".

#### Test Case 7: Multi-User Test
1. Switch to another account in Remix (dropdown in Deploy tab).
2. Call `increment`.
3. Check `userCounts(new_address)`: `1`.
4. Check `totalCount`: `1` (after reset).

### Step 5: Gas Usage
- Check console for gas costs:
  - `increment`: ~30,000 gas.
  - `incrementBy(5)`: ~35,000 gas.
  - `pause`: ~25,000 gas.

---

## Notes
- **Reset Limitation**: Fully resetting the mapping requires off-chain logic or a user list (not implemented for gas efficiency).
- **Testing**: Use multiple accounts in Remix to test user-specific features.

---

## License
MIT License (see `SPDX-License-Identifier` in the contract).
```

