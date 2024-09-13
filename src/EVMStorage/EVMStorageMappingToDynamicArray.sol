// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EVMStorageMappingToDynamicArray {
    // mapping( key => duanamic arrray (32 byes  elements))

    //simple mapping like mapping(key => 32bytes)
    // slot of value in mapping = keccak256(key, slot)

    //dynamic array of 32 byte elements
    //slot of array element = keccak256(slot) + index

    // mapping => dynamic array

    //slot where the dynamic array is declared = keccak256(key, slot)

    // slot of array element = keccak256(slot) + index

    // thus combined
    // mapping 32byte value = keccak256(keccak256(key, slot where mapping is declared)) + index

    mapping(address => uint256[]) public map;

    address public constant ADDR_1 = address(1);
    address public constant ADDR_2 = address(2);

    constructor() {
        map[ADDR_1].push(11);
        map[ADDR_1].push(22);
        map[ADDR_1].push(33);
        map[ADDR_2].push(44);
        map[ADDR_2].push(55);
        map[ADDR_2].push(66);
    }

    function testMappingDynamicArray(address addr, uint256 index) public view returns (uint256 val, uint256 length) {
        uint256 mapSlot = 0;
        bytes32 mapHash = keccak256(abi.encode(addr, mapSlot));
        bytes32 arrayHash = keccak256(abi.encode(mapHash));

        assembly {
            length := sload(mapHash)
            val := sload(add(arrayHash, index))
        }
    }
}
