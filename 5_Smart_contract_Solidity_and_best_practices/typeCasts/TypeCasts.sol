/* 
  Conversions de types - Type Casts
Vulnérabilités dans les smart contracts
Le compilateur Solidity peut détecter quelques erreurs de type comme l’affectation d’un entier à une variable de type string. Les types sont aussi utilisés dans les appels directs: en effet, l'appelant doit déclarer l'interface de l'interlocuteur et lui attribuer l'adresse de l'interlocuteur lorsqu'il effectue l'appel. 

Exemple, reprenons l'appel direct à ping :
 */

contract Alice {
    function ping(uint256) public returns (uint256) {}
}

contract Bob {
    uint256 x = 0;

    function pong(Alice c) public {
        x = 1;
        c.ping(42);
        x = 2;
    }
}

/* 
  La signature de “pong” informe le compilateur que c adhère à l'interface Alice. Cependant, le compilateur vérifie seulement si l'interface déclare la fonction ping, par contre, ne vérifie pas que: 

c est l'adresse du contrat Alice
l'interface déclarée par Bob correspond à l'interface réelle d'Alice.
 

👉 Par conséquent, en cas d'inadéquation de type, trois choses différentes peuvent se produire au moment de l'exécution :

* si c n'est pas une adresse de contrat, l'appel retourne une erreur sans exécuter aucun code.
* si c est l'adresse d'un contrat ayant une fonction avec la même signature comme le ping d'Alice, alors cette fonction est exécutée.
* si c est un contrat sans fonction correspondant à la signature du ping d'Alice, alors la fonction fallback de c est exécutée.
Dans tous les cas, aucune exception n'est levée et l'appelant n'est pas au courant de l'erreur.

💡 À partir de la version 0.4.0 du compilateur Solidity, une exception est levée si l’adresse invoquée n’est associée à aucun code.
Pour plus d’informations sur ces vulnérabilités, vous pouvez lire ce papier de recherche datant de 2017. Il reste pertinent malgré son ancienneté !

https://eprint.iacr.org/2016/1007.pdf
 */
