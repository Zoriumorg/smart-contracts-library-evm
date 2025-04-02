# SimpleLendingContract

A basic Solidity smart contract for lending Ether with a repayment deadline.

## Overview

The `SimpleLendingContract` allows:
- A lender to fund a loan with Ether
- A borrower to repay the loan before a specified deadline
- The lender to withdraw funds after repayment

### Features
- Tracks loan status (funded, repaid)
- Enforces access control (lender-only and borrower-only functions)
- Includes deadline for repayment
- Emits events for key actions
- Provides view functions for balance and time remaining

### Contract Details
- **Solidity Version**: ^0.8.0
- **License**: MIT
- **Deployment**: Requires borrower address and deadline (in days)

## Prerequisites
- Remix IDE (https://remix.ethereum.org/)
- Basic understanding of Ethereum and Solidity
- Web3-enabled browser (optional for real network deployment)

## How to Test in Remix

### Step-by-Step Instructions

1. **Setup Environment**
   - Open Remix IDE
   - Create a new file named `SimpleLendingContract.sol`
   - Copy and paste the contract code
   - Compile the contract:
     - Go to "Solidity Compiler" tab
     - Select compiler version ^0.8.0
     - Click "Compile SimpleLendingContract.sol"

2. **Deploy the Contract**
   - Go to "Deploy & Run Transactions" tab
   - Select "JavaScript VM (London)" as the environment (for testing)
   - In the constructor parameters:
     - Enter a borrower address (e.g., second account from Remix's account list)
     - Enter days until deadline (e.g., `7` for 7 days)
   - Select an account as the lender (e.g., first account)
   - Click "Deploy"

3. **Interact with the Contract**
   - After deployment, the contract instance appears under "Deployed Contracts"
   - Use the following steps to test core functionality:

#### Test Core Functionality
   a. **Fund the Loan**
   - Select lender account
   - In the `fundLoan` function:
     - Enter a value (e.g., `1` ETH = `1000000000000000000` wei) in the "Value" field
     - Click `fundLoan`
   - Check:
     - `isFunded` returns `true`
     - `amount` matches the sent value
     - `getContractBalance` shows the funded amount
     - "LoanFunded" event in transaction logs

   b. **Repay the Loan**
   - Switch to borrower account
   - In the `repayLoan` function:
     - Enter the exact amount (or more) in the "Value" field (e.g., `1000000000000000000` wei)
     - Click `repayLoan`
   - Check:
     - `isRepaid` returns `true`
     - "LoanRepaid" event in logs
     - `getContractBalance` increases by repayment amount

   c. **Withdraw Funds**
   - Switch back to lender account
   - Click `withdrawFunds`
   - Check:
     - `getContractBalance` returns `0`
     - "FundsWithdrawn" event in logs
     - Lender's balance increases

4. **Verify Additional Functions**
   - Call `getTimeRemaining` to see seconds until deadline
   - Call `getContractBalance` at various stages

## Test Cases

Below are specific test cases to verify contract behavior:

### Positive Test Cases
1. **Successful Loan Funding**
   - Deploy with borrower address and 7 days deadline
   - Fund with 1 ETH
   - Expected: `isFunded = true`, `amount = 1 ETH`, event emitted

2. **Successful Repayment**
   - Fund loan with 1 ETH
   - Repay with 1 ETH before deadline
   - Expected: `isRepaid = true`, event emitted, contract balance increases

3. **Successful Withdrawal**
   - Complete funding and repayment
   - Call `withdrawFunds`
   - Expected: Contract balance = 0, event emitted, lender balance increases

4. **Repayment with Extra Amount**
   - Fund with 1 ETH
   - Repay with 1.5 ETH
   - Expected: Repayment succeeds, excess stays in contract

### Negative Test Cases
5. **Funding by Non-Lender**
   - Deploy as lender
   - Switch to different account
   - Try `fundLoan`
   - Expected: Reverts with "Only lender can call this function"

6. **Double Funding**
   - Fund with 1 ETH
   - Try funding again with 1 ETH
   - Expected: Reverts with "Loan already funded"

7. **Repayment Before Funding**
   - Deploy contract
   - Try `repayLoan` without funding
   - Expected: Reverts with "Loan not yet funded"

8. **Repayment by Non-Borrower**
   - Fund loan
   - Switch to lender account
   - Try `repayLoan`
   - Expected: Reverts with "Only borrower can call this function"

9. **Insufficient Repayment**
   - Fund with 1 ETH
   - Try repaying with 0.5 ETH
   - Expected: Reverts with "Insufficient repayment amount"

10. **Repayment After Deadline**
    - Fund loan
    - Use Remix VM to advance time past deadline (modify block timestamp)
    - Try `repayLoan`
    - Expected: Reverts with "Repayment deadline passed"

11. **Withdrawal Before Repayment**
    - Fund loan
    - Try `withdrawFunds` before repayment
    - Expected: Reverts with "Loan not yet repaid"

## Notes
- **Units**: All amounts are in wei (1 ETH = 10^18 wei)
- **Time**: Deadline is calculated in seconds (1 day = 86400 seconds)
- **Security**: This is a basic contract; production use requires additional features (e.g., interest, emergency stop)
- **Testing**: Use Remix's JavaScript VM for isolated testing; adjust block timestamp for deadline tests

## Limitations
- No interest calculation
- No penalty for late repayment
- Simple access control
- No refund mechanism if deadline passes

## Future Improvements
- Add interest rates
- Implement late payment penalties
- Add emergency withdrawal for lender if deadline passes
- Include pause functionality

