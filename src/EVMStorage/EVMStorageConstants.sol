// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EVMStorageConstants {
    // constant and immutable variable do not use storage but instead are written in the contract bytecode
    uint256 public s_a = 1; // slot 0

    uint256 constant s_constant = 11; // In contract bytecode
    uint256 immutable s_immutable; // In contract bytecode

    uint256 public s_b = 2; // slot 1

    constructor() {
        s_immutable = 22;
    }

    function testConstantVariables() public view returns (uint256 a, uint256 b) {
        assembly {
            a := sload(0)
            b := sload(1)
        }
    }
}
