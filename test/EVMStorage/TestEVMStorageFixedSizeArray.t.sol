// PSDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";

import {EVMStorageFixedSizeArray} from "src/EVMStorage/EVMStorageFixedSizeArray.sol";

contract TestEVMStorageFixedSizeArray is Test {
    EVMStorageFixedSizeArray evmStorageFixedSizeArray;

    function setUp() public {
        evmStorageFixedSizeArray = new EVMStorageFixedSizeArray();
    }

    function testReadingArrayTwo() public {
        evmStorageFixedSizeArray.testArray2(0);
    }
}
