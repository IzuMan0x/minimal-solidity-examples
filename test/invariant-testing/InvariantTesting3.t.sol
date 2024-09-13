// SPDX-License-Identifier:MIT

pragma solidity 0.8.24;

//for invariant testing
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Test} from "forge-std/Test.sol";

//other imports
import {WETH9} from "./WETH9.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
    WETH9 private weth;

    // We will declare a state variable to keep track of the amount of Ether deposited
    uint256 public wethBalance;

    constructor(WETH9 _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function sendToFallback(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        (bool success,) = address(weth).call{value: amount}("");
        require(success, "Call Failed");
    }

    function deposit(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        wethBalance += amount;
        weth.deposit{value: amount}();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        wethBalance -= amount;
        weth.withdraw(amount);
    }

    /* function fail() public {
        revert("failed"); // this is verify that the targetSelector is working
    }
    */
}

contract WETH9_Invariant_BaseHandler_Test is Test {
    WETH9 public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH9();
        handler = new Handler(weth);

        deal(address(handler), 100e18);
        // we need to tell Foundry to target only the handler function
        targetContract(address(handler));
        // to target specific functions
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;

        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_EtherBalance() public {
        assertGe(address(weth).balance, handler.wethBalance());
    }
}
