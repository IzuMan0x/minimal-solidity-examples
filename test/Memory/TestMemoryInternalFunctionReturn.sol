// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MemoryInternalFunctionReturn} from "src/Memory/MemoryInternalFunctionReturn.sol";

contract TestMemoryInternalFunctionReturn is Test {
    MemoryInternalFunctionReturn contractInstance;

    function setUp() public {
        contractInstance = new MemoryInternalFunctionReturn();
    }

    function testMemoryInternalMemoryReturns() public view {
        contractInstance.testInternalFunctionReturnMem();
    }

    function testInternalStackReturn() public view {
        contractInstance.testInternalFunctionReturnStack();
    }
}
