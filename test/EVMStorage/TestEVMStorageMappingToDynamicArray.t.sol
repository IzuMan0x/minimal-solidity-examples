// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {EVMStorageMappingToDynamicArray} from "src/EVMStorage/EVMStorageMappingToDynamicArray.sol";

contract TestEVMStorageMappingToDynamicArray is Test {
    EVMStorageMappingToDynamicArray evmStorageMappingToDynamicArray;

    function setUp() public {
        evmStorageMappingToDynamicArray = new EVMStorageMappingToDynamicArray();
    }

    function testGetValueInMappedDynamicArray() public view {
        evmStorageMappingToDynamicArray.testMappingDynamicArray(address(1), 0);
    }
}
