// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MemoryStruct} from "src/Memory/MemoryStruct.sol";

contract TestMemoryStruct is Test {
    MemoryStruct memoryStruct;

    function setUp() public {
        memoryStruct = new MemoryStruct();
    }

    function testMemoryStructReadingWriting() public {
        memoryStruct.testWriteMemoryStruct();
        memoryStruct.testReadMemory();
    }
}
