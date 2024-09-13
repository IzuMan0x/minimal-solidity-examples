// PSDX-License-Identifier: MIT
pragma solidity 0.8.24;

/* 
To read from storage slots in assembly just use the `shr` command and read the data from left to right

 */

contract EVMStorageStruct {
    // takes one 32 bytes slot
    struct SingleSlot {
        uint128 x;
        uint64 y;
        uint64 z;
    }
    // takes three 32 byte slots

    struct MultipleSlots {
        uint256 a;
        uint256 b;
        uint256 c;
    }
    // slot 0

    SingleSlot public singleSlot = SingleSlot({x: 1, y: 2, z: 3});
    // slot 1
    // slot 2
    // slot 3
    MultipleSlots public multipleSlot = MultipleSlots({a: 11, b: 22, c: 33});

    function getSingleSlotStruct() public view returns (uint128 x, uint64 y, uint64 z) {
        assembly {
            let s := sload(0)
            // z  |  y  |  x
            // 64 | 64  |  128 bits
            x := s // since x is only 128bits and is stored on the right side we dont have to do antyhing
            y := shr(128, s)
            z := shr(192, s)
        }
    }

    function getSingleSlotStructMethodTwo() public view returns (uint128 x, uint64 y, uint64 z, bytes32 s) {
        assembly {
            s := sload(singleSlot.slot) // <--- This will return bytes32 0x0000000000000003000000000000000200000000000000000000000000000001
            // z  |  y  |  x
            // 64 | 64  |  128 bits
            x := s // since x is only 128bits and is stored on the right side we dont have to do antyhing
            // y := shr(singleSlot.y.offset, s) <--- would be nice if this worked...but it doesn't
            y := shr(128, s)
            z := shr(192, s)
        }
    }

    function getMultipleSlotStruct() public view returns (uint256 a, uint256 b, uint256 c) {
        assembly {
            a := sload(1)
            b := sload(2)
            c := sload(3)
        }
    }

    function getMultipleSlotStructMethodTwo() public view returns (uint256 a, uint256 b, uint256 c, bytes32 s) {
        assembly {
            // So for mutliple slot struct it will just return the start of the struct?
            s := sload(multipleSlot.slot) // This returns bytes32 0x000000000000000000000000000000000000000000000000000000000000000b which in decimal is 11
            a := sload(1)
            b := sload(2)
            c := sload(3)
        }
    }

    /* 
    This purpose of this function is to return the whole struct without hardcoding values
    Of course this will not workin with mappings, arrays, and strings (maybe?? strings might work)
    todo finish this later
     */

    function getMultipleSlotStructMethodThree() public view returns (bytes memory data) {
        assembly {}
    }
}
