/* 
  La fonction Fallback
Les bonnes pratiques Solidity

👉 Simplifier votre fonction fallback 
La fonction fallback est appelé lorsqu’un message sans arguments est envoyé à un contrat ou lorsqu'aucune fonction ne correspond. 
Si vous souhaitez pouvoir recevoir de l'Ether d'un .send() ou d'un .transfer(), tout ce que vous pouvez faire dans une fonction de 
fallback est d'enregistrer un événement et vérifier qu’elle n’est pas appelée par erreur.
 */

 // mauvais
function() payable { balances[msg.sender] += msg.value; }

// bon
function deposit() payable external { balances[msg.sender] += msg.value; }

function() payable { require(msg.data.length == 0); emit LogDepositReceived(msg.sender); }

/* 
  👉 Vérifier les données envoyées avec la fonction fallback
La fonction fallback n'est pas seulement appelée pour les transferts d'Ethers simples (sans données) mais aussi lorsqu'aucune autre fonction ne correspond, 
vous devez vérifier que les données sont vides si la fonction fallback est destinée à être utilisée uniquement pour l'enregistrement des Ethers reçus. 
Sinon, les appelants ne s'en apercevront pas si votre contrat est mal utilisé et si des fonctions qui n'existent pas sont appelées.
 */

 // mauvais
function() payable { emit LogDepositReceived(msg.sender); }

// bon
function() payable { require(msg.data.length == 0); emit LogDepositReceived(msg.sender); }
