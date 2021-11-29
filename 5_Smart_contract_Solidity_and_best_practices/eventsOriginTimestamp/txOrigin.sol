/* 
  ❌ Ne pas utiliser tx.origin
  N'utilisez jamais tx.origin pour une autorisation. En effet, un autre contrat peut avoir une méthode qui appellera votre contrat 
  (où l'utilisateur a des fonds par exemple) et votre contrat autorisera cette transaction car votre adresse est dans tx.origin.

  Example: 
 */

pragma solidity 0.8.7;

contract MyContract {
    address owner;

    function myContract() public {
        owner = msg.sender;
    }

    function sendTo(address receiver, uint256 amount) public {
        require(tx.origin == owner);
        (bool success, ) = receiver.call{value: amount}("");
        require(success);
    }
}

contract AttackingContract {
    MyContract myContract;
    address attacker;

    function attackingContract(address myContractAddress) public {
        myContract = MyContract(myContractAddress);
        attacker = msg.sender;
    }

    fallback() external {
        myContract.sendTo(attacker, msg.sender.balance);
    }
}
/* 
👉  Vous devez utiliser msg.sender pour l'autorisation (si un autre contrat appelle votre contrat msg.sender sera l'adresse du contrat et 
  non l'adresse de l'utilisateur qui a appelé le contrat).

  ⚠️ tx.origin va être supprimé du protocole dans l’avenir.
 */
