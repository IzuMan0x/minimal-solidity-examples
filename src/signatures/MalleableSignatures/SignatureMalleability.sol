// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureMalleability {
    function verify(bytes32 _messageHash, bytes memory _sig, address _expectedSigner) public pure returns (bool) {
        bytes32 ethSignedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
        address signer = recoverSigner(ethSignedHash, _sig);
        return signer == _expectedSigner;
    }

    function recoverSigner(bytes32 _ethSignedHash, bytes memory _sig) public pure returns (address) {
        require(_sig.length == 65, "Invalid signature length");
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
        if (v < 27) {
            v += 27;
        }
        require(v == 27 || v == 28, "Invalid signature v value");
        return ecrecover(_ethSignedHash, v, r, s);
    }
}
