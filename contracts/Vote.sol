pragma solidity >=0.4.22 <0.8.0;

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

    function _createVote(uint8 _note) private hasVoted returns(Vote memory){
        hasOwnerVoted[msg.sender] = true;
        // call addVote(newVote, idElection)
        // remove return
        return Vote(msg.sender);
    }
}
