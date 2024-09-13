// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {EVMStorageStruct} from "src/EVMStorage/EVMStorageStruct.sol";

contract TestEVMStorageStruct is Test {
    EVMStorageStruct evmStorageStruct;

    function setUp() public {
        evmStorageStruct = new EVMStorageStruct();
    }

    function testAssemblyReadingSingleSlotStructDataMethodTwo() public {
        evmStorageStruct.getSingleSlotStructMethodTwo();
    }

    function testAssemblyReadingMultipleSlotStructDataMethodTwo() public {
        evmStorageStruct.getMultipleSlotStructMethodTwo();
    }
}
