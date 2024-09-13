// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Caller, CalledFirst, CalledLast} from "src/delegatecall/WhoIsMsgSenderSituationOne.sol";

contract TestWhoIsMsgSenderSituationOne is Test {
    Caller caller;
    CalledFirst calledFirst;
    CalledLast calledLast;

    function setUp() public {
        calledLast = new CalledLast();
        calledFirst = new CalledFirst(address(calledLast));
        caller = new Caller(address(calledFirst));
    }

    /*     
    * Side note  when there is a `delegatecall` chain (no gaps, or using call) then the storage very first delegatecall contract will be used even in the nth contract in the delegatecall chain
    * For example, in the test below the storage of `Caller` will be referenced when we are in the `CalledLast` contract
    * In this situation the msg.sender will be the same in all three contracts.
    * Since delegatecall uses the storage of the `Caller` contract we have to read the data from the `Caller` contract 
    */

    function testWhoIsMsgSenderOne() public {
        caller.delegateCallToFirst();
        console.log("Caller constract msg.sender: ", caller.msgSenderCaller());
        console.log("CalledFirst contract msg.sender: ", caller.msgSenderCalledFirst());
        console.log("CalledLast contract msg.sender: ", caller.msgSenderCalledLast());
    }
}
