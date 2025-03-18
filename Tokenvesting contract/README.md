# Token Vesting Project

This project consists of two smart contracts: `MyToken.sol` (an ERC20 token) and `Vesting.sol` (a vesting contract for locking and releasing tokens). The goal is to deploy a token, lock a portion of it in the vesting contract, and allow a receiver to withdraw the tokens after a specified time.

- **`MyToken.sol`**: A simple ERC20 token contract with an initial supply of 10,000 tokens minted to the deployer.
- **`Vesting.sol`**: A vesting contract that locks tokens for a receiver and releases them after an expiry time.

## Prerequisites

- **Remix IDE**: Use [Remix](https://remix.ethereum.org/) to compile, deploy, and test the contracts.
- **Solidity Compiler**: Version `0.8.4` or higher.
- **OpenZeppelin**: The contracts use OpenZeppelin v4.7.3 (`ERC20` and `IERC20`).

## Contract Details

### MyToken.sol
- **Token Name**: MyToken
- **Symbol**: MTK
- **Decimals**: 18 (standard ERC20)
- **Initial Supply**: 10,000 tokens (minted to the deployer).

### Vesting.sol
- **Token**: Reference to an ERC20 token (e.g., `MyToken`).
- **Receiver**: Address that will receive the vested tokens.
- **Amount**: Number of tokens to lock.
- **Expiry**: Unix timestamp after which tokens can be withdrawn.
- **Locked**: Boolean to ensure tokens are locked only once.
- **Claimed**: Boolean to prevent double claiming.

## Deployment and Testing in Remix

### Step 1: Setup Remix Environment
1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create two files: `MyToken.sol` and `Vesting.sol`.
3. Copy and paste the respective contract code into these files.
4. Install OpenZeppelin dependencies:
   - In Remix, go to the "File Explorer" tab.
   - Right-click and select "Add a dependency".
   - Enter: `https://github.com/OpenZeppelin/openzeppelin-contracts/tree/v4.7.3/`.
   - This will import the required ERC20 and IERC20 contracts.

### Step 2: Compile the Contracts
1. Go to the "Solidity Compiler" tab in Remix.
2. Select compiler version `0.8.4`.
3. Compile `MyToken.sol` and `Vesting.sol` individually.

### Step 3: Deploy MyToken.sol
1. Go to the "Deploy & Run Transactions" tab.
2. Select "JavaScript VM" (or another test environment like Injected Web3 with MetaMask for a testnet).
3. Deploy `MyToken`:
   - Select `MyToken` from the contract dropdown.
   - Click "Deploy".
   - After deployment, note the contract address (e.g., `0x123...`).
4. Verify the deployment:
   - Call the `balanceOf` function with the deployer's address (e.g., the first account in JavaScript VM).
   - It should return `10000 * 10^18` (10,000 tokens with 18 decimals).

### Step 4: Deploy Vesting.sol
1. Deploy `Vesting`:
   - Select `Vesting` from the contract dropdown.
   - In the constructor field, provide the `MyToken` contract address (e.g., `0x123...`).
   - Click "Deploy".
   - Note the `Vesting` contract address (e.g., `0x456...`).
2. Verify the token address:
   - Call the `token` function on the `Vesting` contract to ensure it matches the `MyToken` address.

### Step 5: Lock Tokens in Vesting
1. Approve the `Vesting` contract to spend tokens:
   - Switch to the `MyToken` contract in Remix.
   - Call the `approve` function:
     - `spender`: `Vesting` contract address (e.g., `0x456...`).
     - `amount`: `1000 * 10^18` (e.g., 1,000 tokens in wei).
   - Confirm the transaction.
2. Lock tokens in the `Vesting` contract:
   - Switch to the `Vesting` contract.
   - Call the `lock` function:
     - `_from`: Deployer's address (e.g., the account that owns the tokens).
     - `_receiver`: Address to receive tokens after vesting (e.g., another test account like `0x789...`).
     - `_amount`: `1000 * 10^18` (1,000 tokens in wei).
     - `_expiry`: Unix timestamp for when tokens can be withdrawn (e.g., current time + 1 hour = `block.timestamp + 3600`).
     - Use the `getTime` function to get the current `block.timestamp` and calculate `_expiry`.
   - Confirm the transaction.
3. Verify the lock:
   - Check `receiver`, `amount`, `expiry`, and `locked` variables in the `Vesting` contract.
   - Ensure `locked` is `true`.

### Step 6: Test Token Withdrawal
1. Check the current time:
   - Call `getTime` on the `Vesting` contract to get `block.timestamp`.
2. Simulate time passing (in JavaScript VM):
   - In Remix, you can't directly manipulate time, but you can set `_expiry` to a past timestamp (e.g., `block.timestamp - 1`) during testing to simulate an expired vesting period.
   - Alternatively, deploy with a very short vesting period (e.g., `block.timestamp + 10`) and wait a few seconds.
3. Withdraw tokens:
   - Call the `withdraw` function from the receiver's address (e.g., `0x789...`).
   - Ensure `block.timestamp > expiry` and `claimed` is `false`.
   - Confirm the transaction.
4. Verify the withdrawal:
   - Check the `claimed` variable (should be `true`).
   - In `MyToken`, call `balanceOf` with the receiver’s address (e.g., `0x789...`) to confirm they received 1,000 tokens.

### Time Management
- The `getTime` function returns the current `block.timestamp`, which represents the time in seconds since the Unix epoch (January 1, 1970).
- To calculate `_expiry`, add the desired vesting period (in seconds) to the current `block.timestamp`. For example:
  - 1 hour = `block.timestamp + 3600`.
  - 1 day = `block.timestamp + 86400`.
- In a real blockchain (e.g., Ethereum testnet), time progresses naturally. In Remix's JavaScript VM, you must simulate time by setting `_expiry` appropriately.

## Testing Scenarios
1. **Successful Vesting and Withdrawal**:
   - Lock 1,000 tokens with an expiry of `block.timestamp + 10`.
   - Wait or set expiry to a past time, then call `withdraw` from the receiver’s address.
   - Verify the receiver’s balance increases by 1,000 tokens.

2. **Premature Withdrawal**:
   - Try calling `withdraw` before `expiry`.
   - Expect a revert with the message: `"Tokens have not been unlocked"`.

3. **Double Claim**:
   - After a successful withdrawal, try calling `withdraw` again.
   - Expect a revert with the message: `"Tokens have already been claimed"`.

4. **Locking Twice**:
   - After locking tokens, try calling `lock` again.
   - Expect a revert with the message: `"We have already locked tokens."`.

## Notes
- **Token Approval**: Ensure the `Vesting` contract is approved to spend tokens from the `_from` address using `approve` in `MyToken`.
- **Units**: Amounts are in wei (1 token = `10^18` wei due to 18 decimals).
- **Environment**: JavaScript VM in Remix is ideal for quick testing. For real-world deployment, use a testnet like Rinkeby or Sepolia with MetaMask.

## Troubleshooting
- **"TransferFrom failed"**: Ensure the `approve` step was completed and the `_from` address has sufficient tokens.
- **"Tokens not unlocked"**: Check that `block.timestamp > expiry`.
- **Compilation Errors**: Verify OpenZeppelin imports and Solidity version.

