// PSDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract EVMStorageDynamicArrayStruct {
    struct Point {
        uint256 x;
        uint128 y;
        uint128 z;
    }

    // For example a Dynamic Arrays are stored like this (if each value takes up 32bytes):
    // Slot of Element = keccak256(slot where array is declared) + index of the element

    // In this situation
    // slot element = keccak256(slot where it is declared) +  amount of slots the struct will take up * Index of the element

    //slot element = kccak256(0) + 2 * index

    Point[] private pointArray;

    constructor() {
        pointArray.push(Point(11, 22, 33));
        pointArray.push(Point(44, 55, 66));
        pointArray.push(Point(77, 88, 99));
    }

    function testGetStructArray(uint256 index) public view returns (uint256 x, uint128 y, uint128 z, uint256 length) {
        // slot element = keccak256(slot where it is declared) +  amount of slots the struct will take up * Index of the element
        bytes32 start = keccak256(abi.encode(uint256(0)));

        assembly {
            length := sload(0)
            // x
            // z | y
            x := sload(add(start, mul(2, index)))
            let zy := sload(add(start, add(mul(2, index), 1)))
            y := zy
            z := shr(128, zy)
        }
    }
}
