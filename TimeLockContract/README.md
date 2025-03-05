# TimeLockContract
A simple Ethereum smart contract that locks Ether (ETH) for a specified period, allowing a designated beneficiary to withdraw the funds once the release time is reached.

## Overview

`TimeLockContract` is a Solidity-based smart contract that enables users to lock Ether for a specific duration. The contract is initialized with a beneficiary address and a release timestamp. Once the release time is reached, the beneficiary can withdraw the locked funds. The contract includes safety features such as re-entrancy protection and validation checks.

### Key Features
- Locks Ether until a specified future timestamp.
- Only the designated beneficiary can withdraw funds.
- Provides functions to check the contract balance and remaining time.
- Emits events for locking and withdrawing funds.
- - **Locking Funds:** The contract deployer sends Ether to be locked until a future timestamp.
- **Time-based Withdrawal:** The beneficiary can withdraw the funds only after the specified release time.
- **Balance Checking:** Anyone can check the contract balance.
- **Time Remaining:** The contract provides a function to check how much time is left before withdrawal is allowed.
- **Secure Transactions:** Implements re-entrancy prevention to avoid vulnerabilities.

## Prerequisites

- **Solidity Version**: `^0.8.0`
- **Ethereum Network**: Deployable on Ethereum mainnet, testnets (e.g., Sepolia, Goerli), or local development environments (e.g., Hardhat, Truffle).
- **Tools**: 
  - A Solidity compiler (e.g., Remix, Hardhat, Truffle).
  - An Ethereum wallet (e.g., MetaMask) with ETH for deployment and testing.

## Installation

1. **Clone or Copy the Contract**:
   - Copy the contract code into your development environment (e.g., Remix IDE or a local project).

2. **Compile the Contract**:
   - Use a Solidity compiler compatible with version `^0.8.0`.
   - Example in Remix: Select compiler version `0.8.x` and click "Compile".

3. **Deploy the Contract**:
   - Deploy using a tool like Remix, Hardhat, or Truffle.
   - Provide the following parameters during deployment:
     - `_beneficiary`: The Ethereum address that can withdraw the funds.
     - `_releaseTime`: A Unix timestamp (in seconds) when funds can be released.
     - Send some ETH with the deployment transaction to lock funds.

   Example (in JavaScript with ethers.js):
   ```javascript
   const TimeLockContract = await ethers.getContractFactory("TimeLockContract");
   const contract = await TimeLockContract.deploy(beneficiaryAddress, releaseTimestamp, { value: ethers.utils.parseEther("1.0") });
   await contract.deployed();
   ```

   ```javascript
   Math.floor(Date.now() / 1000) + 3600; // 1 hour from now
    Example output: 1730678400 (adjust based on your current time).
   ```

## Usage

### Deploying the Contract
- Deploy the contract with a beneficiary address, a future release timestamp, and some ETH.
- Example: Lock 1 ETH (Unix timestamp: `1743388800`).

## Deployment
### Using Remix
1. Open **Remix IDE** and paste the contract code.
2. Select **Solidity Compiler** and choose a version `0.8.x`.
3. Click **Compile**.
4. Go to **Deploy & Run Transactions** tab.
5. Select **Injected Web3** (for MetaMask) or **Remix VM**.
6. Enter the required constructor parameters:
   - **Beneficiary Address:** (e.g., `0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2`)
   - **Release Time:** (e.g., `1730678400` for 1 hour from now)
   - **Value:** Set an ETH amount (e.g., `0.1 ETH`).
7. Click **Deploy** and confirm the transaction.

### Interacting with the Contract
- **Check Balance**: Call `getBalance()` to see the locked ETH amount.
- **Check Time Remaining**: Call `timeRemaining()` to see how many seconds are left until the funds are unlocked.
- **Withdraw Funds**: After the release time, the beneficiary can call `withdraw()` to retrieve the funds.

### Example Transactions
1. **Lock Funds**:
   - Deploy with `beneficiary = 0xYourAddress` and `releaseTime = 1743388800`.
   - Send 1 ETH during deployment.

2. **Withdraw Funds**:
   - After the release time, call `withdraw()` from the beneficiary address.

## Contract Details

### State Variables
- `owner`: The address that deployed the contract.
- `beneficiary`: The address allowed to withdraw funds.
- `releaseTime`: The Unix timestamp when funds can be withdrawn.
- `lockedAmount`: The amount of ETH locked in the contract.

### Functions
- `constructor(address _beneficiary, uint256 _releaseTime)`: Initializes the contract with a beneficiary and release time, locking the sent ETH.
- `withdraw()`: Allows the beneficiary to withdraw funds after the release time.
- `getBalance()`: Returns the current ETH balance of the contract.
- `timeRemaining()`: Returns the seconds remaining until the release time (or 0 if time has passed).

### Events
- `FundsLocked(address sender, uint256 amount, uint256 releaseTime)`: Emitted when funds are locked.
- `FundsWithdrawn(address beneficiary, uint256 amount)`: Emitted when funds are withdrawn.

## Security Considerations
- **Re-entrancy Protection**: The `lockedAmount` is set to 0 before transferring funds in `withdraw()`.
- **Input Validation**: Ensures the beneficiary is not the zero address, the release time is in the future, and ETH is sent during deployment.
- **Access Control**: Only the beneficiary can withdraw funds.

## License
This contract is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the SPDX identifier at the top of the contract file.

## Contributing
Feel free to fork, modify, or submit pull requests to enhance this contract. Suggestions for improvements (e.g., adding multi-beneficiary support or time extensions) are welcome!

## Disclaimer
This contract is provided as-is. Always audit smart contracts and test thoroughly on testnets before deploying to the Ethereum mainnet with real funds.

