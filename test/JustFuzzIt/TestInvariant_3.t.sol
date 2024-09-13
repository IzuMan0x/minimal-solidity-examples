// PSDX-License-Idenitifer: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {WETH9} from "src/JustFuzzIt/WETH9.sol";
import {Handler} from "test/JustFuzzIt/TestInvariant_2.t.sol";

contract ActorManager is Test {
    Handler[] public handlers;

    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    receive() external payable {}

    function deposit(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].deposit(amount);
    }

    function withdraw(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].withdraw(amount);
    }

    function sendToFallback(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].sendToFallback(amount);
    }
}

contract WETH_Multi_Handler_Invariant_Test is Test {
    WETH9 public weth;
    ActorManager manager;
    Handler[] public handlers;

    function setUp() public {
        weth = new WETH9();
        for (uint256 i = 0; i < 3; i++) {
            handlers.push(new Handler(weth));
            deal(address(handlers[i]), 100e18);
        }

        manager = new ActorManager(handlers);

        targetContract(address(manager));
    }

    function invariant_ethBalance() public {
        uint256 total = 0;

        for (uint256 i = 0; i < handlers.length - 1; i++) {
            total += handlers[i].ethBalance();
        }
        console.log("ETH total: ", total);
        assertGe(address(weth).balance, total);
    }
}
