// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

// For the proof why (a + b)/2 == (a & b) + (a ^ b) / 2
// Visit here: https://www.geeksforgeeks.org/find-average-of-two-numbers-using-bit-operation/

library AverageLibrary {
    uint256 private constant BIG_NUMBER = 2 ** 255; // This number will easily overflow when trying to calculate the aveage of it with a similar sized numberß

    function averageNoOverflow(uint256 a, uint256 b) public returns (uint256) {
        uint256 result;

        assembly {
            /* let partA := and(a, b)
            let partB := div(or(a, b), 0x02)
            result := add(partA,partB ) */
            result := add(and(a, b), div(xor(a, b), 0x2))
        }
        //return (a & b) + (a ^ b) / 2; <--- this will return the same result without using assembly
        return result;
    }

    function testMaxAverage() public returns (uint256 average) {
        average = averageNoOverflow(BIG_NUMBER, BIG_NUMBER);
        return average;
    }

    function getCorrectAverage() public pure returns (uint256 maxUint) {
        maxUint = BIG_NUMBER; // This is here so we can compare the caclulated average to what is should be
    }
}
