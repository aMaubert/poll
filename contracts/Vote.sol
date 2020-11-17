pragma solidity ^0.4.0;

import "./Note.sol";

contract Vote {
    mapping (address => bool) hasOwnerVoted;
    struct Vote{
        address voter_address;
        mapping (Candidate => Note) example;
    }

    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }

    function _createVote(Note _note) private hasVoted returns(Vote){
        hasOwnerVoted[msg.sender] = true;
        return Vote(msg.sender, _note);
    }
}
