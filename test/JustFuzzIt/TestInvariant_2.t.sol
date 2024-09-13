//SPDX-License-Identifier: MIT
// Topics are:
// - handler based testing - test function under teh specific conditions
// - target contracts
// - target selectors

import {Test, console} from "forge-std/Test.sol";
import {WETH9} from "src/JustFuzzIt/WETH9.sol";

contract Handler is Test {
    WETH9 private weth;
    uint256 public ethBalance;

    constructor(WETH9 _weth) {
        weth = _weth;
    }

    receive() external payable {}

    function deposit(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        ethBalance += amount;
        weth.deposit{value: amount}();
    }

    function withdraw(uint256 amount) public {
        amount = bound(amount, 0, weth.balanceOf(address(this)));
        ethBalance -= amount;
        weth.withdraw(amount);
    }

    function sendToFallback(uint256 amount) public {
        amount = bound(amount, 0, address(this).balance);
        ethBalance += amount;
        (bool success, bytes memory data) = address(weth).call{value: amount}("");
        require(success, "Send to Fallback Failed");
    }

    function willAlwaysFail() public {
        // This is just here to determine if targetSelector() works
        revert("Failed");
    }
}

contract WETH9_Handler_Base_InvariantTest is Test {
    Handler handler;
    WETH9 weth;

    function setUp() public {
        weth = new WETH9();
        handler = new Handler(weth);
        deal(address(handler), 100e18);
        targetContract(address(handler)); // This targets the Handler contract for invariant testing to

        // You can also target specific selectors
        bytes4[] memory selectors = new bytes4[](3);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendToFallback.selector;
        targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
    }

    function invariant_eth_balance() public {
        assertGe(address(weth).balance, handler.ethBalance());
    }
}
