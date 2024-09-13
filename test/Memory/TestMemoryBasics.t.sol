// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemoryBasics} from "src/Memory/MemoryBasics.sol";

contract TestMemoryBasics is Test {
    MemoryBasics memoryBasics;

    function setUp() public {
        memoryBasics = new MemoryBasics();
    }

    function testReadingMemory() public {
        memoryBasics.test1();
        memoryBasics.test2();
    }
}
