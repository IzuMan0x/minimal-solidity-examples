// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MemoryGasCost} from "src/Memory/MemoryGasCost.sol";

contract TestMemoryBasics is Test {
    MemoryGasCost memGasCost;

    function setUp() public {
        memGasCost = new MemoryGasCost();
    }
    // The gas cost to allocated memory grows quadratically

    function testMmoryAllocationCost() public {
        uint256 gasConsumed = memGasCost.allocateMem(2);
        console.log(gasConsumed);
    }
}
