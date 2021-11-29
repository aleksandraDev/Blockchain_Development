// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Gartic2 is Ownable {
    // variables: array of words, players and winner if any
    string[] private words;
    mapping(address => bool) played;
    address winner;

    uint256 nbJoueur;

    constructor(uint256 nbJ) {
        nbJoueur = nbJ;
    }

    //state of the game
    enum State {
        proposition,
        devine,
        fin
    }
    State state = State.proposition;

    //events
    event newWord(address player, string word);
    event stateChanged(State enCours);
    event finalResults(string firstWord, string lastWord, address winnerAddr);

    // constructor possible pour commencer le jeu directement avec un mot

    // Add new word to the list
    function StoreWord(string memory _newWord) public {
        require(state == State.proposition, "tu ne peux pas jouer au jeu");
        require(
            keccak256(abi.encodePacked(_newWord)) !=
                keccak256(abi.encodePacked((getLastWord()))),
            "Can't write same word !"
        );
        require(
            !played[msg.sender],
            /* unicode */
            "tas deja joue!"
        );
        words.push(_newWord);
        newPlayer(msg.sender); // pour plus tard

        played[msg.sender] = true;

        emit newWord(msg.sender, _newWord);
        if (words.length == nbJoueur) {
            state = State.devine;
            emit stateChanged(state);
        }
    }

    // Get the words list
    function GetWords() public view onlyOwner returns (string[] memory) {
        return words;
    }

    // Get only the last word
    function getLastWord() public view returns (string memory) {
        if (words.length != 0) {
            return words[words.length - 1];
        } else {
            return "";
        }
    }

    // two ways to finish the game:
    // 1 - compare both last and first
    // 2 - let the player guess what was the first word

    // get the start and end of the game
    function getFirstLast()
        public
        view
        onlyOwner
        returns (string memory first, string memory last)
    {
        require(state == State.devine, "jeu pas encore fini");
        // state==State.fin;
        // emit stateChanged(state);
        return (words[0], words[nbJoueur - 1]);
    }

    // guessing
    function guessIt(string memory _word) public returns (address) {
        require(state == State.devine, unicode"Pas à la bonne étape du jeu");
        if (
            keccak256(abi.encodePacked(_word)) !=
            keccak256(abi.encodePacked(words[0]))
        ) {
            return (address(0));
        } else {
            winner = msg.sender;
            state = State.fin;
            emit stateChanged(state);
            return winner;
        }
    }

    // getter de la fin
    function getResults() public {
        require(state == State.fin, "jeu pas encore fini");
        emit finalResults(words[0], words[nbJoueur - 1], winner);
    }

    // fonctions de remise à zero en plus

    // we keep all the addresses in an array
    address[] players;

    function newPlayer(address _newplayer) private {
        players.push(_newplayer);
    }

    // main reset function
    function resetGame() public onlyOwner {
        require(state == State.fin, "jeu pas encore fini");
        state = State.proposition;
        emit stateChanged(state);
        for (uint256 i = 0; i < nbJoueur; i++) {
            words.pop();
        }
        // delete words;
        winner = address(0);
        noPlayers();
    }

    // reseting the played mapping
    function noPlayers() private {
        for (uint256 i = nbJoueur - 1; i == 0; i--) {
            played[players[i]] == false;
            players.pop();
        }
    }
}
