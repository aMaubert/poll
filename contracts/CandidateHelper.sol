pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollHelper.sol";


contract CandidateHelper is PollHelper {

    enum LEVELS { Level1, Level2, Level3, Level4, Level5, Level6, Level7, Level8, Level9, Level10}

    //TODO implement this
    function _computeLevel(uint8 note) private pure returns (LEVELS) {
        return LEVELS.Level1;
    }

    //TODO implement this, bonne chance
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

    //TODO implement this
    function average(uint idElection, address candidateAddress) public  {

    }


}
