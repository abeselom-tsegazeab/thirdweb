// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract Inbox{
    string public welcome = "hello world";
    string public greet = 'greeting';
    function sayHi(string calldata _name) public pure  returns (string memory){
        return _name; 
    }

    function forGit(string calldata git) public pure   returns(string memory){
        return git;
    }
}

contract Message {
    string public  text;
    string public greet = 'greeting';

    function sayHello(string calldata _text) public  pure returns (string memory){
        return _text;
    }

    function EditText(string calldata _edited) public  returns(string memory){
        text = _edited;
        return text;
    }
}