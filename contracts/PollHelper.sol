pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollFactory.sol";


contract PollHelper is PollFactory {

    mapping(address => Election) public participatedPolls;

    //TODO implement
    function fetchParticipatedElections() public {

    }


    // On récupère la liste des candidats d'une élection
    function allCandidatesByElectionID(uint256 electionID) public view returns(string[] memory, string[] memory, address[] memory) {
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

        return (nameArray, firstNameArray, candidateAddressArray);
    }

    function uintToBytes(uint v) pure private returns (bytes32) {
        bytes32 ret;
        if (v == 0) {
            ret = bytes32(0);
        }
        else {
            while (v > 0) {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }

    function bytes32ToString (bytes32 x) pure private returns (string memory) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory resultBytes = new bytes(charCount);
        for (uint j = 0; j < charCount; j++) {
            resultBytes[j] = bytesString[j];
        }

        return string(resultBytes);
    }

    function uintToString(uint v) pure private returns (string memory) {
        return bytes32ToString(uintToBytes(v));
    }

    function allVotesByElectionID(uint256 electionID) public view returns(address[] memory, string[] memory) {
        Election storage election = elections[electionID];
        address[] memory voterAdresses = new address[](election.voteCount);
        string[] memory ballot = new string[](election.voteCount);

//        for(uint i = 0; i < election.voteCount; i++) {
//            Vote storage vote = election.votes[i];
//            voterAdresses[i] = vote.voter_address;
//            address[] memory addresses;
//            (,,addresses) = allCandidatesByElectionID(electionID);
//            for(uint j = 0 ; j < addresses.length; j++) {
//                address candidateAddress = addresses[j];
//                uint8 note = vote.ballot[candidateAddress];
//                ballot[i] = uintToString(note);
//            }
//        }

        return (voterAdresses, ballot);
    }


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
//    function fetchElectionByID(uint id) public view returns(Election[] memory ) {
//        return (elections[electionCount - 1].id, elections[electionCount - 1].name, elections[electionCount - 1].state);
//        Election[] memory arrayElections = new Election[](electionCount);
//        for (uint i = 0; i < electionCount; i++) {
//            Election storage election = elections[i];
//            arrayElections[i] = election;
//        }
//        return arrayElections;
//    }


}

//
//contract BidHistory {
//    struct Bid {
//        address bidOwner;
//        uint bidAmount;
//        bytes32 nameEntity;
//    }
//    mapping (uint => Bid) public bids;
//    uint public bidCount;
//
//    constructor() public {
//        bidCount = 0;
//        storeBid("address0",0,0);
//        storeBid("address1",1,1);
//    }
//    function storeBid(address memory _bidOwner, uint memory _bidAmount, bytes32 memory _nameEntity) public  {
//        bids[tripcount] = Bid(_bidOwner, _bidAmount,_nameEntity);
//        bidCount++;
//    }
//    //return Array of structure
//    function getBid() public view returns (Bid[] memory){
//        Bid[] memory lBids = new Bid[](tripcount);
//        for (uint i = 0; i < bidCount; i++) {
//            Bid storage lBid = bids[i];
//            lBids[i] = lBid;
//        }
//        return lBids;
//    }
//}
