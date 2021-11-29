/* 
  🔧 Exercice - PullPayment
Les attaques les plus connues sur Ethereum
Favoriser la méthode PullPayment (pull over push)
Pour éviter les problèmes du gas et les potentiels attaques pour dérober des fonds, il est fortement conseillé d’utiliser la méthode PullPayment. Cette méthode va permettre aux utilisateurs de demander (pull) des fonds indépendamment du reste de la logique du contrat grâce à une fonction appelée.

🔍 Si nous prenons l’exemple de la levée des fonds: 

* Un investisseur transfert des ethers au contrat (push)
* Lors du remboursement, il peut retirer ses ethers (pull) 
 

Exercice - PullPayment :

Ecrire un smart contract qui permet de mettre en pratique la méthode PullPayment. Soyez vigilant à la sécurité et l’optimisation de votre smart contract. 
 */

pragma solidity 0.8.7;

contract auction {
    address highestBidder;
    uint highestBid;
    mapping(address => uint) refunds;

    function bid() payable external {
        require(msg.value >= highestBid);

        if (highestBidder != address(0)) {
            refunds[highestBidder] += highestBid; // record the refund that this user can claim
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdrawRefund() external {
        uint refund = refunds[msg.sender];
        refunds[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value:refund}("");
        require(success);
    }
}
