// PSDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract MemoryStruct {
    // memory data is not packed - all data is stored in chunks of 32 bytes
    // In contrast state variables will be packed
    struct Point {
        uint256 x;
        uint32 y;
        uint32 z;
    }

    function testReadMemory() public pure returns (uint256 x, uint256 y, uint256 z) {
        //Point is loaded to memory starting at 0x80 <--- which can be confirmed by reading the free memory pointer in slot 0x40
        // 0x80 = initial free memory

        Point memory p = Point(1, 2, 3);

        assembly {
            x := mload(0x80)
            // y := mload(add(0x80, 0x20)) or to be more gas efficient we can write it like below
            y := mload(0xa0)
            z := mload(0xc0) // <-- we added 32 bytes to the previous point
        }
    }

    function testWriteMemoryStruct() public pure returns (bytes32 freeMemPointer, uint256 x, uint256 y, uint256 z) {
        Point memory p; // when assigning memory in solidity the free memory pointer is updated< however is assembly is not updated so be cautious

        assembly {
            mstore(0x80, 11)
            mstore(0xa0, 22)
            mstore(0xc0, 33)
            freeMemPointer := mload(0x40) // This should point to 0xe0
        }

        x = p.x;
        y = p.y;
        z = p.z;
    }
}
