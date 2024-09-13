// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";

import {SimpleLibraryInteraction} from "src/Libraries/NormalLibrary/SimpleLibrary.sol";

contract TestSimpleLibrary is Test {
    SimpleLibraryInteraction contractInstance;

    function setUp() public {
        contractInstance = new SimpleLibraryInteraction();
    }

    function testWhatIsTheAddressOfTheLibrary() public {
        console.log("The Address of the Library is: ", contractInstance.getLibraryAddress()); // This will returnt the address of the library since it is an external contract
    }

    function testStateChangingLibrayCall() public {
        uint256 updatedCount = contractInstance.incrementCounterWithLibrary();
        console.log("The current count is: ", updatedCount);
    }
}
