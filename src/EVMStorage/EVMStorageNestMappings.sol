// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EVMStorageNestedMappings {
    // Normal mapping
    // key => value
    // slot of value = keccak256(key, slot of where the mappings is declared)
    // Nested Mapping
    // key0 => key1 => val
    // slot of value = keccak256(key1 , keccak256(key0, slot of where the mappings is declared))
    //
    mapping(address => mapping(address => uint256)) public nestedMap;

    address public constant ADDR_1 = address(1);
    address public constant ADDR_2 = address(2);
    address public constant ADDR_3 = address(3);

    constructor() {
        nestedMap[ADDR_1][ADDR_2] = 11;
        nestedMap[ADDR_2][ADDR_3] = 22;
        nestedMap[ADDR_3][ADDR_1] = 33;
    }

    function testNestedMapping(address key0, address key1) public view returns (uint256 val) {
        bytes32 inner = keccak256(abi.encode(key0, uint256(0)));
        bytes32 slot = keccak256(abi.encode(key1, inner));
        assembly {
            val := sload(slot)
        }
    }
}
