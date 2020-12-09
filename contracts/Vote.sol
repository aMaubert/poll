pragma solidity >=0.4.22 <0.8.0;

import "./Note.sol";

    /*
        Pour le back : - modifier createVote
    */

contract Vote {
    mapping (address => bool) hasOwnerVoted;

    struct Vote{
        address voter_address;
        mapping (address => uint8) ballot; // L'adresse correspond à l'id du candidat et le uint à la note associée
    }

    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }

    modifier checkNote(uint8 note) {
        require(
            note <= max_note,
            "The note is too high"
        );
        _;
    }

    // Signature de la méthode à revoir : Note ou uint[] ? => Il faudra se mettre d'accord avec ce qu'on recevra du front.
    function _createVote(Note memory _note) private hasVoted returns(Vote memory){
        hasOwnerVoted[msg.sender] = true;
        // call addVote(newVote, idElection)
        // remove return
        return Vote(msg.sender);
    }
}
