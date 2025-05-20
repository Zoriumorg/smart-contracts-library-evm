
# Smart Contracts Library (EVM) - Zoriumorg

Welcome to the **Smart Contracts Library (EVM)** repository by Zoriumorg! This open-source collection of Solidity smart contracts is designed for the Ethereum Virtual Machine (EVM). Whether you're a beginner exploring blockchain development or an experienced developer building decentralized applications (dApps), this repository offers a wide range of reusable, well-documented contracts to study, deploy, or integrate into your projects.

Our mission is to provide a robust and accessible library of smart contracts that adhere to Solidity best practices, fostering innovation in decentralized ecosystems. Contributions, suggestions, and feedback are warmly welcomed!

## Repository Structure

The repository is organized into folders, each containing a specific smart contract or dApp example. Below is the complete list of contracts, grouped by category for ease of navigation:

### Decentralized Applications (dApps)
- **`hello-world-dapp`**  
  A beginner-friendly dApp to introduce Solidity and EVM development basics.  
- **`multi-storage-dapp`**  
  A dApp for storing and managing multiple data types or records on the blockchain.  
- **`reown-wallet-connect`**  
  A contract enabling wallet connectivity (e.g., WalletConnect) for secure user interactions with dApps.  
- **`simple-storage-dapp`**  
  A basic dApp demonstrating data storage and retrieval using a smart contract.  
- **`simple-storage-number`**  
  A minimal contract for storing and retrieving a single numerical value on-chain.  

### Token Standards
- **`ERC20BasicToken`**  
  A standard ERC20 token with core functionalities like transfer, approve, and balance tracking.  
- **`ERC20WithAllowance`**  
  An ERC20 token with enhanced allowance mechanisms for delegated spending.  
- **`ERC20WithPermit`**  
  An ERC20 token supporting gasless approvals via EIP-2612 permit signatures.  
- **`ERC20WithSnapshot`**  
  An ERC20 token with snapshot functionality for tracking balances at specific points in time.  
- **`ERC721NFTContract`**  
  An ERC721 non-fungible token (NFT) contract for creating unique digital assets.  
- **`ERC1155Contract`**  
  An ERC1155 multi-token standard contract supporting both fungible and non-fungible tokens.  
- **`ERC1155WithRoyalties`**  
  An ERC1155 contract with royalty support for creators (e.g., EIP-2981).  
- **`ERC777Token`**  
  An ERC777 token with advanced features like operator hooks and improved user interactions.  

### Financial Contracts
- **`AMMPriceCalculator`**  
  A contract for calculating prices in Automated Market Makers (AMMs).  
- **`AmmContract`**  
  A basic Automated Market Maker (AMM) contract for decentralized token swaps.  
- **`CrowdsaleContract`**  
  A contract for conducting fixed-rate token sales, enabling users to purchase ERC20 tokens with ETH.  
- **`DecentralizedExchangeV1`**  
  A decentralized exchange (DEX) contract for token trading with liquidity pools.  
- **`FlashLoanMock`**  
  A mock contract simulating flash loans for testing and development purposes.  
- **`LendingPoolV1`**  
  A lending pool contract for borrowing and lending assets on-chain.  
- **`LiquidityPoolV1`**  
  A liquidity pool contract for providing and managing liquidity in DeFi protocols.  
- **`SimpleLendingContract`**  
  A basic lending contract for straightforward borrowing and lending operations.  
- **`StackingV1Contract`**  
  A staking contract allowing users to lock tokens and earn rewards.  
- **`MultiTokenStacking`**  
  A staking contract supporting multiple token types for flexible reward mechanisms.  
- **`StakingWithRewardsContract`**  
  A staking contract with customizable reward distribution for participants.  
- **`SyntheticAssetTokenContract`**  
  A contract for creating synthetic assets tied to real-world or on-chain values.  
- **`TokenSwapContract`**  
  A contract for direct token-to-token swaps with minimal dependencies.  
- **`TokenVestingContract`**  
  A vesting contract for gradual token release to beneficiaries over time.  
