/* 
  Appels externes / assert(), require() / modifiers
Les bonnes pratiques Solidity
Vous retrouverez l’ensemble des points ci-dessous dans les recommandations de Consensys, référence dans la sécurité des smart contracts.

1. Appels externes
Soyez prudent lorsque vous effectuez des appels externes
Les appels à des smart contracts non fiables peuvent présenter plusieurs risques ou erreurs inattendus. 
Les appels externes peuvent exécuter un code malveillant dans ce smart contract ou dans tout autre smart contract dont il dépend.

2. Par conséquent, chaque appel externe devrait être traité comme un risque potentiel pour la sécurité.
Eviter les changements d'état après des appels externes
Quelque soit le type d’appel address.call() ou contract.method(), il faut éviter les changements d’état après les appels externes dans une fonction. 
Ces failles, peuvent être exploitées par des smart contract malveillant pour faire des attaques de réentrance.

3. Eviter  .transfer() et .send()
.transfer() et .send() transfèrent exactement 2300 unités de gas au destinataire. 
L'objectif de cette allocation de gas codée en dur était de prévenir les vulnérabilités de réentrance, 
mais cela n'a de sens que dans l'hypothèse où les coûts du gas sont constants. 
Pour éviter que les choses ne se brisent lorsque les coûts du gas changent à l'avenir, il est préférable d'utiliser .call{value : amount}(“”) à la place. 
Favorisez l'utilisation de la fonction .transfer() car elle gère les exceptions inversement à .send() qui ne lance pas une exception 
(elle renvoie un boolean à la place).
 */


 pragma solidity 0.8.7;

// Mauvais
contract Vulnerable {
    function withdraw(uint256 amount) external {
        // This forwards 2300 gas, which may not be enough if the recipient
        // is a contract and gas costs change.
        payable(msg.sender).transfer(amount);
    }
}

// Bon
contract Fixed {
    function withdraw(uint256 amount) external {
        // This forwards all available gas. Be sure to check the return value!
        (bool success, ) = payable(msg.sender).call{value:amount}("");
        require(success, "Transfer failed.");
    }
}


/* 
4. Gérer les erreurs dans les appels externes
Solidity propose des méthodes d'appel de bas niveau qui fonctionnent sur les adresses ethereum:
address.call(), address.callcode(), address.delegatecall() et address.send().
Ces méthodes de bas niveau ne lancent jamais d'exceptions, mais retournent false si l'appel rencontre une exception. 
Si vous choisissez d'utiliser les méthodes d'appel de bas niveau, assurez-vous de gérer la possibilité que l'appel échoue, en vérifiant la valeur de retour.

Exemple : 
 */

 // mauvais
someAddress.send(55);
someAddress.call{value:55}(""); // this is doubly dangerous, as it will forward all remaining gas and doesn't check for result
someAddress.call{value:100}(bytes4(sha3("deposit()"))); // if deposit throws an exception, the raw call() will only return false and transaction will NOT be reverted

// bon
(bool success, ) = someAddress.call{value:55}("");
if(!success) {
    // handle failure code
}


/* 
5. Ne pas faire un delegatecall vers un code qui n’est pas fiable
La fonction delegatecall() est utilisée pour appeler des fonctions d'autres contrats comme si elles appartenaient au contrat de l'appelant. 
Ainsi, la personne appelée peut changer l'état de l'adresse de l'appelant. Ce n'est pas toujours le cas, néanmoins il faut s’assurer de la fiabilité du code.
Un exemple ci-dessous montre comment l'utilisation de delegatecall peut conduire à la destruction du contrat et à la perte de son solde.
 */

pragma solidity 0.8.9;

contract Destructor
{
    function doWork() external
    {
        selfdestruct(payable(0));
    }
}

contract Worker
{
    function doWork(address _internalWorker) public
    {
        // unsafe
        _internalWorker.delegatecall(abi.encodeWithSignature("doWork()"));
    }
}


/* 
Si Worker.doWork() est appelé avec l'adresse du smart contract Destructor comme argument, le contrat Worker s'autodétruira.

Déléguez l'exécution uniquement aux smart contracts de confiance et jamais à une addresse fournie par l'utilisateur.


Rappelez-vous que l’ETH peut être envoyé de force sur un compte

1. Méfiez-vous d’un code (d’un require) qui vérifie strictement le solde d'un contrat
Un attaquant peut envoyer de force de l'Ether sur n'importe quel compte et cela ne peut être empêché (pas même avec une fonction de fallback qui fait un revert() ).
L'attaquant peut le faire en créant un contrat, en le finançant avec 1 wei, et en invoquant selfdestruct(victimAddress). 
Aucun code n'est invoqué dans victimAddress, donc on ne peut pas l'empêcher. 
De plus, comme les adresses de contrat peuvent être calculées à l'avance, l'Ether peut être envoyé à une adresse avant que le contrat ne soit déployé.


Utiliser les assert(), require()
Les fonctions assert() et require() sont utilisées pour vérifier les conditions et lancer une exception si la condition n'est pas remplie.

* La fonction assert ne doit être utilisée que pour tester les erreurs internes et pour vérifier les changements.
* La fonction require doit être utilisée pour s'assurer que les conditions sont valides telles que: les inputs / les variables d'état du contrat sont remplies, 
  ou pour valider les valeurs de retour des appels à des contrats externes.



Utiliser les modifiers uniquement pour les contrôles

Le code à l'intérieur d'un modifier est généralement exécuté avant le corps de la fonction, donc tout changement d'état ou appel externe violera 
le modèle Checks-Effects-Interactions. De plus, ces instructions peuvent également passer inaperçues pour le développeur, 
car le code du modifier peut être loin de la déclaration de la fonction. 

Exemple, un appel externe dans le modifier peut conduire à l'attaque de reentrancy
 */

pragma solidity 0.8.9;

contract Registry {
    address owner;

    function isVoter(address _addr) external returns(bool) {
        // Code
    }
}

contract Election {
    Registry registry;

    modifier isEligible(address _addr) {
        require(registry.isVoter(_addr));
        _;
    }

    function vote() isEligible(msg.sender) public {
        // Code
    }
}

/* 
Dans ce cas, le contrat de Registry peut faire une attaque de reentrancy en appelant Election.vote() dans isVoter().

⚠️ Attention à l'arrondi avec division par nombre entier
Exemple :

- Mauvais
  uint x = 5 / 2; // Résultat est égal à 2, toutes les divisions entières sont arrondies vers le bas au nombre entier le plus proche

 L'utilisation d'un multiplicateur permet d'éviter l'arrondi à l'entier inférieur, ce multiplicateur doit être pris en compte lorsque vous travaillerez avec x à l'avenir :
 */

 // Bon
uint multiplier = 10;
uint x = (5 * multiplier) / 2;

// A l'avenir, Solidity aura un type de point fixe, ce qui rendra les choses plus faciles.