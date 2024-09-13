// PSDX-License-Identifier: MIT
pragma solidity 0.8.24;

// @dev this example is usefull when you wil need to read packed storage data

contract EVMStoragePackedSlotBytes {
    // slot 0 (packed from right to left)
    bytes4 public b4 = 0xabababab;
    bytes2 public b2 = 0xcdcd;

    function get() public view returns (bytes32 b32) {
        assembly {
            b32 := sload(0)
        }
    }
}

contract BitMasking {
    // 32 bytes = 256 bits
    // | 256 bits |
    // 000 ... 000 | 111 |
    //             | 16 bits |
    function testMask() public pure returns (bytes32 maskBeforeSubtraction, bytes32 mask) {
        assembly {
            // 000 ... 001 | 000 ... 000
            // 000 ... 000 | 111 ... 111
            // 0x000000000000000000000000000000000000000000000000000000000000ffff
            // Below is the same number in binary (256 bits)
            /* 
            0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111
             */
            maskBeforeSubtraction := shl(16, 1)
            mask := sub(shl(16, 1), 1)
        }
    }

    //  000 ... 000 | 111 ... 111 | 000 ... 000
    //              | 16 bits     | 32 bits
    function testMaskBothSides() public pure returns (bytes32 mask) {
        assembly {
            //shl(x, y) ---> logical shift left y by x bits
            //  000 ... 000 | 111 ... 111 | 000 ... 000
            //              | 16 bits     | 32 bits
            // 0x0000000000000000000000000000000000000000000000000000ffff00000000
            // each digit in a hex is 4 bits or 1/2 byte

            mask := shl(32, sub(shl(16, 1), 1))
        }
    }

    function testNotMask() public pure returns (bytes32 mask) {
        assembly {
            //  000 ... 000 | 111 ... 111 | 000 ... 000
            //              | 16 bits     | 32 bits
            // 0x0000000000000000000000000000000000000000000000000000ffff00000000
            // each digit in a hex is 4 bits or 1/2 byte
            // 0xffffffffffffffffffffffffffffffffffffffffffffffffffff0000ffffffff

            mask := not(shl(32, sub(shl(16, 1), 1))) // `not` inverts the bits
        }
    }
}
