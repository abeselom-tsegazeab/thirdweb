// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Insert, update , read from array of structs

contract TodoList {
     struct Todo {
            string text;
            bool completed;
        }

     Todo[] public  todos;

   function create(string calldata _text) external {
        todos.push(Todo({
            text:_text,
            completed:false
        }));
     }

       function updateText(uint _index,string calldata _text) external {
        todos[_index].text = _text; // iff we only  have one struct element to be updated this saves gas 

        // Todo storage todo = todos[_index]; // if we have multiple fields this is cheaper
        // todo.text = _text;
    }

     function get(uint _index) external view returns(string memory,bool) {
        Todo storage todo = todos[_index];
        return (todo.text,todo.completed);
    }

      function toggle(uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }

}