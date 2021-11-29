/* 
  Techniques de prevention
  1. Veiller a ce que tous les changements d'etat aient lieu avant d'appler des contrats externes
  2. Utiliser des modificateurs de fonction qui empechent la reentrance

 */

contract ReEntrancyGuard {
    bool internal locked;
    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}
