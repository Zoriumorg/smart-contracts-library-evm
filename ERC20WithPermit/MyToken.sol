// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        // Mint initial supply to deployer for testing
        _mint(msg.sender, 1000000 * 10**decimals());
    }

    // Optional: Function to mint additional tokens for testing
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    // Optional: Function to get current nonce for an address
    function getNonce(address owner) external view returns (uint256) {
        return nonces(owner);
    }

    // // Optional: Function to get domain separator
    // function getDomainSeparator() external view returns (bytes32) {
    //     return DOMAIN_SEPARATOR();
    // }
}