pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollFactory.sol";

contract PollHelper is PollFactory {

    mapping(address => Election) public participatedPolls;

    //TODO implement
    function fetchParticipatedElections() public {

    }

    //TODO implement
    function fetchElectionByID(uint id) public {

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
