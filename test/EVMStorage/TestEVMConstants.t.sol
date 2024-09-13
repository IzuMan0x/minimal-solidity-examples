// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {EVMStorageConstants} from "src/EVMStorage/EVMStorageConstants.sol";

contract TestEVMStorageConstants is Test {
    EVMStorageConstants evmStorageConstants;

    function setUp() public {
        evmStorageConstants = new EVMStorageConstants();
    }

    function testConstantsImmutableDontTakeASlot() public {
        (uint256 a, uint256 b) = evmStorageConstants.testConstantVariables();
        assertEq(a, 1);
        assertEq(b, 2);
    }
}
