// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContractV1 is ERC20, Ownable {
    struct Stake {
        uint256 amount;
        uint256 startTime;
    }
    
    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 100; // wei per second per token
    uint256 public constant MIN_STAKE_PERIOD = 1 days;
    
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);

    constructor() ERC20("StakeToken", "STK") Ownable(msg.sender) {
        _mint(msg.sender, 10000 * 10**decimals());
        _mint(address(this), 10000 * 10**decimals()); // Reward pool
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(transferFrom(msg.sender, address(this), amount), "Transfer failed");

        if (stakes[msg.sender].amount > 0) {
            uint256 reward = calculateReward(msg.sender);
            require(transfer(msg.sender, reward), "Reward transfer failed");
        }

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].startTime = block.timestamp;
        emit Staked(msg.sender, amount);
    }

    function unstake() public {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No stake found");
        require(block.timestamp >= userStake.startTime + MIN_STAKE_PERIOD, "Lockup period active");

        uint256 reward = calculateReward(msg.sender);
        uint256 totalAmount = userStake.amount;
        delete stakes[msg.sender];

        require(transfer(msg.sender, totalAmount + reward), "Transfer failed");
        emit Unstaked(msg.sender, totalAmount, reward);
    }

    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.amount == 0) return 0;
        uint256 duration = block.timestamp - userStake.startTime;
        return (userStake.amount * duration * rewardRate) / 1e18;
    }

    function setRewardRate(uint256 _rate) public onlyOwner {
        require(_rate > 0, "Rate must be positive");
        rewardRate = _rate;
    }
}