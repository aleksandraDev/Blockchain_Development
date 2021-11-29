/* 
  Timestamp Dependence
Il y a trois considérations principales lorsqu'on utilise un timestamp pour exécuter une fonction critique d'un contrat, en particulier lorsque les actions impliquent un transfert de fonds.


📌Manipulation Timestamp 
Il faut savoir que le timestamp d’un bloc peut être manipulé par un mineur.  

Lorsque le contrat utilise un timestamp pour l'encodage d'un nombre aléatoire, le mineur peut choisir un timestamp dans les 15 secondes suivant la validation du bloc, ce qui lui permet de pré-calculer une option plus favorable à ses chances à la loterie. Les timestamps ne sont pas aléatoires et ne doivent pas être utilisés dans ce contexte.

 
📌La règle des 15 secondes
Les implémentations populaires du protocole Ethereum Geth et Parity rejettent les blocs avec un timestamp de plus de 15 secondes. Par conséquent, une bonne règle pour évaluer l'utilisation du timestamp est :

⚡ Si le temps de votre événement peut varier de 15 secondes, il est possible d'utiliser block.timestamp.

 
📌Evitez l’utilisation de block.number comme un timestamp
C’est possible d’estimer un timestamp à l’aide du block.number, mais ce n’est pas une preuve car le protocol peut changer.

Dans une vente qui s'étend sur plusieurs jours, la règle des 15 secondes permet d'obtenir une estimation plus fiable du temps.


 */