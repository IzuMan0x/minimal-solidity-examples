// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {EVMStorageDynamicArrayStruct} from "src/EVMStorage/EVMStorageDynamicArrayStruct.sol";

contract TestEVMStorageDynamicArrayStruct is Test {
    EVMStorageDynamicArrayStruct evmStorageDynamicArrayStruct;

    function setUp() public {
        evmStorageDynamicArrayStruct = new EVMStorageDynamicArrayStruct();
    }

    function testGetDyanamicArrayOfStructs() public view {
        evmStorageDynamicArrayStruct.testGetStructArray(0);
    }
}
