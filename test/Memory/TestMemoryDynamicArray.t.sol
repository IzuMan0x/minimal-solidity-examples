// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemoryDynamicArray} from "src/Memory/MemoryDynamicArray.sol";

contract TestMemoryBasics is Test {
    MemoryDynamicArray memoryDynamicArray;

    function setUp() public {
        memoryDynamicArray = new MemoryDynamicArray();
    }

    function testMemoryDynamicArray() public {
        memoryDynamicArray.testWrite();
        memoryDynamicArray.testRead();
    }
}
