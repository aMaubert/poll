pragma solidity >=0.4.22 <0.8.0;

import "./Note.sol";

contract Vote is Note {
    mapping (address => bool) hasOwnerVoted;

    struct Vote{
        address voter_address;
        mapping (address => uint) ballot; // L'adresse correspond à l'id du candidat et le uint à la note associée
    }

    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }

    // Signature de la méthode à revoir : Note ou uint[] ? => Il faudra se mettre d'accord avec ce qu'on recevra du front.
    function _createVote(Note memory _note) private hasVoted returns(Vote memory){
        hasOwnerVoted[msg.sender] = true;
        return Vote(msg.sender);
    }
}
