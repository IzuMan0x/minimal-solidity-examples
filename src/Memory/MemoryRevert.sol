// SPDX-License-Identifier: MIT

contract MemoryRevert {
    // revert(start, length)
    // revert execution and return data store in memory
    // from start to start + length

    /* 
    * Note something learned during this was that memory is like a big array of bytes and not necessarily divided into 32 byte slots
    * Therefore it looks like we are writing in the middle of the slot which is okay.
    * When calling revert() is assembly:
    * 1. first bytes 4 will be the selector.
    * 2. Next 32 bytes it will look for the OFFSET for the revert data
    * 3. Next 32 bytes it will look for the LENGTH of the data
    * 4. Next 32 bytes it will llok for the revert MESSAGE which must be less than 32 bytes.
     */

    function testRevert() public pure {
        assembly {
            mstore(0x80, "ERROR")
            revert(0x80, 0x20)
        }
    }

    function testRevertWithErrorMessage() public pure {
        revert("ERROR");
    }

    function testRevertWithErrorMessageAssembly() public pure {
        // Goal: revert("ERROR")
        assembly {
            let p := mload(0x40) // <-- this is the free memory point location
            // function selector of Error(string)
            // 0x08c379a0 this is 32 bits
            // need to make it 256 bits
            // shift left left by 255 - 31 = 224  <--- note 255 is the index for the 256 bit and 31 is the index for the 32 bit
            // 0x08c379a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
            mstore(p, shl(224, 0x08c379a0))

            //"ERROR"
            // string offset
            mstore(add(p, 0x04), 0x20) // This is interesting not sure why we go to the next storage slot like: mstore(add(p, 0x20), 0x20) <--- This doesnt work checked with Remix

            // string length
            mstore(add(p, 0x24), 5)
            mstore(add(p, 0x44), "ERROR") // Message must be less than 32 bytes
            // revert(4 + 3 * 32) or (0x04 3 * 0x20) = 0x64
            revert(p, 0x64)
        }
    }
}
