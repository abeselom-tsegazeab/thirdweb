// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionIntro {
    uint public state = 12;
    function add (uint x,uint y) external pure returns (uint){
        return x+ y;
    } 

    function sub(uint x,uint y) external  pure  returns (uint){
        return  x - y;
    }

    function viewFunctionsView() external  view returns (uint){
        return state;
    }
    function pureFunctionsNeitherReadNorWrite(uint x, uint y) external  pure returns(uint){
        return x + y;
    }
}