// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20BasicToken1 {
    string public name = "Basic Token";
    string public symbol = "BTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    bool public paused = false;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event Unpaused(address account);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Token transfers are paused");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // Transfer tokens
    function transfer(address to, uint256 value) public whenNotPaused returns (bool success) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Approve spender
    function approve(address spender, uint256 value) public whenNotPaused returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Transfer from allowance
    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool success) {
        require(from != address(0), "Invalid from address");
        require(to != address(0), "Invalid to address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    // Mint new tokens (only owner)
    function mint(address to, uint256 value) public onlyOwner returns (bool success) {
        require(to != address(0), "Invalid address");
        totalSupply += value;
        balanceOf[to] += value;
        emit Mint(to, value);
        emit Transfer(address(0), to, value);
        return true;
    }

    // Burn tokens
    function burn(uint256 value) public whenNotPaused returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
        return true;
    }

    // Increase allowance
    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool success) {
        allowance[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    // Decrease allowance
    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool success) {
        require(allowance[msg.sender][spender] >= subtractedValue, "Allowance too low");
        allowance[msg.sender][spender] -= subtractedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    // Transfer ownership
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Pause the contract
    function pause() public onlyOwner {
        require(!paused, "Already paused");
        paused = true;
        emit Paused(msg.sender);
    }

    // Unpause the contract
    function unpause() public onlyOwner {
        require(paused, "Already unpaused");
        paused = false;
        emit Unpaused(msg.sender);
    }
}