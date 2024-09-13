// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MemoryFixedArray} from "src/Memory/MemoryFixedArray.sol";

contract TestMemoryFixedArray is Test {
    MemoryFixedArray memoryFixedArray;

    function setUp() public {
        memoryFixedArray = new MemoryFixedArray();
    }

    function testMemoryFixedArrayReadingWriting() public {
        memoryFixedArray.testRead();
        memoryFixedArray.testWrite();
    }
}
