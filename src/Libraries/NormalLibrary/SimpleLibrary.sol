// SPDX-License-Identifier: MIT

// This is to test how `external libraries` are interacted with in EVM
// Learning notes;
// 1. Libraries that contain external functions are deployed as an external contract and called with delegatecall
// 2. Library functions are only visible in a child contract if the contract implements them
//  a. i.e. The contract SimpleLibraryInteraction does not implement the function: testIsVisibleThroughInheritedContract Thus when you cannot call it through SimpleLibraryInteraction
// 3. You can get the address of an external to implement the library logic in any other contrac.
// 4. Libraries natively do not support state variables  but they can be givne there own storage, please see the Diamond folder for details.

pragma solidity ^0.8.24;

library SimpleLibrary {
    function tryAdd(uint256 a, uint256 b) external pure returns (bool succes, uint256 result) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function incrementCounter(uint256[] storage self) external returns (uint256) {
        self[0] += 1;
    }

    function testIsVisibleThroughInheritedContract() external pure returns (bool success) {
        success = true;
    }
}

contract SimpleLibraryInteraction {
    using SimpleLibrary for uint256;

    uint256[] public countArray = new uint256[](1);

    function add(uint256 a, uint256 b) external pure returns (uint256) {
        (bool success, uint256 result) = a.tryAdd(b);
        require(success, "Addition failed");
        return result;
    }

    /// @notice This will return the address of the library
    /// @return Returns the address of the library that was imorted into the contract
    function getLibraryAddress() external view returns (address) {
        address libraryAddress = address(SimpleLibrary);
        return libraryAddress;
    }

    function incrementCounterWithLibrary() external returns (uint256) {
        SimpleLibrary.incrementCounter(countArray);
        return countArray[0];
    }
}

contract TestVisibleFunctions {
    function callLibraryThroughContract(address targetAddress) external returns (bool success) {
        // success = SimpleLibraryInteraction(targetAddress).testIsVisibleThroughInheritedContract(); <-- This does not work

        address libraryAddress = SimpleLibraryInteraction(targetAddress).getLibraryAddress();
        (success,) = libraryAddress.call(abi.encodeWithSignature("testIsVisibleThroughInheritedContract()"));
    }
}
