// SPDX-Lincese-Identifier: MIT
pragma solidity ^0.8.24;

import {MockERC20Permit} from "./MockERC20Permit.sol";
import {Test, console} from "forge-std/Test.sol";
import {GaslessTokenTransfer} from "src/signatures/gasless-token-transfer/GaslessTokenTransfer.sol";

contract TestGasLessTokenTransfer is Test {
    MockERC20Permit permitToken;
    GaslessTokenTransfer gaslessContract;

    uint256 constant SENDER_PRIVATE_KEY = 123;

    address sender;
    address receiver;
    uint256 constant AMOUNT = 1000;
    uint256 constant FEE = 10;

    function setUp() public {
        sender = vm.addr(SENDER_PRIVATE_KEY);
        receiver = makeAddr("receiver");

        permitToken = new MockERC20Permit("test");
        gaslessContract = new GaslessTokenTransfer();
        permitToken.mint(sender, AMOUNT + FEE);
    }

    function testValidSig() public {
        console.log("sender", sender);
        console.log("receiver", receiver);
        console.log("contract address", address(gaslessContract));
        console.log("test contract address", address(this));
        //Prepare the permit message
        uint256 deadline = block.timestamp + 60 seconds;

        //Get the permit hash which we will sign with Foundry
        bytes32 permitHash = _getPermitHash(
            address(sender), address(gaslessContract), AMOUNT + FEE, permitToken.nonces(sender), deadline
        );
        //Sign the message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(SENDER_PRIVATE_KEY, permitHash);
        // Execute send

        gaslessContract.send(address(permitToken), sender, receiver, AMOUNT, FEE, deadline, v, r, s);

        // check token balances
        vm.assertEq(permitToken.balanceOf(sender), 0); // "balance of the sender"
        vm.assertEq(permitToken.balanceOf(receiver), AMOUNT); //"balance of the receiver"
        vm.assertEq(permitToken.balanceOf(address(gaslessContract)), FEE); // "balance of this contract"
    }

    /* DOMAIN_SEPARATOR = keccak256(
        abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256(bytes(name)),
            keccak256(bytes(version)),
            chainid,
            address(this)
        )
    ); */

    //For more info check out on the signing standard: https://eips.ethereum.org/EIPS/eip-2612

    //So we call this function which will return the permitHash has that we/owner need to sign
    function _getPermitHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)
        private
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19\x01", // hex"1901" <-- is the same
                permitToken.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                        owner,
                        spender,
                        value,
                        nonce,
                        deadline
                    )
                )
            )
        );
    }
}
