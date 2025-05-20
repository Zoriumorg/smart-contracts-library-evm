// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract MultiTokenStaking {
    address public owner;
    
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 level;
        address tokenAddress;
    }

    // Mapping: user => token => array of stakes
    mapping(address => mapping(address => Stake[])) public stakes;
    // Mapping: token => level => reward rate (in percentage, scaled by 100)
    mapping(address => mapping(uint256 => uint256)) public rewardRates;
    // Mapping: token => minimum stake amounts for each level
    mapping(address => mapping(uint256 => uint256)) public levelMinAmounts;
    // Supported tokens
    mapping(address => bool) public supportedTokens;

    // Constants for levels
    uint256 constant LEVEL_ONE = 1;
    uint256 constant LEVEL_TWO = 2;
    uint256 constant LEVEL_THREE = 3;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Add a supported token with minimum amounts and reward rates for each level
    function addSupportedToken(
        address tokenAddress,
        uint256 levelOneMin,
        uint256 levelTwoMin,
        uint256 levelThreeMin,
        uint256 rateOne,
        uint256 rateTwo,
        uint256 rateThree
    ) external onlyOwner {
        require(tokenAddress != address(0), "Invalid token address");
        require(!supportedTokens[tokenAddress], "Token already supported");
        require(levelOneMin < levelTwoMin && levelTwoMin < levelThreeMin, "Invalid level amounts");
        require(rateOne > 0 && rateTwo > 0 && rateThree > 0, "Invalid reward rates");

        supportedTokens[tokenAddress] = true;
        levelMinAmounts[tokenAddress][LEVEL_ONE] = levelOneMin;
        levelMinAmounts[tokenAddress][LEVEL_TWO] = levelTwoMin;
        levelMinAmounts[tokenAddress][LEVEL_THREE] = levelThreeMin;
        rewardRates[tokenAddress][LEVEL_ONE] = rateOne;
        rewardRates[tokenAddress][LEVEL_TWO] = rateTwo;
        rewardRates[tokenAddress][LEVEL_THREE] = rateThree;
    }

    // Stake tokens
    function stake(address tokenAddress, uint256 amount) external {
        require(supportedTokens[tokenAddress], "Token not supported");
        require(amount > 0, "Amount must be greater than 0");
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount), "Transfer failed");

        uint256 level = getStakeLevel(tokenAddress, amount);

        stakes[msg.sender][tokenAddress].push(Stake({
            amount: amount,
            startTime: block.timestamp,
            level: level,
            tokenAddress: tokenAddress
        }));
    }

    // Get staking level based on amount
    function getStakeLevel(address tokenAddress, uint256 amount) internal view returns (uint256) {
        if (amount >= levelMinAmounts[tokenAddress][LEVEL_THREE]) {
            return LEVEL_THREE;
        } else if (amount >= levelMinAmounts[tokenAddress][LEVEL_TWO]) {
            return LEVEL_TWO;
        } else if (amount >= levelMinAmounts[tokenAddress][LEVEL_ONE]) {
            return LEVEL_ONE;
        }
        return 0;
    }

    // Calculate total rewards for a user's stakes for a specific token
    function calculateReward(address staker, address tokenAddress) public view returns (uint256) {
        require(supportedTokens[tokenAddress], "Token not supported");
        Stake[] memory userStakes = stakes[staker][tokenAddress];
        require(userStakes.length > 0, "No active stakes");

        uint256 totalReward = 0;
        for (uint256 i = 0; i < userStakes.length; i++) {
            uint256 reward = calculateSingleStakeReward(userStakes[i], tokenAddress);
            totalReward += reward;
        }
        return totalReward;
    }

    // Calculate reward for a single stake
    function calculateSingleStakeReward(Stake memory stakeInfo, address tokenAddress) internal view returns (uint256) {
        uint256 stakingDuration = block.timestamp - stakeInfo.startTime;
        uint256 rate = rewardRates[tokenAddress][stakeInfo.level];
        return (stakeInfo.amount * rate * stakingDuration) / (365 days * 100);
    }

    // Unstake a specific stake by index for a specific token
    function unstake(address tokenAddress, uint256 index) external {
        require(supportedTokens[tokenAddress], "Token not supported");
        require(index < stakes[msg.sender][tokenAddress].length, "Invalid index");

        Stake memory stakeInfo = stakes[msg.sender][tokenAddress][index];
        uint256 reward = calculateSingleStakeReward(stakeInfo, tokenAddress);
        uint256 totalAmount = stakeInfo.amount + reward;

        // Remove stake by swapping with the last element and popping
        stakes[msg.sender][tokenAddress][index] = stakes[msg.sender][tokenAddress][stakes[msg.sender][tokenAddress].length - 1];
        stakes[msg.sender][tokenAddress].pop();

        // Transfer staked amount + reward back to user
        require(IERC20(tokenAddress).transfer(msg.sender, totalAmount), "Transfer failed");
    }

    // Unstake all stakes for a specific token
    function unstakeAll(address tokenAddress) external {
        require(supportedTokens[tokenAddress], "Token not supported");
        Stake[] memory userStakes = stakes[msg.sender][tokenAddress];
        require(userStakes.length > 0, "No active stakes");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < userStakes.length; i++) {
            uint256 reward = calculateSingleStakeReward(userStakes[i], tokenAddress);
            totalAmount += userStakes[i].amount + reward;
        }

        // Clear all stakes for the token
        delete stakes[msg.sender][tokenAddress];

        // Transfer total amount back to user
        require(IERC20(tokenAddress).transfer(msg.sender, totalAmount), "Transfer failed");
    }

    // Check contract's token balance
    function getContractBalance(address tokenAddress) external view returns (uint256) {
        require(supportedTokens[tokenAddress], "Token not supported");
        return IERC20(tokenAddress).balanceOf(address(this));
    }
}