// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter {
    uint256 public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }

    function sum(uint256 n) external pure returns (uint256) {
        uint256 s;
        for (uint256 i = 1; i <= n; i++) {
            s += 1;
        }
        return s;
    }

    // default value for boolean is false
    // default value for int and uint is 0
    // default value for address is the zero address (0x000000000000)
    // default value for byte32 is (0x000000000000)

    // three ways to throw an error from a function  are require, revert , and assert
    // when an error is throwed from a function two things happpen gas refund, statte updates are reverted
    // custom error - saves gas

    function testRequire(uint256 i) public pure {
        require(i <= 10, "i > 10");
    }

    function testRevert(uint256 i) public pure {
        if (i > 10) {
            revert("i > 10");
            // revert is bettter option if we have nested code
        }
    }

    uint256 public num = 123;

    function testAssert() public view {
        assert(num == 123);
        // assert checks if a given condition is true
    }

    error MyError(address caller, uint256 i);

    function testCustomError(uint256 e) public view {
        if (e > 10) {
            revert MyError(msg.sender, e);
        }
    }
}

// Function Modifiers  - reuse code before and /or after function
// Basic, Inputs, Sandwich
contract FunctionModifier {
    bool public paused;
    uint256 public count;

    function setPause(bool _paused) external {
        paused = _paused;
    }

    modifier whenNotPaused() {
        require(!paused, "paused");
        _;
    }

    function inc() external whenNotPaused {
        count += 1;
    }

    function dec() external whenNotPaused {
        count -= 1;
    }

    modifier cap(uint256 _x) {
        require(_x < 100, "X >= 100");
        _;
    }

    function incBy(uint256 _x) external whenNotPaused cap(_x) {
        count += _x;
    }
}

// A Constructor is a special function which is called only once when the contract is called
contract Con {
    address public owner;
    uint256 public x;

    constructor(uint256 y) {
        owner = msg.sender;
        x = y;
    }
}

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Owner");
        _;
    }

    function setOwner(address _newOwner) external  onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        owner = _newOwner;
    }

// Function Outputs
    // Return multiple outputs
    // Named Outputs
    // Destructuring Assignment


}
contract FunctionOutputs{
        function returnMany() public  pure returns(uint,bool){
            return(1,true);
        }
        function named()public pure returns (uint x,bool b){
            return(1,true);
        }
         function assigned()public pure returns (uint x,bool b){
            x = 1;
            b = true;
        } 

        // function destructuringAssignments()public  pure{
        //    (uint x, bool b) = returnMany();
        //    (, bool _b) = returnMany(); // if we want the second one but not the first
        // }
    }

// Arrays - dynamic or fixed
// Initialization
// Insert(push),get,update,delete,pop,length
// Creating array in memory
// Returning array from function

contract Array{
    uint[] public nums = [1,2,3,4];
    uint[3] public  numsFixed = [4,5,6];

    function examples() external {
        nums.push(4);
        // uint x = nums[1] ;// to get an element
        nums[2] = 7;
        delete nums[3]; // [1,2,3,0] when deleted it will reset / default back to zero
        nums.pop(); // remove the last element
        nums.length;

        // create array in memory
        // push and pop are not available for array created in memory
        uint[] memory a = new uint[](5); // array in memory must be fixed 
       a[1] = 1;
    }

    function returnArray() external  view returns (uint[] memory){
        return nums;
        // this function copy nums into memory and return it 
        // returning array from a function is not recommended (it uses a lot of gas, like big loops)
    }
}

contract ArrayShift{
    uint[] public plane;
    function example() public  {
        plane = [1,2,3];
        delete plane[1]; // [1,0,3]
    }

    function remove(uint _index) public {
        require(_index < plane.length,"Index out of bound");
        for(uint i = _index;i< plane.length -1 ; i++){
            plane[i] = plane[i + 1];
        }
        plane.pop();
    }
}

contract ArrayReplaceLast{
    uint[] public array;
    function replace(uint _index) public{
        array[_index] = array[array.length - 1];
        array.pop();
    }
    function test() external returns(uint[] memory){
        array = [1,2,3,4,5];
        replace(1);
        return(array);
    }
}
// Mapping 
// simple and nested declaration
// set,get,delete
contract Mapping{
    mapping(address => uint) public balances;// simple mapping
    mapping (address =>mapping (address=>bool))public  isFriend; // nested mapping
   function example() external {
    balances[msg.sender] = 123;
    // uint bal = balances[msg.sender];
    // uint bal2 = balances[address(1)];
    balances[msg.sender] += 456;
    delete balances[msg.sender];
    isFriend[msg.sender][address(this)] = true;
   }
}

// Iterable Mapping
contract IterableMapping{
    mapping (address => uint) public balances;
    mapping (address => bool) public  inserted;
    address[] public keys;

    function set(address _key,uint _val) external {
        balances[_key] = _val;

        if(!inserted[_key]){
            inserted[_key]= true;
            keys.push(_key);
        }
    }

    function getSize()external view returns(uint){
        return keys.length;
    }

    function first() external  view returns (uint){
        return balances[keys[0]];
    }
}

contract Structs{
    struct Car{
        string model;
        uint year;
        address owner;
    }
    Car public car;
    Car[] public cars;
    function examples()external {
        Car memory toyota = Car("Toyota",1900,msg.sender);
        Car memory lambo = Car({year:1980,model:"Lamborghini",owner:msg.sender});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2000;
        tesla.owner = msg.sender;
        
        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        cars.push(Car("Ferrari",2020,msg.sender));
         
    }


}

contract Enum {
    enum Status{
        None,
        Pending,
        Shiped,
        Completed,
        Rejectedd,
        Cancealed
    }

    Status public status;

    struct Order{
        address buyer;
        Status status;
    }

    Order[] public orders;

    function get() public  view returns(Status){
        return status;
    }

    function set(Status _status) external {
        status = _status;
    }

    function ship()external {
        status = Status.Shiped;
    }

    function reset() external {
        delete status;
         // this will reset to the defaul value, in this case the default value for an enum is the first value provided
    }
}