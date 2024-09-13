// PSDX-License-Identifer: MIT

pragma solidity 0.8.24;

contract EVMStorageDynamicSizedArray {
    // slot of element = keccak256( slot where the array is declared) + size of element * index of element
    // Also the length of the array is stored in the slot where the array is declared
    //
    // keccak256(0) + 1 * 0  <--- First element slot

    // keccak256(0) + 1 * 1  <--- Second Element slot

    //keccak256(0) + 1 * 2   <--- Third Element slot
    uint256[] private arr = [11, 22, 33]; // Declared at slot 0 thus slot 0 will contain the dyanamic array length

    // slots of the elements are = [ keccak256(1) + 0, keccak256(1) + 0, keccak256(1) + 0.5 * 2 ]
    uint128[] private arr_2 = [1, 2, 3];

    function testGettingDynamicArray(uint256 slot, uint256 index)
        public
        view
        returns (uint256 val, bytes32 b32, uint256 length)
    {
        bytes32 start = keccak256(abi.encode(slot));

        assembly {
            length := sload(slot)
            val := sload(add(start, index)) // This wont return the data nicely formatted for values that are not full 32bytes
            b32 := val
        }
    }

    function testGettingDynamicSizedUint128(uint256 slot, uint256 index)
        public
        view
        returns (uint128 val, bytes32 b32, uint256 length)
    {
        bytes32 start = keccak256(abi.encode(slot));
        assembly {
            length := sload(slot)
            switch mod(index, 2)
            case 1 {
                val := shr(128, sload(add(start, div(index, 2))))
                b32 := shr(128, sload(add(start, div(index, 2))))
            }
            default {
                val := sload(add(start, div(index, 2)))
                b32 := sload(add(start, div(index, 2)))
            }
        }
    }
}
