pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollHelper.sol";


contract CandidateFactory is PollHelper {

    event CandidateAdded(string name, string firstName);

    function addCandidate(uint256 electionID, string memory _name, string memory _firstName) public {
        Election storage election = elections[electionID];

        election.candidates[election.candidateCount] = Candidate(_name, _firstName, msg.sender);
        election.candidateCount++;
        emit CandidateAdded(_name, _firstName);
    }


}
