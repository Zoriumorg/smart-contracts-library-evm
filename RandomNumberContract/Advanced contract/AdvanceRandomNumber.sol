// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract AdvancedRandomNumberContract is VRFConsumerBaseV2Plus {
    // Chainlink VRF Coordinator and parameters (Sepolia testnet)
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 keyHash = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint64 subscriptionId;
    uint32 callbackGasLimit = 100000; // Increased for flexibility
    uint16 requestConfirmations = 3;
    uint32 numWords = 1; // Default to 1, adjustable

    // Removed: address owner; (inherited from ConfirmedOwner)
    mapping(uint256 => address) public requestToSender; // Tracks requester
    mapping(uint256 => uint256[]) public requestToRandomNumbers; // Stores multiple random numbers
    mapping(address => uint256) public lastRequestId; // Tracks last request per user

    event RandomRequested(uint256 indexed requestId, address indexed requester);
    event RandomFulfilled(uint256 indexed requestId, uint256[] randomNumbers);

    constructor(uint64 _subscriptionId) VRFConsumerBaseV2Plus(vrfCoordinator) {
        subscriptionId = _subscriptionId;
    }

    // Request random numbers with custom range and count
    function requestRandomNumbers(uint32 _numWords, uint256 min, uint256 max) 
        external payable returns (uint256) {
        require(msg.value >= 0.001 ether, "Pay 0.001 ETH to request");
        require(_numWords > 0 && _numWords <= 10, "Request between 1 and 10 numbers");
        require(max > min, "Max must be greater than min");

        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: _numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );

        requestToSender[requestId] = msg.sender;
        lastRequestId[msg.sender] = requestId;
        emit RandomRequested(requestId, msg.sender);
        return requestId;
    }

    // Callback function for Chainlink VRF (fixed to use calldata)
    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) 
        internal override {
        uint256[] memory adjustedNumbers = new uint256[](randomWords.length);
        for (uint256 i = 0; i < randomWords.length; i++) {
            // Example adjustment: map to a range (e.g., 1 to 100)
            adjustedNumbers[i] = (randomWords[i] % 100) + 1;
        }
        requestToRandomNumbers[requestId] = adjustedNumbers;
        emit RandomFulfilled(requestId, adjustedNumbers);
    }

    // Get random numbers for a request
    function getRandomNumbers(uint256 requestId) 
        external view returns (uint256[] memory) {
        require(requestToSender[requestId] == msg.sender || msg.sender == owner(), "Not authorized");
        require(requestToRandomNumbers[requestId].length > 0, "Request not fulfilled yet");
        return requestToRandomNumbers[requestId];
    }

    // Get last request result for a user
    function getLastRandomNumbers(address user) 
        external view returns (uint256[] memory) {
        uint256 requestId = lastRequestId[user];
        require(requestId != 0, "No requests made by this user");
        require(requestToRandomNumbers[requestId].length > 0, "Request not fulfilled yet");
        return requestToRandomNumbers[requestId];
    }

    // Withdraw ETH fees (owner only)
    function withdraw() external {
        require(msg.sender == owner(), "Only owner");
        payable(owner()).transfer(address(this).balance);
    }
}