// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract YulIntro {
    function testYulVar() public pure returns (uint256) {
        uint256 s = 0;
        assembly {
            let x := 1
            x := 2
            s := 100
        }

        return s;
    }

    /// @notice This is to enforce the concept that in Yul all types are 32 bytes

    function testYulTypes() public pure returns (bool x, uint256 y, bytes32 z) {
        assembly {
            x := 1
            y := 0xaaa
            z := "Hello World"
        }
    }
}

contract EVMStorageSingleSlot {
    /* EVM Storage 
    * 2**256 slots, each can store up to 32 bytes
    *  Slots are assigned in teh order that the state variables are declared (There are exceptions like: mappings, dynamic arrays)
    * Data < 32 btes are packed into a slot (right to left)
    *  sstore(k,v) = store v to slot k
    * sload(k) = load 32 bytes from slot k
     */

    uint256 public s_x; // slot 0
    uint256 public s_y; // slot 1
    bytes32 public s_z; // slot 2

    function testSstore() public {
        assembly {
            sstore(0, 500)
            sstore(1, 1000)
            sstore(2, 0xabab)
        }
    }

    function testSstoreMethod2() public {
        assembly {
            sstore(s_x.slot, 800)
            sstore(s_y.slot, 623)
            sstore(s_z.slot, 0xffffff)
        }
    }

    function testSload() public view returns (uint256 x, uint256 y, bytes32 z) {
        assembly {
            x := sload(0)
            y := sload(1)
            z := sload(2)
        }
    }

    function testSloadMethod2() public view returns (uint256 x, uint256 y, bytes32 z) {
        assembly {
            x := sload(s_x.slot)
            y := sload(s_y.slot)
            z := sload(s_z.slot)
        }
    }
}
