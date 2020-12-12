pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollFactory.sol";

contract PollHelper is PollFactory {

    mapping(address => Election) public participatedPolls;

    //TODO implement
    function fetchParticipatedElections() public {

    }

    function _mappingCandidateToArray(Election storage election) private view returns (Candidate[] memory) {
        Candidate[] memory candidates = new Candidate[](election.candidatesSize);
        for(uint candidateIndex = 0; candidateIndex < election.candidatesSize; candidateIndex++ ) {
            candidates[candidateIndex] = election.candidates[0];
        }
        return candidates;
    }

    //TODO implement
    function fetchElectionByID(uint id) public view returns(uint, string memory, ElectionState, Candidate[] memory ) {
        for(uint i = 0; i < elections.length; i++) {
            if( elections[i].id == id) {
                Candidate[] memory candidates = _mappingCandidateToArray(elections[i]);
                return (elections[i].id, elections[i].name, elections[i].state, candidates);
            }
        }
    }

    // On récupère la liste des candidats d'une élection
    //TODO test this
//    function getCandidatesForElection(uint _idElection) public returns(Candidate[] memory) {
//        for (uint i = 0; i < elections.length; i++) {
//            if(elections[i].id == _idElection) {
//                return elections[i].candidates;
//            }
//        }
//        Candidate[] memory tmpCandidate;
//        return tmpCandidate;
//    }
}
