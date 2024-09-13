// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";

import {MostSignificantBit} from "src/JustFuzzIt/MostSignificantBit.sol";

contract TestMostSignificantBit is Test {
    MostSignificantBit msb;

    function setUp() public {
        msb = new MostSignificantBit();
    }

    function testManually() public {
        assertEq(msb.findMostSignifcantBit(0), 0);
        assertEq(msb.findMostSignifcantBit(1), 0);
        assertEq(msb.findMostSignifcantBit(2), 1);
        assertEq(msb.findMostSignifcantBit(4), 2);
        assertEq(msb.findMostSignifcantBit(8), 3);
        assertEq(msb.findMostSignifcantBit(type(uint256).max), 255);
    }

    function mostSigBit(uint256 x) private pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }
    //Notes:
    // µ is the average gas cost <-- to type µ press OPTION + M on mac
    // ~ is the median gas cost

    function testMostSigBitFuzz(uint256 x) public {
        // skip if x = 0
        vm.assume(x > 0);
        assertGt(x, 0);

        //bound(input, min,max) and returns the bound input
        x = bound(x, 1, 10);
        assertGe(x, 1);
        assertLe(x, 10);

        uint256 i = msb.findMostSignifcantBit(x);
        assertEq(i, mostSigBit(x));
    }
}
