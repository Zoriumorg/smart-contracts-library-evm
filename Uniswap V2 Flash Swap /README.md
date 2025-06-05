# Uniswap V2 Flash Swap Example

This repository contains a Solidity smart contract implementing a flash swap using Uniswap V2, along with detailed instructions for deploying and testing on Remix and Foundry. The contract borrows WETH from the Uniswap V2 DAI/WETH pair and repays it with a 0.3% fee in the same transaction.

## File Structure

- `src/UniswapV2FlashSwap.sol`: The main smart contract for the flash swap.
- `test/UniswapV2FlashSwapTest.sol`: Foundry test suite for the contract.
- `README.md`: This documentation file.

## Prerequisites

- **Solidity**: Version ^0.8.26
- **Remix IDE**: [remix.ethereum.org](https://remix.ethereum.org/)
- **MetaMask**: Configured for Sepolia testnet (or mainnet for production).
- **Testnet ETH**: Obtain from a Sepolia faucet (e.g., [Infura Sepolia Faucet](https://www.infura.io/faucet/sepolia)).
- **Testnet Tokens**: WETH and DAI tokens for Sepolia (or mock tokens if unavailable).
- **Foundry**: For local testing (install via [Foundry Book](https://book.getfoundry.sh/)).
- **Node.js and npm**: For Foundry installation.
- **Ethereum Node**: Access to a Sepolia RPC endpoint (e.g., via Infura or Alchemy).

## Smart Contract Overview

The `UniswapV2FlashSwap.sol` contract enables flash swaps on the Uniswap V2 DAI/WETH pair. Key components:

- **Interfaces**: `IUniswapV2Callee`, `IUniswapV2Pair`, `IUniswapV2Factory`, `IERC20`, `IWETH`.
- **Constructor**: Initializes the DAI/WETH pair using the Uniswap V2 Factory.
- **Functions**:
  - `flashSwap(uint256 wethAmount)`: Initiates the flash swap by borrowing WETH.
  - `uniswapV2Call`: Handles repayment with a 0.3% fee.
- **State**: Tracks `amountToRepay` for the borrowed amount plus fee.

## Addressing Deployment Error

The error `status: 0x0 Transaction mined but execution failed` during deployment in Remix likely occurred because:

1. **Mainnet Addresses on Testnet**: The contract uses mainnet addresses (`UNISWAP_V2_FACTORY`, `DAI`, `WETH`), which are invalid on Sepolia.
2. **Non-existent Pair**: The DAI/WETH pair may not exist on Sepolia or lack liquidity.
3. **Gas Issues**: Insufficient gas limit for constructor execution.

To resolve this, we’ll use mock contracts or updated Sepolia addresses and ensure sufficient gas.

## Deployment and Testing on Remix

### Step 1: Prepare the Smart Contract

1. **Create Contract File**:
   - Open [Remix IDE](https://remix.ethereum.org/).
   - Create a new file named `UniswapV2FlashSwap.sol` in the Remix workspace.
   - Copy and paste the following contract code, updated with placeholders for Sepolia addresses (replace with actual addresses if available):

2. **Update Addresses**:
   - Uniswap V2 is not natively deployed on Sepolia. You’ll need to deploy mock contracts for the Uniswap V2 Factory and DAI/WETH pair (see Step 2).
   - Sepolia WETH: `0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9` (confirmed).
   - If Uniswap V2 Factory and DAI addresses are unavailable, deploy mock contracts as described below.

### Step 2: Deploy Mock Contracts (if Uniswap V2 is Unavailable on Sepolia)

Since Uniswap V2 may not be deployed on Sepolia, deploy mock contracts for testing:

1. **Mock ERC20 (DAI)**:
   - Create `MockDAI.sol` in Remix:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.26;

   contract MockDAI {
       string public name = "Mock DAI";
       string public symbol = "mDAI";
       uint8 public decimals = 18;
       uint256 public totalSupply;
       mapping(address => uint256) public balanceOf;
       mapping(address => mapping(address => uint256)) public allowance;

       constructor(uint256 initialSupply) {
           totalSupply = initialSupply * 10 ** decimals;
           balanceOf[msg.sender] = totalSupply;
       }

       function transfer(address recipient, uint256 amount) external returns (bool) {
           require(balanceOf[msg.sender] >= amount, "Insufficient balance");
           balanceOf[msg.sender] -= amount;
           balanceOf[recipient] += amount;
           return true;
       }

       function approve(address spender, uint256 amount) external returns (bool) {
           allowance[msg.sender][spender] = amount;
           return true;
       }

       function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
           require(balanceOf[sender] >= amount, "Insufficient balance");
           require(allowance[sender][msg.sender] >= amount, "Insufficient allowance");
           balanceOf[sender] -= amount;
           balanceOf[recipient] += amount;
           allowance[sender][msg.sender] -= amount;
           return true;
       }
   }
   ```

2. **Mock Uniswap V2 Pair**:
   - Create `MockUniswapV2Pair.sol` in Remix:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.26;

   interface IUniswapV2Callee {
       function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external;
   }

   contract MockUniswapV2Pair {
       address public token0;
       address public token1;

       constructor(address _token0, address _token1) {
           token0 = _token0;
           token1 = _token1;
       }

       function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external {
           require(amount0Out == 0 || amount1Out == 0, "Invalid amounts");
           if (data.length > 0) {
               IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
           }
       }
   }
   ```

3. **Mock Uniswap V2 Factory**:
   - Create `MockUniswapV2Factory.sol` in Remix:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.26;

   contract MockUniswapV2Factory {
       address public pair;

       constructor(address _pair) {
           pair = _pair;
       }

       function getPair(address, address) external view returns (address) {
           return pair;
       }
   }
   ```

4. **Deploy Mock Contracts**:
   - Compile all mock contracts in Remix (Solidity version ^0.8.26).
   - Deploy `MockDAI.sol` with an initial supply (e.g., `1000000000000000000000` for 1000 mDAI).
   - Deploy `MockUniswapV2Pair.sol` with:
     - `_token0`: Mock DAI address.
     - `_token1`: Sepolia WETH address (`0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9`).
   - Deploy `MockUniswapV2Factory.sol` with the deployed `MockUniswapV2Pair` address.
   - Update `UniswapV2FlashSwap.sol` with:
     - `UNISWAP_V2_FACTORY`: Deployed `MockUniswapV2Factory` address.
     - `DAI`: Deployed `MockDAI` address.
     - `WETH`: `0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9`.

### Step 3: Compile the Contract

1. In Remix, go to the **Solidity Compiler** tab.
2. Select compiler version `0.8.26`.
3. Click **Compile UniswapV2FlashSwap.sol**.
4. Ensure no compilation errors.

### Step 4: Deploy the Contract

1. Go to the **Deploy & Run Transactions** tab.
2. Select **Injected Provider - MetaMask** as the environment.
3. Connect MetaMask to Sepolia (ensure 0.1–1 ETH from a faucet).
4. Select `UniswapV2FlashSwap` from the contract dropdown.
5. Set gas limit to 5,000,000 to avoid gas errors.
6. Click **Deploy** and confirm in MetaMask.
7. Note the deployed contract address.
8. **Verify Deployment**:
   - Check the transaction on [Sepolia Etherscan](https://sepolia.etherscan.io/).
   - If it fails (`status: 0x0`), use Remix’s **Debug** tab to inspect:
     - Ensure the `pair` address from `factory.getPair(DAI, WETH)` is valid.
     - Increase gas limit if needed.

### Step 5: Test the Flash Swap

1. **Obtain Testnet Tokens**:
   - Get Sepolia ETH from a faucet.
   - Convert ETH to WETH by calling `deposit` on the WETH contract (`0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9`):
     - In Remix, deploy the WETH contract interface:

       ```solidity
       // SPDX-License-Identifier: MIT
       pragma solidity ^0.8.26;

       interface IWETH {
           function deposit() external payable;
           function balanceOf(address account) external view returns (uint256);
           function approve(address spender, uint256 amount) external returns (bool);
       }
       ```

     - Call `deposit` with 0.1 ETH (value: `100000000000000000` wei).
   - Fund the mock pair with Mock DAI and WETH if using mock contracts:
     - Transfer Mock DAI and WETH to the `MockUniswapV2Pair` address.

2. **Approve WETH**:
   - In Remix, interact with the WETH contract.
   - Call `approve`:
     - **Spender**: Deployed `UniswapV2FlashSwap` address.
     - **Amount**: `10000000000000000000` (10 WETH).
     - Confirm in MetaMask.

3. **Execute Flash Swap**:
   - In Remix, call `flashSwap` on the deployed `UniswapV2FlashSwap` contract.
   - Input `wethAmount`: `1000000000000000000` (1 WETH).
   - Execute and confirm in MetaMask.
   - Check `amountToRepay` to verify the borrowed amount plus fee (1.003 WETH).

4. **Verify Results**:
   - Success: `amountToRepay` reflects borrowed amount + 0.3% fee.
   - Failure: Check:
     - WETH allowance (`allowance` function on WETH contract).
     - Pair liquidity (Mock DAI/WETH balances in `MockUniswapV2Pair`).
     - Gas limit (increase to 5,000,000).

### Step 6: Troubleshooting

- **Deployment Failure**:
  - **Invalid Pair Address**: Ensure `factory.getPair(DAI, WETH)` returns a valid address.
  - **Gas**: Increase gas limit in MetaMask.
  - **Addresses**: Verify `UNISWAP_V2_FACTORY`, `DAI`, and `WETH`.
- **Flash Swap Failure**:
  - **Allowance**: Re-approve WETH with sufficient amount.
  - **Liquidity**: Fund the pair with tokens.
  - **Debug**: Use Remix’s **Debug** tab or Sepolia Etherscan logs.

## Deployment and Testing with Foundry

### Step 1: Set Up Foundry

1. **Install Foundry**:

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. **Initialize Project**:

   ```bash
   forge init uniswap-v2-flash-swap
   cd uniswap-v2-flash-swap
   ```

3. **Install Dependencies**:

   ```bash
   forge install OpenZeppelin/openzeppelin-contracts
   ```

4. **Configure `foundry.toml`**:

   ```toml
   [profile.default]
   src = "src"
   out = "out"
   libs = ["lib"]
   evm_version = "paris"
   [rpc_endpoints]
   sepolia = "${SEPOLIA_RPC_URL}" # Set via environment variable
   ```

### Step 2: Prepare Contracts

1. **Place `UniswapV2FlashSwap.sol`**:
   - Copy the contract from Step 1 (Remix) to `src/UniswapV2FlashSwap.sol`.
2. **Create Test File**:
   - Create `test/UniswapV2FlashSwapTest.sol`:

3. **Update Test Addresses**:
   - Replace `DAI` and `UNISWAP_V2_PAIR` with deployed mock contract addresses from Remix.

### Step 3: Deploy Mock Contracts (if Needed)

1. Deploy `MockDAI`, `MockUniswapV2Pair`, and `MockUniswapV2Factory` on Sepolia using Remix (as described above).
2. Update `UniswapV2FlashSwap.sol` and `UniswapV2FlashSwapTest.sol` with these addresses.

### Step 4: Run Tests

1. **Set Sepolia RPC**:

   ```bash
   export SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_KEY
   ```

2. **Run Tests**:

   ```bash
   forge test --fork-url $SEPOLIA_RPC_URL
   ```

3. **Debugging**:

   ```bash
   forge test --fork-url $SEPOLIA_RPC_URL --debug
   ```

### Step 5: Deploy with Foundry

1. **Set Private Key**:

   ```bash
   export PRIVATE_KEY=your_metamask_private_key
   ```

2. **Deploy Contract**:

   ```bash
   forge create src/UniswapV2FlashSwap.sol:UniswapV2FlashSwap --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY
   ```

3. **Verify Deployment**:
   - Check the transaction on Sepolia Etherscan.
   - Note the contract address for testing.

### Step 6: Test Flash Swap with Foundry

1. **Fund Pair**:
   - Transfer Mock DAI and WETH to the mock pair using Remix or a script:

   ```solidity
   // In Remix, call transfer on MockDAI and WETH to MockUniswapV2Pair
   ```

2. **Run Test Script**:
   - Create `script/FlashSwap.s.sol`:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.8.26;

   import {Script} from "forge-std/Script.sol";
   import "../src/UniswapV2FlashSwap.sol";

   contract FlashSwapScript is Script {
       function run() external {
           vm.startBroadcast();
           UniswapV2FlashSwap uni = UniswapV2FlashSwap(0xYOUR_CONTRACT_ADDRESS);
           IWETH weth = IWETH(0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9);
           weth.deposit{value: 1e18}();
           weth.approve(address(uni), 10e18);
           uni.flashSwap(1e18);
           vm.stopBroadcast();
       }
   }
   ```

3. **Execute Script**:

   ```bash
   forge script script/FlashSwap.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
   ```

## Troubleshooting

- **Remix Deployment**:
  - **Error: `status: 0x0`**: Verify `UNISWAP_V2_FACTORY`, `DAI`, and `WETH` addresses. Use mock contracts if needed.
  - **Gas**: Increase gas limit to 5,000,000.
- **Flash Swap Failure**:
  - **Allowance**: Ensure WETH approval is sufficient.
  - **Liquidity**: Fund the pair with tokens.
- **Foundry**:
  - **Fork Errors**: Verify Sepolia RPC URL.
  - **Test Failures**: Check mock contract addresses and liquidity.

## Security Notes

- **Testing Only**: This contract is for educational purposes. For production, add:
  - Reentrancy guards.
  - Robust error handling.
  - Liquidity checks.
- **Audit**: Audit thoroughly before mainnet deployment.
- **Mainnet**: Update addresses to mainnet values and verify pair liquidity.

## License

MIT License (see `SPDX-License-Identifier` in contract files).
