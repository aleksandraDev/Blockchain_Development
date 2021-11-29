/* 
La consommation du “gas” dans les structures 
Pareil ! Le regroupement des variables est important même au niveau des structures. 

Exemple :
 */

 // bad
struct Personne{
  string Nom;
  uint8 Age;
  uint8 Poids;
  address Adresse;
}
// good
struct Personne{
  string Nom;
  uint8 Age;
  address Adresse;
  uint8 Poids;
}

/* 
Initialisation des variables 
Pas besoin d'initialiser les variables avec des valeurs par défaut

Exemple :
 */

uint256 hello = 0; //bad, expensive
uint256 world; //good, cheap

/* 
Messages d’erreurs 
Utilisez des messages d’erreurs courts.

Exemple :
 */

require(balance >= amount, "Insufficient balance"); //good
require(balance >= amount, "To whomsoever it may concern. I am writing this error message to let you know that the amount you are trying to transfer is unfortunately more than your current balance. Perhaps you made a typo or you are just trying to be a hacker boi. In any case, this transaction is going to revert. Please try again with a lower amount. Warm regards, EVM"; //bad