pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {ModifySignature} from "src/signatures/MalleableSignatures/ModifySignature.sol";
import {SignatureMalleability} from "src/signatures/MalleableSignatures/SignatureMalleability.sol";

contract TestSignatureMalleability is Test {
    ModifySignature modSig;
    SignatureMalleability sigMal;

    uint256 private constant SIGNER_PRIVATE_KEY = 0x8de621a71751c53c96a19570cfb91e9e781d30b6a72ef4f7e349ab0f45fe590d;
    address signerAddress;

    /* events */
    event PackedSig(bytes packedSig, address signer);

    function setUp() public {
        modSig = new ModifySignature();
        sigMal = new SignatureMalleability();
        signerAddress = vm.addr(SIGNER_PRIVATE_KEY);
    }

    function testIsSigMalleable() public {
        //do something
        string memory message = "Hello World";

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SIGNER_PRIVATE_KEY, keccak256(bytes(message)));
        bytes memory packedSig = abi.encodePacked(r, s, v);
        emit PackedSig(packedSig, signerAddress);

        //modify the signature
        bytes memory modifiedSig = modSig.manipulateSignature(abi.encodePacked(r, s, v));

        sigMal.verify(keccak256(bytes(message)), modifiedSig, signerAddress);
        //Lesson use OpenZeppelin library for ECDSA verification here are the lines that prevent the above modification
        //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/dfb3ec36b52ef4703a701c77e61a22b0a79c1359/contracts/utils/cryptography/ECDSA.sol#L132-L138

        //from Openzeppelin ECDSA.sol
        /* 

        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS, s);
        }


        */
    }
}
