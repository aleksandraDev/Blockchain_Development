/* 
  Déni de service - DOS (Deny-of-Service)
Les attaques les plus connues sur Ethereum
Déni de service avec une exception inattendue 

Exemple 1 :  un simple contrat de vente aux enchères
 */

pragma solidity 0.8.7;

// INSECURE
contract Auction {
    address currentLeader;
    uint256 highestBid;

    function bid() public payable {
        require(msg.value > highestBid);

        require(payable(currentLeader).send(highestBid)); // Refund the old leader, if it fails then revert

        currentLeader = msg.sender;
        highestBid = msg.value;
    }
}

/* 
  Si l'attaquant enchérit en utilisant un smart contract qui a une fonction fallback qui annule tout paiement, 
  l'attaquant peut gagner n'importe quelle enchère. Lorsqu'il essaie de rembourser le précédent leader, 
  il revient en arrière si le remboursement échoue. Cela signifie qu'un enchérisseur malveillant peut devenir le leader en s'assurant que 
  tout remboursement à son address échouera toujours en devenant leader via un smart contract qui rejette un paiement.

Exemple 2 : un simple smart contract pour payer des utilisateurs
 */

pragma solidity 0.8.7;

contract Refund {
   address[] private refundAddresses;
   mapping (address => uint) public refunds;
   
   // Mauvais
   function refundAll() public {
      for(uint x; x < refundAddresses.length; x++) {               
          require(payable(refundAddresses[x]).send(refunds[refundAddresses[x]]));
      }
   }
}


/* 
  Il est courant de vouloir s'assurer que chaque paiement réussisse. Si ce n'est pas le cas, il faut revenir en arrière. 

Le problème est que si un appel échoue, vous retournez tout le système de paiement, ce qui signifie que la boucle ne sera jamais terminée. 
Personne n'est payé parce qu'une address impose une erreur.

✔️ La solution recommandée est de favoriser les paiements "pull over push".

Déni de service avec la limite en gas du bloc
Chaque bloc a une limite de gas qui peut être dépensée. Si le gas dépensé dépasse cette limite, la transaction échoue. 
Cela conduit à différents déni de service possibles (DoS). Nous allons aborder les deux DoS les plus connus dans la section qui suit : 

1. DoS sur un smart contract par le biais d'opérations sans limite (d’une boucle infinie)
Si nous reprenons l’exemple précédent du simple smart contract pour payer des utilisateurs, en payant à tout le monde à la fois (en parcourant le tableau 
refundAddresses), vous risquez d'atteindre la limite de gas en bloc.

2. DoS sur le réseau par remplissage des blocs
Même si votre smart contract ne contient pas de boucle infinie, un attaquant peut empêcher d'autres transactions d'être incluses dans la blockchain en plaçant 
des transactions à forte intensité de calcul avec un prix de gas suffisamment élevé.
Pour ce faire, l'attaquant peut émettre plusieurs transactions qui consommeront la totalité du gas disponible pour ce bloc, avec un prix 
par unité de gas suffisamment élevé pour qu’elles soient incluses dès que le bloc suivant sera extrait.
Une attaque de remplissage de bloc (Block Stuffing) peut être utilisée sur n'importe quel smart contract nécessitant une action dans un certain délai.

💡 Cependant, comme pour toute attaque, elle n'est rentable que lorsque la récompense attendue dépasse son coût. Le coût de cette attaque est directement 
proportionnel au nombre de blocs qu'il faut remplir.
 */