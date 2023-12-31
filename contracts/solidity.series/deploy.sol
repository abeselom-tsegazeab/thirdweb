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
    function setXandRecieveEther(address _test, uint256 _x) external payable {
        TestContract(_test).setXandRecieveEther{value: msg.value}(_x);
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

contract TestDelegateCall {
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall {
    // if you want to update the state of deployed contract using delegate call the state variables must be similar in type  and identifier , also the order matters here.
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(address _test, uint256 _num) external payable {
        // _test.delegatecall(abi.encodeWithSignature("setVars(uint256)", _num));
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        );

        require(success, "Delegate Call Failed");
    }
}

// ways to create a contract from another contract

contract Account {
    address public bank;
    address public owner;

    constructor(address _owner) payable {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory {
    Account[] public accounts;

    function createAccount(address _owner) external payable {
        Account first = new Account{value: 111}(_owner); // this sends ether to the constructor of the contract
        accounts.push(first);
    }
}

// library

library Math {
    function max(uint256 _x, uint256 _y) internal pure returns (uint256) {
        return _x >= _y ? _x : _y;
    }
}

contract Test {
    function testMax(uint256 x, uint256 y) external pure returns (uint256) {
        return Math.max(x, y);
    }
}

library ArrayLib {
    function find(uint256[] storage unit, uint256 x)
        internal
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < unit.length; i++) {
            if (unit[i] == x) {
                return i;
            }
        }
        revert("Not found");
    }
}

contract TestArray {
    using ArrayLib for uint256[];
    // the above code means add for uint[] type all the functionalities of the given library
    // this also enhances the data type
    uint256[] public array = [3, 2, 1];

    function testFind(uint256 i) external view returns (uint256) {
        // return ArrayLib.find(array,2);
        // or by using the advantage of enhancement that we did above
        return array.find(i);
    }
}

// verify signature

/* 

0. message to sign
1. hash(message)
2. sign(hash(message),private key) | offchain
3. ecrecover(hash(message), signature) == signer
 */

contract VerifySig {
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked((_message)));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    // ("\x19Ethereum Signed Message:\n32", _messageHash)
                )
            );
    }

    function recover(bytes32 _ethSignedMessageHash,bytes memory _sig) public pure returns(address){
        (bytes32 r ,bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(bytes memory _sig)internal pure returns(bytes32 r,bytes32 s,uint8 v){
        require(_sig.length == 65, "Invalid signature length");
    }
}
