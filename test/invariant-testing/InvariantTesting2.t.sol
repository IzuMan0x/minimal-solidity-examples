// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {WETH9} from "./WETH9.sol";
import {Test} from "forge-std/Test.sol";

contract WETH_OpenInvariantTest is Test {
    WETH9 weth;

    function setUp() public {
        weth = new WETH9();
    }

    function invariant_totalSupplyIsZero() public {
        assertEq(weth.totalSupply(), 0);
    }
}
