// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MemoryABIEncoding} from "src/Memory/MemoryABIEncoding.sol";

contract TestMemoryABIEncoding is Test {
    MemoryABIEncoding contractInstance;

    function setUp() public {
        contractInstance = new MemoryABIEncoding();
    }

    function testAbiEncodingAddress() public view {
        contractInstance.encodeAddress();
    }

    function testAbiEncodingFixedBytes() public view {
        contractInstance.encodeBytes4();
    }

    function testAbiencodingStruct() public view {
        contractInstance.encodeStruct();
    }

    function testAbiEncodingDynamicArray() public view {
        contractInstance.encodeUint8Array();
    }

    function testAbiEncodingBytes() public view {
        contractInstance.encodeBytes();
    }
}
