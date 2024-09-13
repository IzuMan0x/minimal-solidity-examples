// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract EVMStoragePackedSlot {
    // Data < 32bytes are packed into a slot
    // Bit Masking
    // slot, offset

    // slot 0
    uint128 public s_a; // 16 bytes
    uint64 public s_b; // 8 bytes
    uint32 public s_c; // 4 bytes
    uint32 public s_d; // 4 bytes

    //slot 1
    address public s_addr; // 20 bytes 160 bits remember how to typecast address to uint256?? Like this: uint256(uint160(s_someAddress))
    // slot 1 has 96 bits left or 12 bytes or 12*8 which is 96 bits
    uint64 public s_x;
    uint32 public s_y;

    function testSstore() public {
        assembly {
            let v := sload(0) // loads 32 bytes from slot 0
                //here is the layout of slot 0
                // s_d | s_c | s_b | s_a
                // 32  | 32  | 64  | 128  ----> in total 256 bits
                // 4   | 4   | 8   | 16  ----> in total 32 bytes

            // Lets set s_a = 11
            // 111 ... 111 | 000 ... 000
            //             | 128 bits
            // Procedure
            // 1. shift left 128 bits which will give you a 1 in the 129th spot from the right side
            // 2. subtract 1 will give you 128 1's from the right side
            // 3. `not` will invert the bits and give you 128 1's from the left side
            let mask_a := not(sub(shl(128, 1), 1))
            // This clears out the first 128 bits of `v`(from the right)
            // so we have this after the and operation:
            // 110 ... 101 | 000 ... 000
            //    128 bits | 128 bits
            v := and(v, mask_a)
            // In the first 128 bits we will be storing 11.
            v := or(v, 11)

            // Set s_b = 22
            // We need to create the following bit mask
            // 111 ... 111 | 000 ... 000 | 111 ... 111
            //             |   64 bits   |   128 bits
            let mask_b := not(shl(128, sub(shl(64, 1), 1)))
            v := and(v, mask_b)
            v := or(v, shl(128, 22))

            // Set s_c = 33
            // We need to create the following bit mask
            // 111 ... 111 |000 ... 000 | 111 ... 111 | 111 ... 111
            //             |    32 bits  |   64 bits   |   128 bits
            let mask_c := not(shl(192, sub(shl(32, 1), 1)))
            v := and(v, mask_c)
            v := or(v, shl(192, 33))

            // Set s_d = 33
            // We need to create the following bit mask
            // 000 ... 000 |111 ... 111 | 111 ... 111 | 111 ... 111
            //  32 bits    |    32 bits  |   64 bits   |   128 bits
            let mask_d := not(shl(224, sub(shl(32, 1), 1)))
            v := and(v, mask_d)
            v := or(v, shl(224, 44))

            sstore(0, v)
        }
    }

    // @dev note that the return value is in bytes
    function testSlotZeroOffset()
        public
        pure
        returns (uint256 a_offset, uint256 b_offset, uint256 c_offset, uint256 d_offset)
    {
        assembly {
            a_offset := s_a.offset
            b_offset := s_b.offset
            c_offset := s_c.offset
            d_offset := s_d.offset
        }
    }

    function testSstoreMethodTwo() public {
        // instead of writing the numeric bit expression we will use:
        // variable.slot ---> returns the slot of the variable
        // variable.offset ---> returns the offset of the variable within the slot
        //
        assembly {
            let v := sload(s_a.slot) // loads 32 bytes from slot 0
                //here is the layout of slot 0
                // s_d | s_c | s_b | s_a
                // 32  | 32  | 64  | 128  ----> in total 256 bits
                // 4   | 4   | 8   | 16  ----> in total 32 bytes

            // Lets set s_a = 11
            // 111 ... 111 | 000 ... 000
            //             | 128 bits
            // Procedure
            // 1. shift left 128 bits which will give you a 1 in the 129th spot from the right side
            // 2. subtract 1 will give you 128 1's from the right side
            // 3. `not` will invert the bits and give you 128 1's from the left side
            let mask_a := not(sub(shl(128, 1), 1))
            // This clears out the first 128 bits of `v`(from the right)
            // so we have this after the and operation:
            // 110 ... 101 | 000 ... 000
            //    128 bits | 128 bits
            v := and(v, mask_a)
            // In the first 128 bits we will be storing 11.
            v := or(v, 11)

            // Set s_b = 22
            // We need to create the following bit mask
            // 111 ... 111 | 000 ... 000 | 111 ... 111
            //             |   64 bits   |   128 bits
            let mask_b := not(shl(mul(s_b.offset, 8), sub(shl(64, 1), 1)))
            v := and(v, mask_b)
            v := or(v, shl(mul(s_b.offset, 8), 22))

            // Set s_c = 33
            // We need to create the following bit mask
            // 111 ... 111 |000 ... 000 | 111 ... 111 | 111 ... 111
            //             |    32 bits  |   64 bits   |   128 bits
            let mask_c := not(shl(mul(s_c.offset, 8), sub(shl(32, 1), 1)))
            v := and(v, mask_c)
            v := or(v, shl(mul(s_c.offset, 8), 33))

            // Set s_d = 33
            // We need to create the following bit mask
            // 000 ... 000 |111 ... 111 | 111 ... 111 | 111 ... 111
            //  32 bits    |    32 bits  |   64 bits   |   128 bits
            let mask_d := not(shl(mul(s_d.offset, 8), sub(shl(32, 1), 1)))
            v := and(v, mask_d)
            v := or(v, shl(mul(s_d.offset, 8), 44))

            sstore(0, v)
        }
    }
}
