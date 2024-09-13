// SDPX-License-Identifier: MIT
pragma solidity 0.8.24;

contract EVMStorageFixedSizeArray {
    // Fixed array with elements <= 32 bytes
    // slot of element = slot where the aray is declared + index of array element
    // slot 0, slot 1 ,and slot 2
    uint256[3] private arr_0 = [1, 2, 3];

    //slot 3, slot 4, and slot 5
    uint256[3] private arr_1 = [4, 5, 6];

    // slot 6, slot 6, slot 7, slot 7, slot 8
    uint128[5] private arr_2 = [7, 8, 9, 10, 11]; // note each uint128 number takes up 16 bytes and this will be difficult to access in assembly

    function testArray0(uint256 index) public view returns (uint256 v) {
        assembly {
            v := sload(index)
        }
    }

    function testArray1(uint256 index) public view returns (uint256 v) {
        assembly {
            v := sload(add(3, index)) // we need to add three since the array is declared at slot three
        }
    }

    function testArray2(uint256 index) public view returns (uint128 v) {
        assembly {
            let b32 := sload(add(6, div(index, 2))) // The division will return the correct slot for the index and the add operation adds the slot number where the array is declared

            // slot 6, 6, 7, 7,  8
            //     [7, 8, 9, 10, 11]
            //      0, 1, 2,  3,  4

            // slot 6 = 1st element | 0th element
            // slot 7 = 3rd element | 2nd element
            // slot 8 = 000 ... 000 | 4th element

            switch mod(index, 2)
            case 1 { v := shr(128, b32) }
            // If there is a remainder of 1 which means the number (index) is odd then we will shift the data to the right
            default { v := b32 }
        }
    }
}
