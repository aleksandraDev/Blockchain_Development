// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

contract Wallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    function transfer(address payable _to, uint256 _amount) public payable {
        require(tx.origin == owner, "Not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Fail to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
