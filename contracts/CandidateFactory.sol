pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollHelper.sol";


contract CandidateFactory is PollHelper {

    event CandidateAdded(string name, string firstName);

    modifier isApplicationState(uint256 electionID) {
        Election storage election = elections[electionID];
        require(election.state == ElectionState.APPLICATION, "Can't apply to this election .");
        _;
    }

    function addCandidate(uint256 electionID, string memory _name, string memory _firstName) public isApplicationState(electionID) {
        Election storage election = elections[electionID];

        election.candidates[election.candidateCount] = Candidate(_name, _firstName, msg.sender);
        election.candidateCount++;
        emit CandidateAdded(_name, _firstName);
    }


}
