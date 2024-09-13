// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console, console2} from "forge-std/Test.sol";
import {EVMStoragePackedSlot} from "src/EVMStorage/EVMStoragePackedSlot.sol";

contract TestEVMStoragePackedSlot is Test {
    EVMStoragePackedSlot evmStoragePackedSlot;

    function setUp() public {
        evmStoragePackedSlot = new EVMStoragePackedSlot();
    }

    function testStorageIsSetAndReadCorrectly() public {
        evmStoragePackedSlot.testSstore();
        console.log(
            evmStoragePackedSlot.s_a(),
            evmStoragePackedSlot.s_b(),
            evmStoragePackedSlot.s_c(),
            evmStoragePackedSlot.s_d()
        );
    }
}
