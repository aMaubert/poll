pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./CandidateHelper.sol";



contract VoteFactory is CandidateHelper {

    mapping(address => Election) public participated;

    modifier hasVoted(uint256 electionId){
        require(participated[msg.sender].id == electionId, "You have already voted");
        _;
    }

    event VoteAdded(address voter_address, address[] candidates, uint8[] notes);

    function addVote(uint256 electionID, address[] memory candidateAddresses, uint8[] memory notes) public {
        Election storage election = elections[electionID];
        election.votes[election.voteCount] = Vote(msg.sender, candidateAddresses.length);

        for(uint i = 0; i < candidateAddresses.length; i++) {
            election.votes[election.voteCount].ballot[candidateAddresses[i]] = notes[i];
        }
        election.voteCount++ ;

        participated[msg.sender] = election;
        emit VoteAdded(msg.sender, candidateAddresses, notes);

    }

}
