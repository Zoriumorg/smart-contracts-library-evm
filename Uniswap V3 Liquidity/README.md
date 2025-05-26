# UniswapV3Liquidity Contract README

## Overview

The `UniswapV3Liquidity` contract is a Solidity smart contract designed to interact with Uniswap V3, a decentralized exchange (DEX) protocol on Ethereum. It enables users to:

- **Mint new liquidity positions** in the DAI/WETH pool.
- **Collect trading fees** earned from providing liquidity.
- **Increase or decrease liquidity** in existing positions.
- **Receive Uniswap V3 position NFTs** safely.

This contract simplifies the process of managing liquidity positions in Uniswap V3, making it easier for users to participate in decentralized finance (DeFi) by providing liquidity and earning fees.

## Real-World Use Case

### Why Use This Contract?

In the real world, Uniswap V3 allows users to provide liquidity to trading pairs (e.g., DAI/WETH) within specific price ranges, earning fees when trades occur in that range. This contract automates and streamlines the process of:

- **Adding liquidity**: Users can deposit DAI and WETH to create a position, earning fees when traders swap between these tokens.
- **Managing positions**: Users can adjust liquidity (add or remove) and collect fees without directly interacting with Uniswap’s complex `NonfungiblePositionManager` contract.
- **Earning passive income**: By providing liquidity, users earn a share of the 0.3% trading fee (set in the contract) for each trade in the DAI/WETH pool.
- **DeFi integration**: This contract can be integrated into larger DeFi applications, such as yield farming platforms or automated market makers (AMMs), to manage liquidity programmatically.

### How It’s Used

- **Individual investors**: Provide liquidity to earn fees in a popular trading pair like DAI/WETH, which is stable (DAI) and volatile (WETH), balancing risk and reward.
- **DeFi protocols**: Use this contract as a building block to manage liquidity pools, automate fee collection, or integrate with other protocols like Aave or Compound.
- **Developers**: Test Uniswap V3 interactions in a controlled environment before deploying on Ethereum mainnet, saving costs by using testnets like Sepolia.

### Benefits

- **Efficiency**: Simplifies Uniswap V3’s complex interface for liquidity management.
- **Cost-effective testing**: Deploy and test on Sepolia to avoid mainnet gas costs.
- **Flexibility**: Supports adding/removing liquidity and collecting fees in a single contract.
- **NFT-based positions**: Leverages Uniswap V3’s NFT system to represent unique liquidity positions.

### Risks

- **Impermanent loss**: Liquidity providers may lose value if DAI/WETH prices move significantly.
- **Gas costs**: On mainnet, transactions can be expensive; testing on Sepolia mitigates this.
- **Security**: The contract lacks access control (e.g., `onlyOwner`), so anyone can call its functions. For production, add modifiers to restrict access.

## Deployed Contract Details

