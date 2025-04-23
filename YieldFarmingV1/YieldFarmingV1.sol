// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YieldFarmingV1 is Ownable {
    IERC20 public stakingToken; // Token to be staked
    IERC20 public rewardToken; // Token to be rewarded
    uint256 public rewardRate = 10; // Reward tokens per block (scaled by 1e18 for precision)
    uint256 public lastUpdateBlock; // Last block when rewards were updated
    uint256 public rewardPerTokenStored; // Accumulated reward per token
    mapping(address => uint256) public userRewardPerTokenPaid; // Reward per token paid to user
    mapping(address => uint256) public rewards; // Pending rewards for user
    mapping(address => uint256) public balances; // Staked balance per user
    uint256 public totalSupply; // Total staked tokens

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
        lastUpdateBlock = block.number;
    }

    // Update reward for a specific user
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateBlock = block.number;
        rewards[account] = earned(account);
        userRewardPerTokenPaid[account] = rewardPerTokenStored;
        _;
    }

    // Calculate reward per token
    function rewardPerToken() public view returns (uint256) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            (((block.number - lastUpdateBlock) * rewardRate * 1e18) / totalSupply);
    }

    // Calculate earned rewards for a user
    function earned(address account) public view returns (uint256) {
        return
            ((balances[account] *
                (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18) +
            rewards[account];
    }

    // Stake tokens
    function stake(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0");
        totalSupply += amount;
        balances[msg.sender] += amount;
        stakingToken.transferFrom(msg.sender, address(this), amount);
    }

    // Withdraw staked tokens
    function withdraw(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        totalSupply -= amount;
        balances[msg.sender] -= amount;
        stakingToken.transfer(msg.sender, amount);
    }

    // Claim rewards
    function getReward() external updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        rewards[msg.sender] = 0;
        rewardToken.transfer(msg.sender, reward);
    }

    // Fund the contract with reward tokens (only owner)
    function fundRewards(uint256 amount) external onlyOwner {
        require(amount > 0, "Cannot fund 0");
        rewardToken.transferFrom(msg.sender, address(this), amount);
    }
}