pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./CandidateHelper.sol";



contract VoteFactory is CandidateHelper {

    mapping(address => Election[]) public participated;

    modifier hasNotVoted(uint256 electionId){
        bool hasParticipated = false;
        if (participated[msg.sender].length > 0) {
            for (uint i = 0; i < participated[msg.sender].length; i++) {
                if(participated[msg.sender][i].id == electionId) {
                    hasParticipated = true;
                }
            }
        }
        require(!hasParticipated, "You have already voted for this election .");
        _;
    }

    modifier isVoteState(uint256 electionID) {
        Election storage election = elections[electionID];
        require(election.state == ElectionState.VOTE, "Can't vote this election .");
        _;
    }

    event VoteAdded(address voter_address, address[] candidates, uint8[] notes);

    function addVote(uint256 electionID, address[] memory candidateAddresses, uint8[] memory notes) public isVoteState(electionID) hasNotVoted(electionID) {
        Election storage election = elections[electionID];
        election.votes[election.voteCount] = Vote(msg.sender, candidateAddresses.length);

        for(uint i = 0; i < candidateAddresses.length; i++) {
            election.votes[election.voteCount].ballot[candidateAddresses[i]] = notes[i];
        }
        election.voteCount++ ;

        participated[msg.sender].push(election);
        emit VoteAdded(msg.sender, candidateAddresses, notes);

    }

}
