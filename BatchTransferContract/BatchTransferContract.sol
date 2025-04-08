// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BatchTransferContract {
    // Event to log successful batch transfers
    event BatchTransfer(address indexed sender, address[] recipients, uint256[] amounts);

    // Function to perform batch transfer of ERC20 tokens
    function batchTransfer(
        address tokenAddress,
        address[] calldata recipients,
        uint256[] calldata amounts
    ) external {
        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length");
        require(recipients.length > 0, "At least one recipient is required");

        IERC20 token = IERC20(tokenAddress);
        uint256 totalAmount = 0;

        // Calculate total amount and check sender's balance and allowance
        for (uint256 i = 0; i < amounts.length; i++) {
            require(amounts[i] > 0, "Amount must be greater than zero");
            totalAmount += amounts[i];
        }

        // Ensure sender has enough tokens and has approved this contract
        require(token.balanceOf(msg.sender) >= totalAmount, "Insufficient balance");
        require(
            token.allowance(msg.sender, address(this)) >= totalAmount,
            "Contract not approved to spend tokens"
        );

        // Perform the batch transfers
        for (uint256 i = 0; i < recipients.length; i++) {
            require(recipients[i] != address(0), "Cannot send to zero address");
            require(token.transferFrom(msg.sender, recipients[i], amounts[i]), "Transfer failed");
        }

        // Emit event for successful batch transfer
        emit BatchTransfer(msg.sender, recipients, amounts);
    }
}