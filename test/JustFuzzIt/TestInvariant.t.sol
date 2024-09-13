// SPDX-License-Identifier: MIT

/// @title Simple contract for testing Invariant
/// @author Smart Contract Programmer and Izuman
/// @notice Contract has 4 functions that don't do anything and one that will break the invariants
/// @dev We are targeting a contract with random function calls then asserting the state of the contract is as expected
contract IntroInvariant {
    bool public flag;

    function func1() external {}
    function func2() external {}
    function func3() external {}
    function func4() external {}

    function func5() external {
        flag = true;
    }
}

import {Test} from "forge-std/Test.sol";

contract TestIntroInvariant is Test {
    IntroInvariant private target;

    function setUp() public {
        target = new IntroInvariant();
    }

    function invariant_flagIsAlwaysFalse() public view {
        assertEq(target.flag(), false);
    }
}
