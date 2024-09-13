// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract MemoryGasCost {
    // The gas cost to allocate memory grows quadratically
    // Gas cost can be approximated with:
    // memory_cost = memory_size_word**2/512 + 3*(memory_size_word)
    function allocateMem(uint256 number) public view returns (uint256) {
        uint256 gasStart = gasleft();
        uint256[] memory arr = new uint256[](number);
        uint256 gasEnd = gasleft();
        return gasStart - gasEnd;
    }
}
