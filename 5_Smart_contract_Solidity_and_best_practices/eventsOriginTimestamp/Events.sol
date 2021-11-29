/* 
  Utiliser des events

  Il peut être utile d'avoir un moyen de surveiller l'activité du contrat après son déploiement. 
  Une façon d'y parvenir est d'examiner toutes les transactions du contrat, mais cela peut s'avérer insuffisant, 
  car les appels de message entre les contrats ne sont pas enregistrés dans la chaîne en bloc. 
  De plus, il ne montre que les paramètres d'entrée, et non les changements réels apportés à l'état. 
  Des événements peuvent également être utilisés pour déclencher des fonctions dans l'interface utilisateur.
 */
 pragma solidity 0.8.7;

contract Charity {
    mapping(address => uint) balances;

    function donate() payable public {
        balances[msg.sender] += msg.value;
    }
}

contract Game {
    function buyCoins(Charity charity) payable public {
        // 5% goes to charity
        charity.donate{value:msg.value / 20}();
    }
}

// avec events

pragma solidity 0.8.7;

contract Charity {
    // define event
    event LogDonate(uint _amount);

    mapping(address => uint) balances;

    function donate() payable public {
        balances[msg.sender] += msg.value;
        // emit event
        emit LogDonate(msg.value);
    }
}

contract Game {
    function buyCoins(Charity charity) payable public {
        // 5% goes to charity
        charity.donate{value:msg.value / 20}();
    }
}
