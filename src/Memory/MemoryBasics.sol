// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract MemoryBasics {
    // mstore(p, v) = store 32 bytes to memory starting at memory location p
    // mload(p) = load 32 byes from starting at memory location 9

    function test1() public pure returns (bytes32 b32) {
        assembly {
            let p := mload(0x40)
            mstore(p, 0xababab)
            b32 := mload(p)
        }
    }

    function test2() public pure {
        assembly {
            mstore(0, 0x11)
            // 0 1  2  3  <--- these represent the bytes so byte 0 byte 1 bytes 2 byte 3 bytes 4 and so on, also 0x11 is padded to equal 32bytes
            // 0x0000000000000000000000000000000000000000000000000000000000000011
            mstore(1, 0x22)
            // 0 1
            // 0x0000000000000000000000000000000000000000000000000000000000000000 <-- so we start at byte 1 and store the 0x22 padded to be 32bytes which is why we will overflow into the next memory slot
            // 0x2200000000000000000000000000000000000000000000000000000000000000
            mstore(2, 0x33)
            // 0  1  2
            // 0x0000000000000000000000000000000000000000000000000000000000000000
            // 0x0033000000000000000000000000000000000000000000000000000000000000

            mstore(3, 0x44)
            // 0  1  2  3
            // 0x0000000000000000000000000000000000000000000000000000000000000000
            // 0x0000440000000000000000000000000000000000000000000000000000000000
        }
    }
}
