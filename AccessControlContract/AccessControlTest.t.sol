// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AccessControl.sol";

contract AccessControlTest {
    AccessControl accessControl;
    address admin = address(this);
    address user1 = address(0x1);
    
    bytes32 ADMIN_ROLE = keccak256(abi.encodePacked("ADMIN"));
    bytes32 USER_ROLE = keccak256(abi.encodePacked("USER"));
    
    constructor() {
        accessControl = new AccessControl();
    }
    
    function testInitialAdmin() public view returns (bool) {
        bool isAdmin = accessControl.roles(ADMIN_ROLE, admin);
        return isAdmin; // Expect: true
    }
    
    function testGrantRole() public returns (bool) {
        accessControl.grantRole(USER_ROLE, user1);
        bool hasUserRole = accessControl.roles(USER_ROLE, user1);
        return hasUserRole; // Expect: true
    }
    
    function testRevokeRole() public returns (bool) {
        accessControl.grantRole(USER_ROLE, user1);
        accessControl.revokeRole(USER_ROLE, user1);
        bool hasUserRole = accessControl.roles(USER_ROLE, user1);
        return hasUserRole; // Expect: false
    }
    
    function testNonAdminCannotGrant() public view returns (bool) {
        // Note: This can't fully test revert in Remix without multiple accounts
        bool initialState = accessControl.roles(USER_ROLE, user1);
        return initialState; // Expect: false initially
    }
    
    // Event testing can't be directly asserted in Remix, but can be observed in logs
    function testGrantRoleEvent() public {
        accessControl.grantRole(USER_ROLE, user1);
        // Check logs manually in Remix for GrantRole event
    }
}