// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {Caller, CalledFirst, CalledLast} from "src/delegatecall/WhoIsMsgSenderSituationTwo.sol";

contract TestWhoIsMsgSenderSituationTwo is Test {
    Caller caller;
    CalledFirst calledFirst;
    CalledLast calledLast;

    function setUp() public {
        calledLast = new CalledLast();
        calledFirst = new CalledFirst(address(calledLast));
        caller = new Caller(address(calledFirst));
    }

    /*     
    * 
    * 
    * In this situation the msg.sender will be the same in the Caller and CalledFirstContract and different in the CalledLastContract
    * 
    */

    function testWhoIsMsgSenderTwo() public {
        caller.delegateCallToFirst();
        console.log("Caller constract msg.sender: ", caller.msgSenderCaller());
        console.log("CalledFirst contract msg.sender: ", caller.msgSenderCalledFirst());
        console.log("CalledLast contract msg.sender: ", calledLast.msgSender()); // <--- this will return the address of the CalledFirst contract
    }
}
