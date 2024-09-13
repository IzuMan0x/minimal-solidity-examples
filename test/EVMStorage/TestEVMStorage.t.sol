// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";

import {YulIntro} from "src/EVMStorage/EVMStorageBasics.sol";

contract TestEVMStorage is Test {
    YulIntro yulIntro;

    function setUp() public {
        yulIntro = new YulIntro();
    }

    function testYulIntro() public {
        uint256 result = yulIntro.testYulVar();
        console.log("The returned data is: ", result);
    }

    // Run this test with -vvvv to see the return data
    function testYulTypes() public {
        (bool x, uint256 y, bytes32 z) = yulIntro.testYulTypes();
    }
}
