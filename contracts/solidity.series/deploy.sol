
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

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

contract Payable {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function deposit() external payable {}

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Fallback {
    fallback() external payable {}

    receive() external payable {}
}

contract SendEther {
    constructor() payable {}

    receive() external payable {}

    function sendViaTransfer(address payable _to) external payable {
        _to.transfer(123);
    }

    function sendViaSend(address payable _to) external payable {
        bool sent = _to.send(123);
        require(sent, "Failed t0 send Ether");
    }

    function sendViaCall(address payable _to) external payable {
        (bool success, ) = _to.call{value: 123}("");
        require(success, "Failed");
    }
}

contract EthReciever {
    event Log(uint256 amountt, uint256 gas);

    receive() external payable {
        emit Log(msg.value, gasleft());
    }
}

contract EtherWaller {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw(uint256 _amount) external {
        require(msg.sender == owner, "Caller is not owner");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract callTestContract {
    // the first is to initialize the contract with the address
    function setX(address _test, uint256 _x) external {
        TestContract(_test).setX(_x);
    }

    // or
    // function setX( TestContract _test,uint _x) external {
    //         _test.setX(_x);
    //     }
    function getX(TestContract _test) external view returns (uint256) {
        uint256 x = _test.getX();
        return x;
    }

    // or
    //    function getX(TestContract _test) external view  returns(uint x) {
    //         x =  _test.getX();
    //     }
    function setXandRecieveEther(address _test,uint256 _x) external payable {
       TestContract(_test).setXandRecieveEther{value:msg.value}(_x);
    }
}

contract TestContract {
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) external {
       x = _x;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setXandRecieveEther(uint256 _x) external payable {
        x = _x;
        value = msg.value;
    }

    function getXandRecieveValue() external view returns (uint256, uint256) {
        return (x, value);
    }
}
