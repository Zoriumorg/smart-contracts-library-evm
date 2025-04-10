// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventLoggerContract {
    // Struct to store event details (optional on-chain storage)
    struct Event {
        address user;
        string action;
        uint256 timestamp;
        uint256 eventId;
        string metadata; // Optional extra data (e.g., JSON string)
    }

    // Event emitted for logging
    event ActivityLogged(
        address indexed user,
        string indexed action, // Indexed for filtering by action type
        uint256 timestamp,
        uint256 eventId,
        string metadata
    );

    // Mapping to store events (optional, can be removed for gas efficiency)
    mapping(uint256 => Event) public eventHistory;

    // Counter for unique event IDs
    uint256 public totalEvents;

    // Admin address for access control
    address public admin;

    // Modifier to restrict access to admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Constructor to set the deployer as admin
    constructor() {
        admin = msg.sender;
        totalEvents = 0;
    }

    // Function to log an action (restricted to admin)
    function logAction(string memory _action, string memory _metadata) public onlyAdmin {
        totalEvents += 1;
        eventHistory[totalEvents] = Event({
            user: msg.sender,
            action: _action,
            timestamp: block.timestamp,
            eventId: totalEvents,
            metadata: _metadata
        });
        emit ActivityLogged(msg.sender, _action, block.timestamp, totalEvents, _metadata);
    }

    // Function to log an action for a specific user (e.g., for dApp backend)
    function logUserAction(address _user, string memory _action, string memory _metadata) public onlyAdmin {
        totalEvents += 1;
        eventHistory[totalEvents] = Event({
            user: _user,
            action: _action,
            timestamp: block.timestamp,
            eventId: totalEvents,
            metadata: _metadata
        });
        emit ActivityLogged(_user, _action, block.timestamp, totalEvents, _metadata);
    }

    // Function to update admin (only current admin can call)
    function setAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid admin address");
        admin = _newAdmin;
    }

    // Function to get event details by ID (for on-chain queries)
    function getEvent(uint256 _eventId) public view returns (Event memory) {
        require(_eventId > 0 && _eventId <= totalEvents, "Invalid event ID");
        return eventHistory[_eventId];
    }

    // Function to get total events (for convenience)
    function getTotalEvents() public view returns (uint256) {
        return totalEvents;
    }
}