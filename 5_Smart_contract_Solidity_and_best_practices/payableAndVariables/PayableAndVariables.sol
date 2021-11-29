/* 
  Marquer explicitement les fonctions payables et les variables
Les bonnes pratiques Solidity
Il faut marquer explicitement la visibilité des fonctions et des variables. Les fonctions peuvent être déclarées comme external, public, internal or private. 

* External ce sont les fonctions qui font parties de l’interface du contrat. Une fonction externe f ne peut pas être appelée en interne 
(e.g. f() ne fonctionne pas, par contre, this.f() fonctionne).
Les fonctions externes sont parfois plus efficaces lorsqu’elles reçoivent des tableaux de données larges. 
* Public ce sont les fonctions et les variables qui peuvent être appelées en interne ou par un call.
Pour les variables publiques un getter, fonction qui permet de récupérer sa valeur, est généré implicitement.
* Internal ce sont les fonctions qui sont accessibles qu’en interne sans utiliser le mot clé “this”.
* Private ce sont les variables qui sont visibles uniquement dans le contrat dans lequel elles sont définies et pas dans les contrats dérivés.
 */

 // mauvais
uint x; // the default is internal for state variables, but it should be made explicit
function buy() { // the default is public
    // public code
}

// bon
uint private y;
function buy() external {
    // only callable externally or using this.buy()
}

function utility() public {
    // callable externally, as well as internally: changing this code requires thinking about both cases.
}

function internalAction() internal {
    // internal code
}

// Depuis la version Solidity 0.4.0, chaque fonction qui reçoit des Ethers doit utiliser le modifier payable. Sinon, si la transaction a msg.value > 0 elle échouera.


/* 
Verrouiller pragma à une version de compilateur précise 
Les contrats doivent être déployés avec la même version du compilateur et les mêmes indicateurs que ceux avec lesquels ils ont été testés. 
Verrouiller le pragma permet de s'assurer que les contrats ne sont pas accidentellement déployés en utilisant, par exemple, 
le compilateur le plus récent qui peut présenter des risques plus élevés de bugs non encore découverts. 
 */

 // Mauvais
pragma solidity ^0.4.4;
// Bon
pragma solidity 0.4.4;
