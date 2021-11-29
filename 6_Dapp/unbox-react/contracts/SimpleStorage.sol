// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract SimpleStorage {
  uint storedData;
  event StoredValue(uint v);

  function set(uint x) public {
    storedData = x;
    emit StoredValue(storedData);
  }

  function get() public view returns (uint) {
    return storedData;
  }
}
