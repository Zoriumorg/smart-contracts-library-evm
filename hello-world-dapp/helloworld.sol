// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorldContract {
    // State variable to store the message
    string public message;

    // Constructor to initialize the message when the contract is deployed
    constructor() {
        message = "Hello, World!";
    }

    // Function to retrieve the message
    function getMessage() public view returns (string memory) {
        return message;
    }

    // Function to update the message (optional, for learning purposes)
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
}

//gas optimised contact 


// pragma solidity ^0.8.0;

// contract HelloWorldContract {
//     // Fixed-size bytes32 instead of string
//     bytes32 public constant MESSAGE = "Hello, World!";

//     // Function to retrieve the message (returns bytes32)
//     function getMessage() public pure returns (bytes32) {
//         return MESSAGE;
//     }
// }