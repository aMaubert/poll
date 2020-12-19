pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;


import "./VoteFactory.sol";

contract VoteHelper is VoteFactory {

    enum LEVELS { Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8, Level9, Level10}

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


    //This function should return the election which the msg.sender has already voted
    //TODO implement
    function fetchParticipatedElections() public {

    }


    //TODO implement this
    function _computeLevel(uint8 note) private pure returns (LEVELS) {
        return LEVELS.Level1;
    }

    //TODO implement this, Good luck
    function fetchMedianCandidates(uint electionId) public {
        //        medianCandidate = mapping(address => LEVELS)
        //        for let candidate of election.candidates:
        //
        //            nbNotesByLevels = mapping(LEVELS => uint)
        //            for let i = 0; i < elections.votes.length ; i++ :
        //               note  = elections.votes[i].ballot[candidate.candidateAddress];
        //               level = _computeLevel(note);
        //               nbNotesByLevels[level] += 1
        //
        //            acc = 0
        //            iterate each enum value of LEVELS :
        //                acc += nbNotesByLevels[Level]
        //                if acc / elections.votes.length >= 0.5 :
        //                    medianCandidate[candidate.candidateAddress] = Level
        //                    break
        //        return medianCandidate
        //
    }

}
