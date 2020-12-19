pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./CandidateFactory.sol";


contract CandidateHelper is CandidateFactory {

    function allCandidatesByElectionID(uint256 electionID) public view returns( address[] memory, string[] memory, string[] memory) {
        Election storage election = elections[electionID];

        string[] memory nameArray = new string[](election.candidateCount);
        string[] memory firstNameArray = new string[](election.candidateCount);
        address[] memory candidateAddressArray = new address[](election.candidateCount);

        for(uint i = 0; i < election.candidateCount; i++) {
            Candidate storage candidate = election.candidates[i];
            nameArray[i] = candidate.name;
            firstNameArray[i] = candidate.firstName;
            candidateAddressArray[i] = candidate.candidateAddress;
        }

        return (candidateAddressArray, nameArray, firstNameArray);
    }


}
