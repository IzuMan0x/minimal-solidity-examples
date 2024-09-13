// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC20Permit, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract MockERC20Permit is ERC20Permit {
    constructor(string memory _name) ERC20Permit(_name) ERC20(_name, _name) {
        //do something here
    }

    function mint(address _receiver, uint256 _amount) external {
        _mint(_receiver, _amount);
    }
}
