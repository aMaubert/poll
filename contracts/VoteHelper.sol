pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;


import "./VoteFactory.sol";

contract VoteHelper is VoteFactory {

    enum LEVELS {Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8, Level9, Level10}

    function allVotesByElectionID(uint256 electionID) public view returns(address[] memory, address[] memory, uint[] memory) {
        Election storage election = elections[electionID];
        address[] memory addresses;
        (addresses,,) = allCandidatesByElectionID(electionID);

        address[] memory votersAddress = new address[](election.voteCount);
        address[] memory candidatesAddress = new address[](election.candidateCount * election.voteCount);
        uint[] memory notes = new uint[](election.candidateCount * election.voteCount);

        for(uint i = 0; i < election.voteCount; i++) {
            Vote storage vote = election.votes[i];
            votersAddress[i] = vote.voter_address;
            for(uint j = 0; j < election.candidateCount; j++) {
                candidatesAddress[(i * election.candidateCount) + j ] = addresses[j];
                notes[(i * election.candidateCount) + j] = vote.ballot[addresses[j]];
            }
        }

        return (votersAddress, candidatesAddress, notes);
    }

    function allNotesByElectionIDByCandidate(uint256 electionID, address candidate) public view returns(uint[] memory) {
        Election storage election = elections[electionID];

        uint[] memory notes = new uint[](election.voteCount);

        for(uint i = 0; i < election.voteCount; i++) {
            Vote storage vote = election.votes[i];
            notes[i] = vote.ballot[candidate];
        }

        return notes;
    }

     function fetchMedianCandidates(uint electionId) public view returns(string[] memory, string[] memory, address[] memory, uint[] memory, uint[] memory) {
        Election storage election = elections[electionId];
        uint candidateCount = election.candidateCount;

        string[] memory candidatesNames = new string[](candidateCount);
        string[] memory candidatesFirstNames = new string[](candidateCount);
        address[] memory candidatesAddresses = new address[](candidateCount);
        uint[] memory mediansArray = new uint[](candidateCount);
        uint[] memory averagesArray = new uint[](candidateCount);

        for(uint i = 0; i < candidateCount; i++) {
            candidatesAddresses[i] = election.candidates[i].candidateAddress;
            candidatesNames[i] = election.candidates[i].name;
            candidatesFirstNames[i] = election.candidates[i].firstName;

            uint[] memory tmpNotesList = allNotesByElectionIDByCandidate(electionId, candidatesAddresses[i]);

            quickSort(tmpNotesList, int(0), int(tmpNotesList.length - 1));

            uint medianResult;
            if (tmpNotesList.length % 2 == 0){
                //moyenne de la note juste avant le milieu de la série et de la note juste après celle de la série
                //-1 longeur de la série
                //-2 => récupération de la note juste avant le milieu de la série
                // 0 => récupération de la note juste après le milieu de la série
                uint first = tmpNotesList[(tmpNotesList.length-2)/2]*100;
                uint second = tmpNotesList[(tmpNotesList.length)/2]*100;
                medianResult = (first + second)/2;
            }
            else{
                medianResult = tmpNotesList[tmpNotesList.length/2]*100;
            }

            mediansArray[i] = medianResult;

            uint sum = 0;
            for(uint noteInd = 0; noteInd < tmpNotesList.length; noteInd++){
                sum += tmpNotesList[noteInd];
            }
            sum = sum*100/tmpNotesList.length;
            averagesArray[i] = sum;

        }

        return (candidatesNames, candidatesFirstNames, candidatesAddresses, mediansArray, averagesArray);
    }

    function quickSort(uint[] memory array, int left, int right) pure public {
        int i = left;
        int j = right;
        if (i == j){
            return;
        }
        uint pivot = array[uint(left + (right - left) / 2)];
        while (i <= j){
            while (array[uint(i)] < pivot) i++;
            while (pivot < array[uint(j)]) j--;
            if (i <= j){
                (array[uint(i)], array[uint(j)]) = (array[uint(j)], array[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j){
            quickSort(array, left, j);
        }
        if (i < right){
            quickSort(array, i, right);
        }
    }


    function fetchElectionMsgSenderHasVoted() public view returns(uint256[] memory, string[] memory, ElectionState[] memory) {

        uint countVotedElections = participated[msg.sender].length;

        uint256[] memory idArray = new uint256[](countVotedElections);
        string[] memory nameArray = new string[](countVotedElections);
        ElectionState[] memory stateArray = new ElectionState[](countVotedElections);

        for(uint i = 0; i < countVotedElections; i++)  {
            idArray[i] = participated[msg.sender][i].id;
            nameArray[i] = participated[msg.sender][i].name;
            stateArray[i] = participated[msg.sender][i].state;
        }

        return (idArray, nameArray, stateArray);
    }

}