- **`YieldFarmingV1`**  
  A yield farming contract enabling users to earn rewards by providing liquidity.  
- **`CharityDonationContract`**  
  A transparent contract for managing and distributing charitable donations.  
- **`PayableContract`**  
  A simple contract demonstrating payable functions to receive Ether.  

### NFT and Marketplace Contracts
- **`NFTFractionalizer`**  
  A contract for fractionalizing NFTs, allowing shared ownership of unique assets.  
- **`NFTMarketplaceV1`**  
  A decentralized marketplace for buying, selling, and trading NFTs.  
- **`RentableNFTContract`**  
  A contract enabling NFT rentals, allowing temporary use of digital assets.  

### Governance and Security
- **`AccessControlContract`**  
  A contract implementing role-based access control for secure permission management.  
- **`EscrowContract`**  
  A secure escrow contract to hold funds until predefined conditions are met.  
- **`GovernanceProposalContract`**  
  A contract for proposing and managing governance proposals in a DAO.  
- **`GovernanceDAOContract`**  
  A decentralized autonomous organization (DAO) contract for community governance.  
- **`MultiSigWallet`**  
  A multi-signature wallet requiring multiple approvals for enhanced transaction security.  
- **`TimeLockContract`**  
  A contract that locks funds or actions for a specified duration before execution.  
- **`TimeLockDAOContract`**  
  A timelock contract tailored for DAO governance, delaying execution of proposals.  
- **`VotingContract`**  
  A contract for on-chain voting, enabling transparent vote casting and tallying.  
- **`GaslessVotingContract`**  
  A voting contract optimized for gasless operations (e.g., via meta-transactions).  

### Utility Contracts
- **`BasicOracleConsumer`**  
  A contract consuming external data feeds via an oracle (e.g., Chainlink).  
- **`ChainlinkPriceFeed`**  
  A contract integrating Chainlink’s price feeds for accurate on-chain pricing.  
- **`EventLoggerContract`**  
  A utility contract for logging and tracking on-chain events.  
- **`FaucetContract`**  
  A faucet contract for distributing test tokens or Ether on testnets.  
- **`GasOptimizedCounter`**  
  A gas-efficient counter contract for minimal-cost on-chain counting.  
- **`AdvancedGasOptimizedCounter`**  
  An enhanced version of the gas-optimized counter with additional features.  
- **`RandomNumberContract`**  
  A contract for generating secure random numbers on-chain (e.g., via oracles).  
- **`BatchTransferContract`**  
  A contract for batch token or Ether transfers to multiple recipients in a single transaction.  

### Advanced Features
- **`AuctionContract`**  
  A contract for conducting on-chain auctions (e.g., English auctions).  
- **`DutchAuctionContract`**  
  A contract for Dutch (reverse) auctions, where the price decreases over time.  
- **`UpgradeableProxyContract`**  
  A proxy contract enabling upgrades to logic contracts while preserving state.  

**Note:** The `.DS_Store` file is a macOS system artifact and not part of the functional contracts.

---
## Getting Started with Remix IDE

All contracts in this repository have been deployed and tested using **Remix IDE**. Below are step-by-step instructions for compiling, deploying, and testing any contract in this library.