- **Contract Name**: UniswapV3Liquidity
- **Network**: Sepolia Testnet (Chain ID: 11155111)
- **Contract Address**: `0x6D13619343bFAb5C852dF780C7DbE076f3a215a9` (replace with the full address from your deployment)
- **Block Hash**: `https://eth-sepolia.blockscout.com/tx/0x12cae80c2661f50d30e3471573b5c61b0bcd7b0da52c137c7ad8178c3d9ae33f`
- **Transaction Hash**: `0x12cae80c2661f50d30e3471573b5c61b0bcd7b0da52c137c7ad8178c3d9ae33f`
- **Deployer Address**: `0x0eD1D57b8945bD696eb2519C2Bde0F4BE2A747A2`
- **Deployment Date**: Not specified (update with the date from Etherscan)
- **Etherscan Link**: [Sepolia Etherscan](https://sepolia.etherscan.io/address/0x6D1...215a9) (update with full address)
- **Block Explorer**: [Blockscout](https://sepolia.blockscout.com/) (alternative explorer)

Verify the contract on [Sepolia Etherscan](https://sepolia.etherscan.io/) to view source code and transaction details.

## Token Addresses for Sepolia

The contract uses DAI and WETH addresses, which must be updated for Sepolia (the provided addresses are for Ethereum mainnet). Use the following:

- **DAI Address**: `0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6`  
  - Source: [Ethereum Stack Exchange](https://ethereum.stackexchange.com/questions/159838/how-to-get-dai-tokens-on-metamask-for-sepolia-test-network)[](https://ethereum.stackexchange.com/questions/167704/how-to-get-dai-tokens-on-metamask-for-sepolia-test-network)
- **WETH Address**: `0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9`  
  - Source: [Reddit r/ethdev](https://www.reddit.com/r/ethdev/comments/1e5a3ck/how_can_i_get_the_official_weth_which_is_different/)[](https://www.reddit.com/r/ethdev/comments/1e58upm/how_can_i_get_the_official_weth_which_is/)
- **NonfungiblePositionManager**: `0xC36442b4a4522E871399CD717aBDD847Ab11FE88` (correct for Sepolia)

**Note**: Always verify addresses on [Sepolia Etherscan](https://sepolia.etherscan.io/) or Uniswap’s official documentation before using.

## Prerequisites

- **Wallet**: MetaMask or any wallet connected to Sepolia with test ETH.
- **Sepolia ETH**: Obtain from faucets like:
  - [Alchemy Sepolia Faucet](https://www.alchemy.com/faucets/ethereum-sepolia)[](https://www.alchemy.com/faucets/ethereum-sepolia)
  - [QuickNode Sepolia Faucet](https://faucet.quicknode.com/drip)[](https://cryptnox.com/how-to-get-test-coins-from-sepolia-network/)
- **Test DAI and WETH**: Get from:
  - [Aave Sepolia Faucet](https://app.aave.com/faucet/) for DAI (address: `0xC959483DBa39aa9E78757139af0e9a2EDEb3f42D`)[](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses)
  - Swap Sepolia ETH for WETH on [Uniswap V3 Sepolia](https://app.uniswap.org/) or use a faucet if available.
- **Remix IDE**: Access at [remix.ethereum.org](https://remix.ethereum.org/).
- **Gas Limit**: Set to 3,000,000 to avoid out-of-gas errors.

## How to Test the Contract

Follow these steps to test the contract on Sepolia using Remix IDE. These steps assume the contract is already deployed at `0x6D1...215a9`.

### Step 1: Update Contract Addresses

1. Open Remix at [remix.ethereum.org](https://remix.ethereum.org/).
2. Load your contract file (`UniswapV3Liquidity.sol`).
3. Update the DAI and WETH addresses to Sepolia’s:

   ```solidity
   address constant DAI = 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6;
   address constant WETH = 0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9;
   ```

4. Compile the contract (Solidity version: 0.8.26, EVM: Prague).

### Step 2: Connect Wallet

1. In MetaMask, switch to the Sepolia network (Chain ID: 11155111).
2. Add Sepolia to MetaMask if not already added:
   - RPC URL: [https://rpc.sepolia.dev](https://rpc.sepolia.dev)[](https://sepolia.dev/)
   - Chain ID: 11155111
   - Currency: ETH
3. Ensure your wallet (`0x0eD1...747A2`) has Sepolia ETH and test DAI/WETH.

### Step 3: Approve Tokens

1. In Remix, create a new file (`IERC20.sol`) and paste the `IERC20` interface (from your contract code).
2. Compile `IERC20.sol`.
3. In the “Deploy & Run Transactions” tab:
   - Load the IERC20 interface at the DAI address (`0x3e622317...`).
   - Call `approve`:
     - `spender`: Your contract address (`0x6D1...215a9`).
     - `amount`: `1000000000000000000000` (1000 DAI, 18 decimals).
     - Confirm in MetaMask.
   - Repeat for WETH (`0x7b79995e...`) with `amount`: `1000000000000000000` (1 WETH).

### Step 4: Test Minting a New Position

1. In Remix, load the deployed contract at `0x6D1...215a9`.
2. Call `mintNewPosition`:
   - `amount0ToAdd`: `1000000000000000000000` (1000 DAI).
   - `amount1ToAdd`: `1000000000000000000` (1 WETH).
3. Click “Transact” and confirm in MetaMask.
4. Check the Remix console for:
   - `tokenId`: The NFT ID of the position.
   - `liquidity`: Amount of liquidity added.
   - `amount0`/`amount1`: Actual DAI/WETH used.
5. Verify the transaction on [Sepolia Etherscan](https://sepolia.etherscan.io/).
6. Save the `tokenId` for later tests.

### Step 5: Test Collecting Fees

1. Call `collectAllFees` with the `tokenId` from Step 4.
2. Click “Transact” and confirm.
3. Check the console for `amount0` (DAI fees) and `amount1` (WETH fees).
4. Note: Fees may be zero on Sepolia due to low pool activity. For realistic testing, fork Ethereum mainnet using Hardhat.

### Step 6: Test Increasing Liquidity

1. Approve additional DAI/WETH (e.g., 500 DAI: `500000000000000000000`, 0.5 WETH: `500000000000000000`).
2. Call `increaseLiquidityCurrentRange`:
   - `tokenId`: From Step 4.
   - `amount0ToAdd`: `500000000000000000000` (500 DAI).
   - `amount1ToAdd`: `500000000000000000` (0.5 WETH).
3. Check outputs: `liquidity`, `amount0`, `amount1`.

### Step 7: Test Decreasing Liquidity

1. Load the `INonfungiblePositionManager` interface at `0xC36442b4...` in Remix.
2. Call `positions(tokenId)` to get the current `liquidity` of the position.
3. Call `decreaseLiquidityCurrentRange`:
   - `tokenId`: From Step 4.
   - `liquidity`: Half of the position’s liquidity (e.g., if `positions` returns 1000, use 500).
4. Check outputs: `amount0` (DAI returned), `amount1` (WETH returned).

### Step 8: Test NFT Receiver

1. The `mintNewPosition` test triggers `onERC721Received` automatically.
2. To test manually, use `NonfungiblePositionManager`’s `safeTransferFrom` to send the NFT to the contract.
3. Verify the contract accepts the NFT without reverting.

### Step 9: Debug Issues

- **Gas Errors**: Increase gas limit to 5,000,000 if transactions fail.
- **Token Shortage**: Ensure your wallet has enough DAI/WETH.
- **Invalid Addresses**: Verify DAI/WETH addresses on [Sepolia Etherscan](https://sepolia.etherscan.io/).
- **Low Fees**: Use a mainnet fork for realistic fee testing.

## Additional Resources

- **Uniswap V3 Documentation**: [docs.uniswap.org](https://docs.uniswap.org/)
- **Sepolia Faucets**:
  - [Chainlink Faucet](https://faucets.chain.link/)[](https://faucets.chain.link/sepolia)
  - [QuickNode Faucet](https://faucet.quicknode.com/drip)[](https://cryptnox.com/how-to-get-test-coins-from-sepolia-network/)
- **Sepolia Block Explorers**:
  - [Sepolia Etherscan](https://sepolia.etherscan.io/)
  - [Blockscout](https://sepolia.blockscout.com/)
- **Aave Testnet Faucet**: [app.aave.com/faucet/](https://app.aave.com/faucet/)[](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses)
- **Remix IDE**: [remix.ethereum.org](https://remix.ethereum.org/)

---

# UniswapV3LiquidityTest Contract README

## Overview

The `UniswapV3LiquidityTest` contract is a Solidity test contract written for the Foundry framework to test the `UniswapV3Liquidity` contract. It verifies the functionality of:

- Minting a new liquidity position.
- Collecting fees from a position.
- Increasing liquidity in an existing position.
- Decreasing liquidity from a position.

This test contract uses Foundry’s testing tools (`forge-std`) and simulates interactions on a mainnet-forked environment, impersonating a DAI whale to obtain test tokens.

## Purpose

The test contract ensures the `UniswapV3Liquidity` contract works correctly before deployment on a testnet (e.g., Sepolia) or mainnet. It automates testing to catch bugs, verify token transfers, and confirm Uniswap V3 interactions.

## Real-World Use Case

### Why Use This Test Contract?

In DeFi development, testing is critical to ensure smart contracts handle assets securely and perform as expected. This test contract:

- **Validates functionality**: Confirms the `UniswapV3Liquidity` contract correctly interacts with Uniswap V3’s `NonfungiblePositionManager`.
- **Saves costs**: Testing on a mainnet fork or Sepolia avoids real ETH costs.
- **Automates verification**: Uses Foundry’s testing framework to run repeatable, automated tests, reducing manual errors.
- **Simulates real conditions**: Impersonates a whale account to test with realistic token amounts.

### How It’s Used

- **Developers**: Run tests locally or on a testnet to verify contract logic before deploying to production.
- **Auditors**: Use the test suite to review the contract’s behavior and ensure it handles edge cases.
- **DeFi projects**: Integrate these tests into a CI/CD pipeline to automate quality assurance for liquidity management contracts.

## Prerequisites

- **Foundry**: Install Foundry ([foundry.paradigm.xyz](https://foundry.paradigm.xyz/)).
- **Sepolia RPC**: Use a provider like [Alchemy](https://www.alchemy.com/) or [Infura](https://www.infura.io/).
- **Test Tokens**: Access to DAI and WETH on a mainnet fork or Sepolia.
- **Git**: For cloning and managing the repository.
- **Code Editor**: VS Code or any editor with Solidity support.

## Token Addresses for Sepolia

The test contract uses mainnet addresses for DAI (`0x6B175474...`) and WETH (`0xC02aaA39...`). For Sepolia testing, update to:

- **DAI Address**: `0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6`  
  - Source: [Ethereum Stack Exchange](https://ethereum.stackexchange.com/questions/159838/how-to-get-dai-tokens-on-metamask-for-sepolia-test-network)[](https://ethereum.stackexchange.com/questions/167704/how-to-get-dai-tokens-on-metamask-for-sepolia-test-network)
- **WETH Address**: `0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9`  
  - Source: [Reddit r/ethdev](https://www.reddit.com/r/ethdev/comments/1e5a3ck/how_can_i_get_the_official_weth_which_is_different/)[](https://www.reddit.com/r/ethdev/comments/1e58upm/how_can_i_get_the_official_weth_which_is/)
- **NonfungiblePositionManager**: `0xC36442b4a4522E871399CD717aBDD847Ab11FE88`

## Setup Foundry Project

1. **Install Foundry**:

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

   - Source: [Foundry Book](https://book.getfoundry.sh/getting-started/installation)

2. **Create a New Project**:

   ```bash
   forge init uniswap-v3-liquidity-test
   cd uniswap-v3-liquidity-test
   ```

3. **Organize Files**:
   - Place the `UniswapV3Liquidity.sol` contract in `src/defi/uniswap-v3-liquidity/UniswapV3Liquidity.sol`.
   - Place the `UniswapV3LiquidityTest.sol` contract in `test/UniswapV3LiquidityTest.t.sol`.

4. **Install Dependencies**:
   - Add Uniswap V3 interfaces:

     ```bash
     forge install Uniswap/v3-core --no-commit
     forge install Uniswap/v3-periphery --no-commit
     ```

   - Update `foundry.toml` to include remappings:

     ```toml
     [profile.default]
     src = 'src'
     out = 'out'
     libs = ['lib']
     remappings = [
       "v3-core/=lib/v3-core",
       "v3-periphery/=lib/v3-periphery"
     ]
     ```

5. **Configure Sepolia**:
   - Create a `.env` file:

     ```bash
     touch .env
     ```

     Add:

     ```
     SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/<YOUR_INFURA_KEY>
     PRIVATE_KEY=<YOUR_PRIVATE_KEY>
     ```

   - Load environment variables:

     ```bash
     source .env
     ```

## Deploy and Test with Foundry

### Step 1: Compile Contracts

```bash
forge build
```

- Ensures both contracts compile without errors.

### Step 2: Test on Mainnet Fork

1. Start a mainnet fork:

   ```bash
   anvil --fork-url https://mainnet.infura.io/v3/<YOUR_INFURA_KEY>
   ```

2. Run tests:

   ```bash
   forge test --fork-url http://localhost:8545
   ```

   - Tests use the DAI whale (`0xe81D6f...`) to simulate token transfers.

### Step 3: Deploy to Sepolia

1. Update `UniswapV3Liquidity.sol` with Sepolia DAI/WETH addresses (see above).
2. Deploy the contract:

   ```bash
   forge create src/defi/uniswap-v3-liquidity/UniswapV3Liquidity.sol:UniswapV3Liquidity \
     --rpc-url $SEPOLIA_RPC_URL \
     --private-key $PRIVATE_KEY
   ```

   - Note the deployed contract address.

### Step 4: Test on Sepolia

1. Update the test contract to use the deployed address:

   ```solidity
   UniswapV3Liquidity private uni = UniswapV3Liquidity(<DEPLOYED_ADDRESS>);
   ```

2. Get test DAI/WETH from:
   - [Aave Sepolia Faucet](https://app.aave.com/faucet/)[](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses)
   - [Uniswap V3 Sepolia](https://app.uniswap.org/) (swap ETH for tokens)
3. Run tests:

   ```bash
   forge test --fork-url $SEPOLIA_RPC_URL
   ```

### Step 5: Verify Deployment

- Verify on [Sepolia Etherscan](https://sepolia.etherscan.io/):

  ```bash
  forge verify-contract <DEPLOYED_ADDRESS> \
    src/defi/uniswap-v3-liquidity/UniswapV3Liquidity.sol:UniswapV3Liquidity \
    --chain-id 11155111 \
    --etherscan-api-key <YOUR_ETHERSCAN_KEY>
  ```

### Step 6: Debug Issues

- **Fork Errors**: Ensure the RPC URL is valid.
- **Token Shortage**: Use faucets to get DAI/WETH.
- **Test Failures**: Check console logs (`console2.log`) for details.

## Test Cases

The `testLiquidity` function tests:

1. **Minting**: Creates a position with 10 DAI and 1 WETH.
2. **Fee Collection**: Collects fees (may be zero on Sepolia).
3. **Increasing Liquidity**: Adds 5 DAI and 0.5 WETH.
4. **Decreasing Liquidity**: Removes all liquidity.

## Additional Resources

- **Foundry Documentation**: [book.getfoundry.sh](https://book.getfoundry.sh/)
- **Uniswap V3 Documentation**: [docs.uniswap.org](https://docs.uniswap.org/)
- **Sepolia Faucets**:
  - [Alchemy Sepolia Faucet](https://www.alchemy.com/faucets/ethereum-sepolia)[](https://www.alchemy.com/faucets/ethereum-sepolia)
  - [QuickNode Sepolia Faucet](https://faucet.quicknode.com/drip)[](https://cryptnox.com/how-to-get-test-coins-from-sepolia-network/)
- **Aave Testnet Faucet**: [app.aave.com/faucet/](https://app.aave.com/faucet/)[](https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses)
- **Sepolia Block Explorers**:
  - [Sepolia Etherscan](https://sepolia.etherscan.io/)
  - [Blockscout](https://sepolia.blockscout.com/)


