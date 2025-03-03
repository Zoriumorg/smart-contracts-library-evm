# SimpleStorage Smart Contract Project

This is a beginner-friendly project built with [Hardhat](https://hardhat.org/), a tool for creating and deploying smart contracts on the blockchain. It includes a simple smart contract called `SimpleStorage`, a deployment script, and a setup to put it on the Sepolia test network.

## What is the SimpleStorage Smart Contract?

Think of a **smart contract** as a tiny program that lives on the blockchain (like a secure, digital notebook). The `SimpleStorage` contract is super basic and perfect for learning. Here’s what it does:

- **Stores a Number**: It has a "box" called `storedNumber` where you can save a number (like 5, 42, or 100). Once it’s saved, it stays on the blockchain forever unless you change it.
- **Change the Number**: You can use a function called `setNumber` to put a new number in the box. For example, change 5 to 10.
- **Check the Number**: You can use `getNumber` to peek inside and see what’s stored.

It’s like a digital sticky note that anyone can read or update (if they have some test ETH and the right tools)!

## Project Structure

- `contracts/`: Where the `SimpleStorage.sol` smart contract lives.
- `ignition/modules/`: Contains `SimpleStorage.ts`, the script to deploy the contract.
- `test/`: For writing tests (not used yet, but you can add some later!).
- `hardhat.config.ts`: The settings file for Hardhat, like which network to use.

## Getting Started

### Prerequisites
- **Node.js**: Install it from [nodejs.org](https://nodejs.org/) (v16 or later).
- **MetaMask**: A browser wallet. Set it up with Sepolia testnet and get test ETH from [Sepolia Faucet](https://sepoliafaucet.com/).
- **Infura**: Sign up at [infura.io](https://infura.io/) for a project ID to connect to Sepolia.

### Setup
1. **Clone the Repo** (if you’re sharing it):
   ```bash
   git clone <your-repo-url>
   cd simple-storage-ts
```
What is the SimpleStorage Smart Contract?
Imagine a smart contract as a tiny, self-running program that lives on the blockchain (like Ethereum or Sepolia, the test network we’re using). It’s like a digital box where you can store information or rules, and anyone can interact with it using a wallet like MetaMask.

The SimpleStorage contract is one of the simplest examples of a smart contract. Here’s what it does:

Stores a Number:
It has a single "box" (called storedNumber) where you can put a number (like 5, 42, or 100).
This number stays on the blockchain forever unless you change it.
Lets You Change the Number:
You can use a function called setNumber to put a new number in the box.
For example, if the box has 5, you can change it to 10.
Lets You Check the Number:
You can use a function called getNumber to look inside the box and see what number is stored.
That’s it! It’s like a tiny digital notepad on the blockchain where you can write a number and read it back anytime.

npx hardhat ignition deploy ignition/modules/SimpleStorage.ts --network sepolia