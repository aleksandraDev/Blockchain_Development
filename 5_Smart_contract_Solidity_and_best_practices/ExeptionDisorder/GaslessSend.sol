/* 
  Envoi sans gas - Gasless send
Vulnérabilités dans les smart contracts
Lors de l’utilisation de la fonction “send” pour un transfert d’Ethers à un smart contract, une exception out-of-gas peut être relevée. 

Exemple :  

Nous allons illustrer le comportement de “send” à l’aide d’un exemple, en utilisant le contrat C qui va envoyer des Ethers via la fonction pay, et deux destinataires D1 et D2. Nous utiliserons la variable “montant” pour indiquer le montant à envoyer et la variable “destinataire” pour indiquer le destinataire.
 */

 contract C {
   function pay(uint montant, address payable destinataire) public {
       destinataire.send(montant);
   }
}
contract D1 {   
   uint public count = 0;  
   fallback() external{
       count++;
   }
}
contract D2 {
   fallback() external{}
} 

/* 
* montant != 0 et destinataire = D1
  le send dans C échoue avec l’exception out-of-gas, parce que 2300 unités de gas ( dans les versions < 0.4.0, gas = 0 si quantité = 0, sinon gas = 2300. Dans les versions ≥ 0.4.0, gas = 2300) ne sont pas assez pour exécuter la mise à jour de l’état de la fonction fallback du destinataire D1.
* montant != 0 et destinataire = D2 
Le send dans C passe, car les 2300 unités de gas sont assez pour exécuter le fallback de D2 (qui est vide).
 * montant = 0 et destinataire ∈ {D1, D2} 
Pour les versions < 0.4.0, le send dans C échoue avec l’exception out-of-gas. Pour les versions ≥ 0.4.0, le comportement est le même que les deux cas précédents (ça dépend si le destinataire est D1 ou D2). 
 */