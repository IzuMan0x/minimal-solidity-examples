// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ExampleLibrary} from "./ExampleLibrary.sol";
// This contract uses the library to set and retrieve state variables

contract ContractA {
    function setState() external {
        ExampleLibrary.setStateVariables(address(this), "My Name");
    }

    function getState() external view returns (address contractAddress, string memory name) {
        contractAddress = ExampleLibrary.contractAddress();
        name = ExampleLibrary.name();
    }
}
