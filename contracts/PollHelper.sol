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
    function fetchElectionByID(uint256 id) public view returns(uint256,string memory, ElectionState ) {
//        return (elections[electionCount - 1].id, elections[electionCount - 1].name, elections[electionCount - 1].state);
//        Election[] memory arrayElections = new Election[](electionCount);
//        for (uint i = 0; i < electionCount; i++) {
//            Election storage election = elections[i];
//            arrayElections[i] = election;
//        }
        return (id, "NOT IMPLEMENTED YET", ElectionState.APPLICATION);
    }


}
