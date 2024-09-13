// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;
// Useful javascipt function to make the return data more readable
// str = "000000000000000000000000000000010000000000000000001000000000000000000a00000000
// str.match(/.{1,61}/g)
// This will devide str into pieces of 64 characters

// Why?
// 1. When calling another contract the reeturn data will be ABI encoded
// 2. When calling an external contract in assembly the return data will be abi encoded
// 3. When returning data in assembly you need to abi.encode the return data

contract MemoryABIEncoding {
    // value type <= 32 bytes -> zeero padded on the left
    function encodeAddress() public pure returns (bytes memory) {
        address addr = 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5;
        return abi.encode(addr); // This will return 0x00000000000000000000000095222290dd7278aa3ddd389cc1e1d165cc4bafe5
    }
    // fixed size bytes <= 32 bytes -> zero padded on the right

    function encodeBytes4() public pure returns (bytes memory) {
        bytes4 b4 = 0xaabbccdd; // note in hex 2 digits == 1 bytes, thus 8 digits in Hex is 4 bytes
        return abi.encode(b4); // This will return 0xaabbccdd00000000000000000000000000000000000000000000000000000000
    }

    // struct, fixed size array -> chunks of 32 bytes

    struct Point {
        uint256 x;
        uint128 y; // even though they are only 16 bytes they will still be returned in 32 byte chunks
        uint128 z;
    }

    //encodeStruct return data formated:
    /* 
    
    0000000000000000000000000000000000000000000000000000000000000001', '0000000000000000000000000000000000000000000000000000000000000002', '0000000000000000000000000000000000000000000000000000000000000003
     */

    function encodeStruct() public pure returns (bytes memory) {
        Point memory p = Point(1, 2, 3);
        return abi.encode(p); // This returns 0x000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003
    }

    //Fixed size array
    // does not encode a length and notice the encoding is the same as the above struct

    function encodeUint256FixedSizearray() public pure returns (bytes memory) {
        uint8[3] memory arr;
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        return abi.encode(arr); // This returns 0x000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003
    }

    // dynamic array -> offset + lnegth + 32 bytes elements
    //0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003
    // formatted a little:
    //0x0000000000000000000000000000000000000000000000000000000000000020  <-- Offset where the array starts 0x20 which is 32 bytes
    //  0000000000000000000000000000000000000000000000000000000000000003  <-- This stores the length fo the dynamic array
    //  0000000000000000000000000000000000000000000000000000000000000001  <-- First value in the array, notice all the values are padded from the left with 0 unitl they are 32 bytes
    //  0000000000000000000000000000000000000000000000000000000000000002  <-- Second value in the array
    //  0000000000000000000000000000000000000000000000000000000000000003  <--- Third value in the array
    function encodeUint8Array() public pure returns (bytes memory) {
        uint8[] memory arr = new uint8[](3);
        arr[0] = 1;
        arr[1] = 2;
        arr[2] = 3;
        return abi.encode(arr);
    }

    // This returns
    // 0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000003ababab0000000000000000000000000000000000000000000000000000000000
    //Formatted:
    //0x0000000000000000000000000000000000000000000000000000000000000020 <-- Offset where the data will start
    //  0000000000000000000000000000000000000000000000000000000000000003 <-- length of the data
    //  ababab0000000000000000000000000000000000000000000000000000000000 <--- The data is appended to the previous data and then padded on the right

    function encodeBytes() public pure returns (bytes memory) {
        bytes memory b = new bytes(3);
        b[0] = 0xab;
        b[1] = 0xab;
        b[2] = 0xab;
        return abi.encode(b);
    }
}