### Prerequisites
- A web browser with [Remix IDE](https://remix.ethereum.org/) access.
- A wallet like [MetaMask](https://metamask.io/) configured with an Ethereum testnet (e.g., Sepolia, Goerli) or mainnet.
- Testnet Ether (obtain from faucets like [Sepolia Faucet](https://sepoliafaucet.com/)).
- Basic knowledge of Solidity and Ethereum development.

### Step-by-Step Instructions for Each Contract
1. **Open Remix IDE**:
   - Navigate to [Remix IDE](https://remix.ethereum.org/).
   - Ensure the Solidity compiler is enabled (default in Remix).

2. **Load the Contract**:
   - Clone this repository:
     ```bash
     git clone https://github.com/Zoriumorg/smart-contracts-library-evm.git
     ```
   - In Remix, go to the **File Explorer** tab.
   - Click the **Upload File** button and select the `.sol` file from the desired contract folder (e.g., `ERC20BasicToken/ERC20BasicToken.sol`).

3. **Compile the Contract**:
   - In the **Solidity Compiler** tab:
     - Select the appropriate Solidity version (check the contract’s comments for the required version, e.g., `^0.8.0`).
     - Click **Compile [ContractName].sol**.
     - Ensure no compilation errors appear.

4. **Deploy the Contract**:
   - Go to the **Deploy & Run Transactions** tab.
   - Select your environment:
     - **JavaScript VM** (for local testing).
     - **Injected Provider - MetaMask** (for testnet/mainnet deployment).
   - Connect MetaMask and ensure it’s set to the desired network (e.g., Sepolia).
   - If the contract requires constructor parameters (e.g., token name, supply for `ERC20BasicToken`), provide them in the input fields next to the **Deploy** button.
   - Click **Deploy** and confirm the transaction in MetaMask.


## Getting Started

### Prerequisites
To use or deploy these contracts, you’ll need:
- [Node.js](https://nodejs.org/) and [npm](https://www.npmjs.com/) for package management.
- A development framework like [Truffle](https://www.trufflesuite.com/) or [Hardhat](https://hardhat.org/).
- A wallet like [Metamask](https://metamask.io/) for interacting with Ethereum networks.
- Access to an Ethereum testnet (e.g., Sepolia, Goerli) or a local blockchain like [Ganache](https://www.trufflesuite.com/ganache).
- Optional: [Chainlink](https://chain.link/) for oracle-dependent contracts (e.g., `ChainlinkPriceFeed`, `RandomNumberContract`).

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Zoriumorg/smart-contracts-library-evm.git
   cd smart-contracts-library-evm
   ```
2. Navigate to the desired contract folder (e.g., `cd ERC20BasicToken`).
3. Install dependencies (if applicable):
   ```bash
   npm install
   ```
4. Configure your development environment (e.g., update `truffle-config.js` or `hardhat.config.js` with network details).
5. Compile and deploy the contract using your preferred framework. Example for Truffle:
   ```bash
   truffle compile
   truffle migrate --network sepolia
   ```

Refer to individual contract folders for specific deployment instructions or dependencies.

## Contributing

We welcome contributions from the blockchain community! To contribute:
1. Fork the repository.
2. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Add or improve a smart contract, ensuring it follows Solidity best practices.
4. Include tests (e.g., using Mocha/Chai in Hardhat or Truffle).
5. Update the README or add a sub-README in the relevant folder with details about your contribution.
6. Submit a pull request with a clear description of your changes.

### Contribution Guidelines
- Write clear, commented code adhering to [Solidity style guides](https://docs.soliditylang.org/en/latest/style-guide.html).
- Test contracts thoroughly for security and functionality.
- Avoid committing sensitive data (e.g., private keys, API keys).
- Ensure gas optimization where applicable, especially for utility contracts.

## Usage

Each contract folder contains a specific smart contract or dApp example. Explore the code, deploy to a testnet, or integrate into your projects. Check individual folders for sub-READMEs or deployment scripts with detailed instructions.

For example, to deploy the `ERC721NFTContract`:
1. Navigate to `ERC721NFTContract/`.
2. Configure your network in the deployment script.
3. Run:
   ```bash
   hardhat run scripts/deploy.js --network sepolia
   ```

## Security Considerations
- **Audits**: These contracts are provided as-is and may not be audited. Conduct thorough testing and audits before deploying to mainnet.
- **Gas Optimization**: Some contracts (e.g., `GasOptimizedCounter`) are optimized for gas efficiency, but always verify gas costs for your use case.
- **Oracles**: Contracts like `BasicOracleConsumer` and `ChainlinkPriceFeed` rely on external oracles; ensure you use trusted providers like Chainlink.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute the code, provided the original license is included.

## Contact

Have questions, ideas, or want to collaborate? Open a GitHub Issue, submit a pull request, or connect with the Zoriumorg community!

Happy coding, and let’s build the decentralized future together!

