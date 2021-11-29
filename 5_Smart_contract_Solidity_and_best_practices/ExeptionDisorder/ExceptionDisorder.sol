/* 
  Désordre d’exception - Exception disorder
Vulnérabilités dans les smart contracts
l y a plusieurs situations en Solidity qui relèvent des exceptions: 

plus de gas (run out of gas) 
l’exécution de la fonction atteint ses limites (exceeds gas limit)
les fonctions revert(), require() et assert()
 

📌 Par contre, Solidity n’a pas un traitement uniforme pour les exceptions : on distingue alors deux comportements différents, qui dépendent de la façon dont les smart contracts s'appellent mutuellement. 

Exemple : 
 */

contract Alice {
   function ping(uint) public returns (uint){}
}
contract Bob   {
   uint x = 0;
   function pong(Alice c) public{
       x = 1;
       c.ping(42);
       x = 2;
   }
} 

/* 
1. Supposons qu’un utilisateur exécute la fonction “pong” du smart contract Bob et que la fonction “ping” du smart contract Alice lève une exception. En effet, l’exécution de la fonction stoppe et l’ensemble de la transaction est alors annulée.
Par conséquent, x contient 0 après l’exécution de la transaction. 

2. Maintenant, supposons que Bob invoque le ping via un appel externe du type address(c).call("ping"); . Dans ce cas, seuls les effets secondaires de cette invocation sont annulés, l'appel retourne faux et l'exécution continue. 
Par conséquent, x contient 2 après l’exécution de la transaction. 
 */