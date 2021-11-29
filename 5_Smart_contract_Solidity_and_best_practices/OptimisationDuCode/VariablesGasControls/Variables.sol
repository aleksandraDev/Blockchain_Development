/* 
Variables

Optimisation du code Solidity
Sur Ethereum, le gas est un droit d'exécution utilisé pour compenser les mineurs pour les ressources informatiques nécessaires pour alimenter les smart contracts. 

Un nouveau mode de raisonnement est alors nécessaire pour les développeurs qui doivent prêter une attention méticuleuse au gas dépensé par leurs smart contracts, ainsi que pour les outils d'optimisation qui doivent être capables de réduire efficacement le gas requis par les smart contracts. Des recherches sont en cours sur cette question qui essayent d’apporter des bonnes méthodes et faciliter la vie aux développeurs. 

👉 Dans cette section, nous allons explorer quelques bonnes pratiques qui vont vous permettre d’optimiser un minimum. 

 

Regroupement des variables 
Les smart contrats solidity comportent des emplacements contigus de 32 octets (256 bits) utilisés pour le stockage. Lorsque nous arrangeons les variables de manière à ce que plusieurs d'entre elles tiennent dans un seul emplacement, on parle de “variable packing”.

 Comme chaque emplacement de stockage coûte du gas, le regroupement des variables nous aide à optimiser notre utilisation du gas en réduisant le nombre d'emplacements requis par notre contrat.

Exemple : 
*/

// bad
uint128 a;
uint256 b;
uint128 c;
 
//good
uint128 a;
uint128 c;
uint256 b;
 