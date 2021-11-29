/* 
  Stockage de données dans les événements
Les données qui n'ont pas besoin d'être accessibles sur la Blockchain peuvent être stockées dans les événements pour économiser du gas.

Bien que cette technique puisse fonctionner, elle n'est pas recommandée - les événements ne sont pas destinés au stockage de données. Si les données dont nous avons besoin sont stockées dans un événement émis il y a longtemps, leur récupération peut prendre du temps en raison du nombre de blocs à rechercher.
 

storage vs memory
Il existe deux possibilités pour stocker des variables dans Solidity, à savoir storage (stockage) et memory (mémoire): 

Les variables « storage » sont stockées définitivement dans la blockchain
Les variables « memory » sont temporaires et effacées entre les appels externes de fonction. 
👉 Un moyen courant de réduire le nombre d'opérations de stockage consiste à manipuler une variable de mémoire locale avant de l'affecter à une variable de stockage.

Exemple :
 */

uint256 return = 5; // assume 2 decimal places
uint256 totalReturn;

function updateTotalReturn(uint256 timesteps) external {
  uint256 r = totalReturn || 1;
  for (uint256 i = 0; i < timesteps; i++) {
    r = r * return;
  }
  totalReturn = r;
}