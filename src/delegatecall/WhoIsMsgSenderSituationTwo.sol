// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract Caller {
    address immutable calledFirst;
    address public msgSenderCaller;
    address public msgSenderCalledFirst;
    address public msgSenderCalledLast;

    constructor(address _calledFirst) {
        calledFirst = _calledFirst;
    }

    function delegateCallToFirst() public {
        msgSenderCaller = msg.sender;
        calledFirst.delegatecall(abi.encodeWithSignature("logSender()"));
    }
}

contract CalledFirst {
    event SenderAtCalledFirst(address sender);

    address immutable calledLast;

    uint256 placeHolder = 0;

    address public msgSender;

    constructor(address _calledLast) {
        calledLast = _calledLast;
    }

    function logSender() public {
        msgSender = msg.sender;
        emit SenderAtCalledFirst(msg.sender);
        calledLast.call(abi.encodeWithSignature("logSender()"));
    }
}

contract CalledLast {
    event SenderAtCalledLast(address sender);

    uint256 placeHolder = 0; // These placeHolders are here to maintain the storage layout
    uint256 placeHolder2 = 0;

    address public msgSender;

    function logSender() public {
        msgSender = msg.sender;
        emit SenderAtCalledLast(msg.sender);
    }
}
