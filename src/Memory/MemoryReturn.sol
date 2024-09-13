// SPDX-License-Identifier: MIT

// Note to self this is a good challenge
pragma solidity 0.8.24;

contract MemoryReturn {
    // return (start, length)
    // - Halt execution
    // - return data stored in memory from star to start + length

    function testReturnValues() public view returns (uint256, uint256) {
        assembly {
            mstore(0x80, 11)
            mstore(0xa0, 22)
            return(0x80, 0x40)
        }
    }

    function testReturnHaltsCode() public view returns (uint256, uint256) {
        testReturnValues(); // <-- this will be the data returned since the aseembly code halts the execution
        return (123, 456); // <-- this will not be returned
    }

    function testReturnDynArray() public pure returns (uint256[] memory) {
        //ABI encode uint256[] array with 3 elemnts 11, 22, 44
        assembly {
            // offset
            mstore(0x80, 0x20)

            // length
            mstore(add(0x80, 0x20), 3)

            // array of elements
            mstore(add(0x80, 0x40), 11)
            mstore(add(0x80, 0x60), 22)
            mstore(add(0x80, 0x80), 33)

            // return
            return(0x80, mul(5, 0x20))
        }
    }
}
