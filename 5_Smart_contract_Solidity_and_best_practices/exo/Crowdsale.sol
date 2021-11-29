pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
 
contract Crowdsale is Owneable { 
   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
 
   // Initialization
   constructor(address _escrow) {
       owner = msg.sender;
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH
   receive() external payable {
      require(msg.sender != escrow);
      require(msg.value > 0);
      balances[msg.sender] += msg.value;
      savedBalance += msg.value;
      payable(escrow).transfer(msg.value);
   }
  
   // refund investisor
   function withdrawPayments() public {
      address payee = msg.sender;
      uint256 payment = balances[payee];
      require(payment > 0);
      require(savedBalance >= payment);
      savedBalance -= payment;
      balances[payee] = 0;

      payable(payee).transfer(payment);
   }
}