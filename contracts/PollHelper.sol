pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollFactory.sol";


contract PollHelper is PollFactory {


    function allElections() public view returns(uint256[] memory, string[] memory, ElectionState[] memory) {
        uint256[] memory idArray = new uint256[](electionCount);
        string[] memory nameArray = new string[](electionCount);

        ElectionState[] memory stateArray = new ElectionState[](electionCount);

        for (uint i = 0; i < electionCount; i++) {

            Election storage election = elections[i];
            idArray[i] = election.id;
            nameArray[i] = election.name;
            stateArray[i] = election.state;

        }

        return (idArray, nameArray, stateArray);
    }


    //TODO implement
    function fetchElectionByID(uint256 electionID) public view returns(uint256 ,string memory, ElectionState ) {
        require(electionCount != 0, "We have 0 elections .");
        Election storage election = elections[electionID];
        require(election.id ==  electionID, "Election doesn't exists .");
        return (election.id, election.name, election.state);
    }


}
