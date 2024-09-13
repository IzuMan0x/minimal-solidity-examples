// SPDX-License-Identifer: MIT
pragma solidity 0.8.24;

import {Test} from "forge-std/Test.sol";
import {EVMStorageMappings} from "src/EVMStorage/EVMstorageMappings.sol";

contract TestEVMStorageMappings is Test {
    EVMStorageMappings evmStorageMappings;

    function setUp() public {
        evmStorageMappings = new EVMStorageMappings();
    }

    function testGetMappingsUsingAssembly() public view {
        vm.assertEq(11, evmStorageMappings.testMapping(address(1)));
        vm.assertEq(22, evmStorageMappings.testMapping(address(2)));
        vm.assertEq(33, evmStorageMappings.testMapping(address(3)));
    }
}
