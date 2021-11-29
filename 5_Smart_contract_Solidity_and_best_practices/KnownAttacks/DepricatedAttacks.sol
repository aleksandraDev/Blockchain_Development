/* 
  Attaques dépréciées
Les attaques les plus connues sur Ethereum

Appel à l’inconnu - Call to the unknown

Quelques appels aux fonctions en solidity ou le transfert d’Ethers, peuvent avoir un effet secondaire en appelant la fonction “fallback” de n’importe quel contrat. 

🔍 Nous illustrons quelques cas ci dessous : 

* call permet d’exécuter une fonction spécifique de n’importe quel contrat et envoie des Ethers. 
address(c).call{value: _amount}(abi.encodePacked("ping(uint256)",n));
c est le contrat destinataire (qui doit recevoir les Ethers et exécuter la fonction ping

Ping est la fonction appelée (identifiée grâce aux premiers 4 bytes de son hash)

_amount détermine combien de wei seront transférés au contrat c n est l’input de la fonction qu’on appelle ping


Remarque :
Si la fonction appelée n’existe pas dans le contrat alors la fonction de fallback est exécutée. Il est donc possible de détourner ce mécanisme de deux manières différentes:
 
1. soit la fonction de fallback d’une cible est compromise et envoie par exemple des ether à l’utilisateur appelant la fonction (mécanisme destiné à éviter une perte de fonds).
2. soit la fonction de fallback de l’attaquant est intrusive pour l’utilisateur qui l’appelle auquel cas, l’attaquant cherche à ce que les utilisateurs appellent une fonction qui n’existe pas dans son contrat.

* delegatecall a un fonctionnement similaire à call sauf que c’est le propriétaire de la fonction appelée qui va être considéré comme l’exécutant.
  address(c).delegatecall(abi.encodePacked("ping(uint256)",n))
⚠️ Si la fonction “ping” contient la variable this, elle représente alors l’address de l’exécutant et non pas le contrat c. 
Dans le cas d’un transfert d’Ether vers un destinataire d, à l’aide de d.send(amount), les Ethers sont débités de la balance part de l’exécutant.
Il était donc possible de faire payer un tiers à sa place grâce à cette fonction delegatecall qui appelait la fonction .send(amount) dans l’environnement du tiers.
Ces deux vulnérabilités ne sont plus exploitables actuellement, en effet elles datent des débuts de Ethereum.
* send est utilisée pour faire des transferts des Ethers de la part du contrat vers un destinataire d, à l’aide de d.send(amount). 
Après le transfert des ethers, send exécute la fonction fallback du destinataire. D’autres vulnérabilités liées à send seront détaillées dans les sections qui suivent “exception disorders” et “gasless send”.
 */