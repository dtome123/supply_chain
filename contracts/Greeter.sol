// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22;
contract Greeter {
    string greeting = "Hello";
    function set(string memory _greeting) public {
        greeting = _greeting;
    }
    function get() public view returns (string memory){
        return greeting;
    }
}