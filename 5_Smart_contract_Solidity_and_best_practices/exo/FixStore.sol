// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

contract FixStore {
  mapping(address => uint)  public safes;

  function store() payable public {
    safes[msg.sender] += msg.value;
  }

  function take() public {
    payable(msg.sender).transfer(safes[msg.sender]);
    safes[msg.sender] = 0;
  }
}