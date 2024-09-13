// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {MemoryCounter, YulCall, TestHelper} from "src/Memory/MemoryCalling.sol";

contract TestMemoryCalling is Test {
    MemoryCounter memCounter;
    YulCall yulCall;
    TestHelper testHelper;

    function setUp() public {
        memCounter = new MemoryCounter();
        yulCall = new YulCall();
        testHelper = new TestHelper();
    }

    function testReturnData() public {
        testHelper.testIncrement(address(yulCall), address(memCounter));
        testHelper.testIncrement(address(yulCall), address(memCounter));
    }
}
