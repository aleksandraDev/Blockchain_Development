// DDos attack with Block Gas limit

address[] private refundAdresses;
mapping (address => uint) public refunds;

// bad
function refundAll() public {
  for (uint x; x < refundAddresses.length; x++) {
    require(refundAddresses[x].send(refunds[refundAddresses[x]]));
  }
}

/* 
  Techniquees de prevention
  1. La solution recommandee est de favoriser les paiements "pull over push"

  La logique a suivre:
  - Il fau separer les paiements dans une fonction differente : qui va permetre aux utilisateurs de demander (pulll) des fonds independamment du reste de la loqgique du contract
 */

 