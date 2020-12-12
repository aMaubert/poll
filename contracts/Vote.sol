pragma solidity >=0.4.22 <0.8.0;


contract Vote {
    mapping (address => bool) hasOwnerVoted;

    struct Vote{
        address voter_address;
        mapping (address => uint8) ballot;      // Un vote correspond à l'adresse du Candidate et des notes.
    }

    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }

//    function _createVote(uint8[5] memory _notes) internal hasVoted returns(Vote memory){
//        hasOwnerVoted[msg.sender] = true;
//        mapping (uint => Note) storage tmpBallot ;
//        for(uint i = 0; i < _notes.length; i++) {
//            tmpBallot[_getUniqueId()] = _createNote(_notes[i]);
//        }
//        return Vote(msg.sender, tmpBallot);
//    }

//    function _createVote(uint _note) private hasVoted returns(Vote memory){
//        hasOwnerVoted[msg.sender] = true;
//        // call addVote(newVote, idElection)
//        // remove return
//        return Vote(msg.sender);
//    }

    function _getUniqueId() internal view returns (uint)
    {
        bytes20 b = bytes20(keccak256(abi.encodePacked(msg.sender, now)));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint8(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }

        return addr;
    }
}
