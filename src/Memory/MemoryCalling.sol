// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract MemoryCounter {
    uint256 public count;

    function increment() public returns (uint256) {
        count += 1;
        return count;
    }
}

contract YulCall {
    function yulCall(address contractAddress, bytes calldata data) external returns (bytes memory) {
        assembly {
            //load free memory pointer
            let p := mload(0x40)
            // copy calldata to memory
            calldatacopy(p, data.offset, data.length) //calldatacopy(p, start, size)
            // Call counter or any other function
            let ok := call(gas(), contractAddress, 0, p, data.length, 0, 0) //call (gas, address, value, inOffset, inSize, retOffset, retSize)
            // Revert if call is not successful <--- ok will be a zero or a one
            if iszero(ok) { revert(0, 0) }
            // Get return data size
            let return_data_size := returndatasize()
            // return data as ABI encoded bytes
            // - Store offset
            mstore(p, 0x20)
            // - store length
            mstore(add(p, 0x20), return_data_size)
            // - copy data from return data
            returndatacopy(add(p, 0x40), 0, return_data_size)
            // - Return data
            return(p, add(0x40, return_data_size))
        }
    }
}

contract TestHelper {
    function testIncrement(address yulCall, address counter) public returns (uint256 count) {
        bytes memory result = YulCall(yulCall).yulCall(counter, abi.encodeCall(MemoryCounter.increment, ()));
        count = abi.decode(result, (uint256));
    }
}
