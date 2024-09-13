// SPDX-License-Ideintifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

contract IntroInvariants {
    bool public flag;

    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}

    function func_5() external {
        flag = true;
    }
}

contract TestIntroInvariant is Test {
    IntroInvariants target;

    function setUp() public {
        target = new IntroInvariants();
    }

    function invariant_flag_is_always_false() public {
        // to indicate  an invariant function start the function name with invariant
        assertEq(target.flag(), false);
    }
}
