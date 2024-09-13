// PSDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EVMStorageMappings {
    // mappings(key => value) value takes up uint256
    // slot of value == keccak256(key, slot where mapping is declared)
    // slot(0)
    mapping(address => uint256) public map;

    //constants
    address public constant ADDR_1 = address(1);
    address public constant ADDR_2 = address(2);
    address public constant ADDR_3 = address(3);

    constructor() {
        map[ADDR_1] = 11;
        map[ADDR_2] = 22;
        map[ADDR_3] = 33;
    }

    function testMapping(address key) public view returns (uint256 val) {
        // slot of value == keccak256(key, slot where mapping is declared)
        bytes32 slot = keccak256(abi.encode(key, uint256(0)));
        assembly {
            val := sload(slot)
        }
    }
}
