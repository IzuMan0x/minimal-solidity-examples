// SDPX-License-Identifier: MIT

pragma solidity 0.8.24;

// For simplicity a merkle tree is an array of length 2^n so the leaves are always balanced, if not it will increase the complexity
// For example:
// Tree base is 2^2
// [item1, item2, item3, item4]
// [hash1, hash2, hash3, hash4]
//    \     /       \     /
//     \   /         \   /
//     [hash12]      [hash34]
//        \            /
//         \          /
//          \        /
//    [hashof(hash12 + hash34)] <---- also known as the root hash

//So in the above example to prove that item 1 is aprt of the tree we need:
// 1. The value of item1
// 2. The index of item1
// 3. The hash or value of item2
// 4. The root hash

contract MerkleTree {
    // note the proof has to be correctly formatted
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf, uint256 index) public pure returns (bool) {
        bytes32 computedHash = leaf;

        // re-compute the root hash
        for (uint256 i; i < proof.length; i++) {
            if (index % 2 == 0) {
                computedHash = keccak256(abi.encodePacked(computedHash, proof[i]));
            } else {
                computedHash = keccak256(abi.encodePacked(proof[i], computedHash));
            }
            index = index / 2;
        }

        return computedHash == root;
    }
}

contract TestMerkleProof is MerkleTree {
    bytes32[] public hashes;

    constructor() {
        string[4] memory transactions = ["alice -> bob", "bob -> dave", "carol -> alice", "dave -> bob"];

        for (uint256 i = 0; i < transactions.length; i++) {
            hashes.push(keccak256(abi.encodePacked(transactions[i])));
        }

        uint256 n = transactions.length;
        uint256 offset = 0;

        while (n > 0) {
            for (uint256 i = 0; i < n - 1; i += 2) {
                hashes.push(keccak256(abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])));
            }
            offset += n;
            n = n / 2;
        }
    }

    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }

    /* verify
    3rd leaf
    0xdca3326ad7e8121bf9cf9c12333e6b2271abe823ec9edfe42f813b1e768fa57b

    root
    0xcc086fcc038189b4641db2cc4f1de3bb132aefbd65d510d817591550937818c7

    index
    2

    proof
    0x8da9e1c820f9dbd1589fd6585872bc1063588625729e7ab0797cfc63a00bd950
    0x995788ffc103b987ad50f5e5707fd094419eb12d9552cc423bd0cd86a3861433
    */
}
