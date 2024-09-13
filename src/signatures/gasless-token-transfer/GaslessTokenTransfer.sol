// SPDX-License_Identifier: MIT

pragma solidity 0.8.24;

import {IERC20Permit} from "./IERC20Permit.sol";

contract GaslessTokenTransfer {
    function send(
        address _token,
        address _sender,
        address _receiver,
        uint256 _amount,
        uint256 _fee,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        /* 
        So we were having trouble because we were not passing the full amount into the permit function, we were passing amount not amount + fee
        This caused the signature verification to fail which shows that the signature is not malleable... or at least not easily.
        */

        //permit

        IERC20Permit(_token).permit(_sender, address(this), _amount + _fee, _deadline, _v, _r, _s); //This will call the permit function on the ERC20 contract and this address will be approve to spend their money
        IERC20Permit(_token).transferFrom(_sender, _receiver, _amount);
        IERC20Permit(_token).transferFrom(_sender, address(this), _fee);
    }
}
