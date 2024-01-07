// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Event {
    event Log(string message, uint256 val);
    // up to 3 index
    event IndexedLog(address indexed sender, uint256 val);

    function example() external {
        emit Log("foo", 1234);
        emit IndexedLog(msg.sender, 700);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata message) external {
        emit Message(msg.sender, _to, message);
    }
}

// Inheritance

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function bar() public pure virtual returns (string memory) {
        return "B";
    }
}

contract B is A {
    function foo() public pure override returns (string memory) {
        return "A";
    }

    function bar() public pure virtual  override returns (string memory) {
        return "B";
    }
}


contract C is B{
     function bar() public pure virtual   override returns (string memory) {
        return "C";
    }
}

contract F is B{
     function bar() public pure virtual   override returns (string memory) {
        return "C";
    }
}

// order of inheritance - most base-lke to  derived
// this means the contract which has least num of contracts it inherits


contract Z is B,C{
  

    function bar() public pure virtual  override(B,C) returns (string memory) {
        return "B";
    }
}


contract S {
    string public name;

    constructor(string memory _name){
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text){
        text = _text;
    }
}

// two ways to initialize a constructor 
// 1. initialilze the arguments at first line manually
// 2. initialize dynamically when initializing the constructor
// 3. in can be a combination of both
contract U is S('S'),T('T'){

}

contract V is S,T{
    constructor(string memory _name,string memory _text) S(_name) T(_text) {

    }
}

// the order of parent constructors execution only depends on inheritance
// in this case 
// S -> T -> VV 
contract VV is S("S"),T {
    constructor(string memory _text) T(_text){
        
    }
}

// calling parent functions 
// - direct
// - super (this calls all parent contracts


