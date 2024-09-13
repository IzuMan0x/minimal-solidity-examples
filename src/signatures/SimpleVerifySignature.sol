// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract SimpleVerifySignature {
    function getMessageHash(address _to, uint256 _amount, string memory _message, uint256 _nonce)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19ethereum SignedMessage:\n32", _messageHash));
    }
}
