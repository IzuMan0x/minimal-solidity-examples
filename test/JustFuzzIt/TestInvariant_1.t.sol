// SPDX-License-Identifier: MIT

import {WETH9} from "src/JustFuzzIt/WETH9.sol";
import {Test} from "forge-std/Test.sol";

contract TestWETH9Invariants is Test {
    WETH9 public weth;

    function setUp() public {
        weth = new WETH9();
    }

    function invariant_testWETH9TotalSupplyIsZero() public {
        assertEq(weth.totalSupply(), 0);
    }
}
