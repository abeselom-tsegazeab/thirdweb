// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestContract1 {
    address public owner = msg.sender;

    function setOwner(address _owner) public {
        require(msg.sender == owner, "Not owner");
        owner = _owner;
    }
}

contract TestContract2 {
    address public owner = msg.sender;
    uint256 public value = msg.value;
    uint256 public x;
    uint256 public y;

    constructor(uint256 _x, uint256 _y) payable {
        x = _x;
        y = _y;
    }
}

// contract Proxy {
//     event Deploy(address);

//     fallback() external payable {}

//     function deploy(bytes memory _code)
//         external
//         payable
//         returns (address addr)
//     {
//         assembly {
//             // create(v,p,n)
//             // v = amount of ETH to send
//             // p = pointer in memory to start of code
//             // n = size of the code
//             addr := create(callvalue(), add(_code, 0x20), mload(_code))
//         }
//         require(addr != address(0), "Deploy failed");

//         emit Deploy(addr);
//     }

//     function execute(address _target, bytes memory _data) external payable {
//         (bool success, ) = _target.call{value: msg.value}(_data);
//         require(success, "failed");
//     }
// }


 