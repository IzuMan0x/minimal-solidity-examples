pragma solidity 0.8.24;

//for invariant testing
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Test} from "forge-std/Test.sol";
import {Handler} from "./InvariantTesting3.t.sol";

//other imports
import {WETH9} from "./WETH9.sol";

contract ActorManager is CommonBase, StdCheats, StdUtils {
    Handler[] public handlers;

    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    function sendToFallback(uint256 handlerIndex, uint256 amount) public {
        handlerIndex = bound(handlerIndex, 0, handlers.length);
        handlers[handlerIndex].sendToFallback(amount);
    }

    function deposit(uint256 handlerIndex, uint256 amount) public {
        handlerIndex = bound(handlerIndex, 0, handlers.length);
        handlers[handlerIndex].deposit(amount);
    }

    function withdraw(uint256 handlerIndex, uint256 amount) public {
        handlerIndex = bound(handlerIndex, 0, handlers.length);
        handlers[handlerIndex].withdraw(amount);
    }
}

contract WETH9_MultiHandler_Invariant_Test is Test {
    WETH9 public weth;
    ActorManager public manager;
    Handler[] public handlers;

    function setUp() public {
        weth = new WETH9();

        for (uint256 i = 0; i < 3; i++) {
            handlers.push(new Handler(weth));
            //deal each handler some ether
            deal(address(handlers[i]), 100 ether);
        }

        manager = new ActorManager(handlers);

        targetContract(address(manager));
    }

    function invariant_Eth_Balance_Actor_Management() public {
        uint256 total = 0;
        for (uint256 i = 0; i < handlers.length - 1; i++) {
            total += handlers[i].wethBalance();
        }

        assertGe(address(weth).balance, total);
    }
}
