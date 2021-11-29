/* 
Les contrôles 
Évitez les contrôles répétitifs.

Exemple :
 */

require(balance >= amount);//ce contrôle est redondant car Solidity vérifie les underflow et overflow de manière native.
balance = balance - amount;

// Utiliser les échanges des valeurs sur une seule ligne
// Exemple :

(balance, amount) = (amount, balance);