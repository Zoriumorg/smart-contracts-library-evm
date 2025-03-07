# CrowdsaleContract

![Solidity](https://img.shields.io/badge/Solidity-0.8.x-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A simple Solidity smart contract for conducting a token crowdsale with a fixed price. This contract allows users to purchase an ERC20 token by sending Ether (ETH) at a predefined rate, while providing the contract owner with tools to manage the sale and withdraw funds.



## Overview

`CrowdsaleContract` is a Solidity smart contract designed for a straightforward **token sale (crowdsale)**. Users can buy a designated ERC20 token by sending ETH to the contract at a fixed rate (e.g., 100 tokens per 1 ETH). The contract includes owner-only functions to toggle the sale, withdraw collected ETH, and recover unsold tokens. It’s ideal for small-scale token distributions, such as Initial Coin Offerings (ICOs), or for educational purposes.

---

## Features

- **Fixed-Rate Token Sale**: Users purchase tokens at a set rate (e.g., 100 tokens per ETH).
- **Owner Controls**: Only the deployer can pause/resume the sale, withdraw ETH, or reclaim unsold tokens.
- **Event Logging**: Tracks every purchase with the `TokensPurchased` event for transparency.
- **Safety Checks**: Ensures the sale is active and sufficient tokens are available before purchases.

---

## Contract Details

### Imports
```solidity
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
```
- Uses OpenZeppelin’s `IERC20` interface to interact with an ERC20 token contract.

### State Variables
| Variable         | Type      | Description                                      |
|------------------|-----------|--------------------------------------------------|
| `owner`          | `address` | Address of the contract deployer.                |
| `token`          | `IERC20`  | The ERC20 token being sold.                      |
| `rate`           | `uint256` | Number of tokens per ETH (e.g., 100).            |
| `weiRaised`      | `uint256` | Total ETH collected (in wei).                    |
| `saleActive`     | `bool`    | Indicates if the sale is active (`true`/`false`).|

### Event
```solidity
event TokensPurchased(address buyer, uint256 amountETH, uint256 amountTokens);
```
- Logs the buyer’s address, ETH sent, and tokens received for each purchase.

### Constructor
```solidity
constructor(address _token, uint256 _rate) {
    owner = msg.sender;
    token = IERC20(_token);
    rate = _rate;
    saleActive = true;
}
```
- Initializes the contract with the token address, rate, and sets the sale to active.

### Modifier
```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;
}
```
- Restricts certain functions to the contract owner.

### Functions
| Function          | Description                                      | Access         |
|-------------------|--------------------------------------------------|----------------|
| `buyTokens()`     | Allows users to buy tokens by sending ETH.       | Public, payable|
| `withdrawETH()`   | Withdraws all collected ETH to the owner.        | Owner only     |
| `toggleSale()`    | Toggles the sale on or off.                      | Owner only     |
| `withdrawTokens()`| Transfers remaining tokens to the owner.         | Owner only     |

#### `buyTokens()`
- **Purpose**: Users send ETH to purchase tokens.
- **Logic**: Calculates tokens (`ETH * rate`), checks token availability, transfers tokens, and updates `weiRaised`.
- **Example**: Sending 1 ETH with `rate = 100` yields 100 tokens.

#### `withdrawETH()`
- **Purpose**: Transfers all ETH in the contract to the owner.

#### `toggleSale()`
- **Purpose**: Enables or disables token purchases.

#### `withdrawTokens()`
- **Purpose**: Recovers unsold tokens to the owner’s address.

---

## Prerequisites

To deploy and use this contract, you’ll need:
- **Solidity Compiler**: Version `0.8.x`.
- **Remix IDE**: For development/testing (https://remix.ethereum.org/).
- **MetaMask**: For Ethereum transactions (use a testnet like Sepolia).
- **ERC20 Token**: An existing token contract to sell (e.g., `MyToken`).
- **Test ETH**: Obtainable from a testnet faucet.

---

## Deployment

### Using Remix
1. **Open Remix**:
   - Go to https://remix.ethereum.org/.
   - Create a new file: `CrowdsaleContract.sol`.

2. **Add OpenZeppelin Dependency**:
   - In the "File Explorers" tab, import:
     ```
     https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
     ```

3. **Compile**:
   - Select "Solidity Compiler" tab.
   - Choose version `0.8.x`.
   - Compile `CrowdsaleContract.sol`.

4. **Deploy**:
   - Go to "Deploy & Run Transactions".
   - Environment: "Injected Provider - MetaMask" (connect to a testnet) or "Remix VM".
   - Inputs:
     - `_token`: ERC20 token address (e.g., `0x123...`).
     - `_rate`: Tokens per ETH (e.g., `100`).
   - Click "Deploy" and confirm via MetaMask.

5. **Fund the Contract**:
   - Transfer tokens to the contract address using the ERC20 `transfer` function.

---

## Usage

### Example Workflow
1. Deploy with `_token = 0x123...` (e.g., `MyToken`) and `_rate = 100`.
2. Transfer 10,000 tokens to the contract.
3. User sends 1 ETH to `buyTokens` → Receives 100 tokens.
4. Owner calls `withdrawETH` → Collects 1 ETH.
5. Owner calls `withdrawTokens` → Retrieves 9,900 unsold tokens.

### Interacting with Functions
- **`buyTokens()`**: Send ETH (e.g., `1 ether`) to buy tokens.
- **`withdrawETH()`**: Call as owner to withdraw ETH.
- **`toggleSale()`**: Call as owner to pause/resume the sale.
- **`withdrawTokens()`**: Call as owner to recover tokens.

---

## Testing

### In Remix
1. **Deploy a Test Token**:
   ```solidity
   pragma solidity ^0.8.0;
   import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
   contract MyToken is ERC20 {
       constructor() ERC20("MyToken", "MTK") {
           _mint(msg.sender, 10000 * 10**18);
       }
   }
   ```
2. **Deploy CrowdsaleContract**:
   - Use the `MyToken` address and `rate = 100`.
3. **Test `buyTokens`**:
   - Send 1 ETH → Verify token balance increases by 100.
4. **Test Owner Functions**:
   - Toggle sale, withdraw ETH, and recover tokens.

### Common Issues
- **"Send some ETH"**: Ensure ETH is sent with `buyTokens`.
- **"Not enough tokens"**: Fund the contract with tokens first.
- **"Sale is not active"**: Enable the sale with `toggleSale`.

---

## Notes

- **Security**: This is a basic contract. For production use, consider:
  - Adding a sale cap (max ETH/tokens).
  - Implementing time limits (start/end dates).
  - Using OpenZeppelin’s `ReentrancyGuard` for safety.
- **Token Decimals**: Assumes 18 decimals (standard for ERC20). Adjust `rate` if different.
- **Gas Costs**: Approximately 50,000 gas per transaction on testnets.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Contributing

Contributions are welcome! Fork this repository, submit issues, or create pull requests with enhancements.

