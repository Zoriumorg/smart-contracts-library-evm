// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.9.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.3/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts@4.9.3/access/Ownable.sol";

contract ERC20WithSnapshot is ERC20, ERC20Snapshot, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) Ownable() {
        _mint(msg.sender, initialSupply);
    }

    // Function to create a snapshot (only owner)
    function snapshot() public onlyOwner returns (uint256) {
        return _snapshot();
    }

    // Override _beforeTokenTransfer for ERC20 and ERC20Snapshot
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Snapshot) {
        super._beforeTokenTransfer(from, to, amount);
    }

    // Optional: Burn function
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}