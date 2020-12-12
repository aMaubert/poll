pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;


contract VoteFactory {
    mapping (address => bool) hasOwnerVoted;

    struct Vote{
        address voter_address;
        mapping (address => uint8) ballot;      // Un vote correspond à l'adresse du Candidate et des notes.
    }


    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }



    struct CreateVote {
        address candidate;
        uint8 note;
    }

    //TODO complete this method
    function createVote(CreateVote[] memory vote) public {

        //        for (uint i = 0; i < elections.length; i++) {
        //            // On compare les deux chaines de caractères (l'une est de type stockage et l'autre memory)
        //            if(elections[i].id == _idElection) {
        //                Vote memory tmpVote = Vote(msg.sender);
        //                for(uint j = 0; j < _notes.length; j++) {
        //                    tmpVote.ballot[j] = _createNote(_notes);
        //                }
        //                elections[i].votes[_getUniqueId()] = tmpVote;
        //            }
        //        }
    }

}
