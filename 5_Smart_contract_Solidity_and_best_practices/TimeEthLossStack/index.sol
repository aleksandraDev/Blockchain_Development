/* 
Time constraints / Ether lost / Stack size limit
Vulnérabilités dans les smart contracts
Contraintes de temps - time constraints
Il arrive parfois que les smart contracts utilisent le timestamp du bloc, qui donne la date et l’heure du bloc actuel, pour vérifier une contrainte de temps, voire comme source d'aléa. Sachez que le timestamp du bloc peut être manipulé par le mineur et que toutes les utilisations directes et indirectes du timestamp doivent être envisagées. Vous pouvez trouver plus de détails et quelques recommandations sous la section dédiée (Timestamp Dependence).

 
Ether perdu lors du transfer - Ether lost in transfer
Lors de l'envoi de l’Ethers, il faut spécifier l'adresse du destinataire. Cependant, la plupart des adresses sont orphelines, c'est-à-dire qu'elles ne sont associées à aucun utilisateur ou contrat. Si un Ether est envoyé à une adresse orpheline, il est perdu à jamais. Notez qu'il n'y a pas de moyen direct de détecter si une adresse est orpheline. Comme l'Ether perdu ne peut être récupéré, vous devez vous assurer manuellement de l'exactitude des adresses des destinataires.

De même il peut arriver que des fonds soient envoyés à address(0), c’est à dire 0x00000..00. Les fonds envoyés seront alors perdus, comme vous pouvez le constater ici. Il est recommandé que l'interface ou le contrat (mais cela a un coût supplémentaire en gas) vérifie que l’adresse du destinataire est non-nulle.

 

Limite de la taille de la pile - Stack size limit
Chaque fois qu'un contrat invoque un autre contrat (ou même lui-même via this.f()), la pile d'appels associée à la transaction augmente d'une trame (pour une explication sur la pile d’appel, revoir le cours sur la pile lors de l’exécution d’un script Bitcoin). La pile d'appels est limitée à 1024 trames : lorsque cette limite est atteinte, une autre invocation lève une exception.

 

🔔 Jusqu'au 18 octobre 2016, il était possible d'exploiter ce fait pour mener une attaque comme suit: 

Un adversaire commence par générer une pile d'appels presque pleine (via une séquence d'appels imbriqués), 
Il invoque la fonction de la victime, qui échouera à une nouvelle invocation. 
💡 Si l'exception n'est pas correctement gérée par le contrat de la victime, l'adversaire pourrait réussir son attaque.
 */