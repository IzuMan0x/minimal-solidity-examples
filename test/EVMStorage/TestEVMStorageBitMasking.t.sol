// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";

import {EVMStoragePackedSlotBytes, BitMasking} from "src/EVMStorage/EVMStorageBitMasking.sol";

contract TestEVMStorageBitMasking is Test {
    EVMStoragePackedSlotBytes eVMStoragePackedSlotBytes;
    BitMasking bitMasking;

    function setUp() public {
        eVMStoragePackedSlotBytes = new EVMStoragePackedSlotBytes();
        bitMasking = new BitMasking();
    }

    function testPackedStorageSlot() public {
        bytes32 result = eVMStoragePackedSlotBytes.get();
        assertEq(0x0000000000000000000000000000000000000000000000000000cdcdabababab, result);
    }

    function testBitMaskingResult() public {
        (bytes32 maskBeforeSub, bytes32 mask) = bitMasking.testMask();
        // console.log(result); cannot log bytes 32
    }

    function testBitMaskingBothSides() public {
        bytes32 result = bitMasking.testMaskBothSides();
    }

    function testNotBitMasking() public {
        bytes32 result = bitMasking.testNotMask();
    }
}
