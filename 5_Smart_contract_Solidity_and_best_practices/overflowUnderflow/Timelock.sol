// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

contract Timelock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    /**
     * @dev Once uint gets to its max size in octets (2^256), the next element will be brought to zero.
     * if t = actual locktime -> x + t = 2**256 => x + t = 0 -> x = -t
     */
    function increaseLockTime(uint256 _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(
            block.timestamp > lockTime[msg.sender],
            "Lock time not expired"
        );

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "FAiled to send Ether");
    }

    function convert(uint _value)j public pure returns (uint) {
      return uint(- _value);
    }
}
