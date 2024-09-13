// SDPX-License-Identifier: MIT

//The following examples are hard to demonstrate with normal tests
// please copy and paste the following code into Remix or use Foundry Debugging to see how the stack and memory of the contract changes as you step through the functions

//Main points
// 1. Return data that has no specified location is returned on the stack.
// 2. Return data that has memory location specifed is returned in memory and the pointer to the memory location is stored on the stack

pragma solidity 0.8.24;

contract MemoryInternalFunctionReturn {
    function publicFunction() public returns (bytes memory) {}

    function internalFunctionReturnStack() private pure returns (uint256) {
        return uint256(0xabaabab);
    }

    function testInternalFunctionReturnStack() public pure {
        internalFunctionReturnStack(); //The data will be returned on the top of the stack
    }

    function internalFunctionReturnMem() private pure returns (bytes32[] memory) {
        bytes32[] memory bytesArray = new bytes32[](3); // this is initializing a bytes32[] whith size 3
        bytesArray[0] = bytes32(uint256(0xaaaa));
        bytesArray[1] = bytes32(uint256(0xbbbb));
        bytesArray[2] = bytes32(uint256(0xcccc));
        return bytesArray;
    }

    function testInternalFunctionReturnMem() public pure {
        internalFunctionReturnMem(); // Data will return data in memory with a pointer to the memory location on the top of the stack
    }
}
