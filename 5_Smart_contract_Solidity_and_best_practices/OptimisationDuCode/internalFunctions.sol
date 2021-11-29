/* 
Fonctions internes
Optimisation du code Solidity
Dans un smart contract, l’appel aux fonctions internes est moins coûteux que l’appel aux fonctions publiques. Lors de l’appel d’une fonction publique, tous les paramètres sont à nouveau copiés en mémoire et transmis à cette fonction. En revanche, lors de l’appel d’une fonction interne, les références de ces paramètres sont transmises et elles ne sont pas recopiées en mémoire. 

 */