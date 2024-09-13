// PSDX-License-Identifer: MIT

pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {EVMStorageDynamicSizedArray} from "src/EVMStorage/EVMStorageDyanamicSizedArray.sol";

contract TestEVMStorageDynamicSizedArray is Test {
    EVMStorageDynamicSizedArray evmStorageDynamicSizedArray;

    function setUp() public {
        evmStorageDynamicSizedArray = new EVMStorageDynamicSizedArray();
    }

    function testGetDynamicSizedArray() public {
        evmStorageDynamicSizedArray.testGettingDynamicArray(0, 0);
        evmStorageDynamicSizedArray.testGettingDynamicArray(1, 0); // the uint256 returned number will be incorrect
    }

    function testGetDynamicSizedArrayUint128() public {
        evmStorageDynamicSizedArray.testGettingDynamicSizedUint128(1, 2);
    }
}
