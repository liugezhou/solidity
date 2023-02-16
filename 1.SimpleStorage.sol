// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// pragma 告诉编译器如何处理代码的通用指令

contract SimpleStorage {
  // unit为类型，256位无符号整数
  uint storedData;

  function set(uint x) public{
    storedData = x;
  }

  function get() public view returns (uint){
    return storedData;
  }
}