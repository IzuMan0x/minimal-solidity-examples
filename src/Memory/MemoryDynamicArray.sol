// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract MemoryDynamicArray {
    function testRead() public pure returns (bytes32 p, uint256 length, uint256 a0, uint256 a1, uint256 a2) {
        uint256[] memory arr = new uint256[](5);
        arr[0] = uint256(11);
        arr[1] = uint256(22);
        arr[2] = uint256(33);
        arr[3] = uint256(44);
        arr[4] = uint256(55);

        assembly {
            p := arr //This points to the memory address 0x80
            length := mload(arr)
            a0 := mload(add(arr, 0x20))
            a1 := mload(add(arr, 0x40))
            a2 := mload(add(arr, 0x60))
        }
    }

    function testWrite() public pure returns (bytes32 p, uint256[] memory) {
        //uint256[] memory arr; //note this points to 0x60 not to 0x80
        uint256[] memory arr = new uint256[](0); // This will point to 0x80 memory slot when you initialize the array

        assembly {
            p := arr
            mstore(arr, 3) //  note we can change the length of an array in assembly
            mstore(add(arr, 0x20), 11)
            mstore(add(arr, 0x40), 22)
            mstore(add(arr, 0x60), 33)
            // We need to update the free memory pointer
            mstore(0x40, add(arr, 0x80))
        }

        return (p, arr); // Also if we did not update the free memory pointer solidity will not correctly return the array since solidity abi encodes the array in memory
    }
}
