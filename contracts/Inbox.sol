// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract Inbox{
    string public welcome = "hello world";
    string public greet = 'greeting';
    function sayHi(string calldata _name) public pure  returns (string memory){
        return _name; 

    }
}