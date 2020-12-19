pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

import "./PollFactory.sol";


contract PollHelper is PollFactory {

    mapping(address => Election) public participatedPolls;

    //TODO implement
    function fetchParticipatedElections() public {

    }


    // On récupère la liste des candidats d'une élection
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


    event printNumbers(uint[]);
    event printAddress(address);

    function allVotesByElectionID(uint256 electionID) public returns(address[] memory, address[] memory, uint[] memory) {
        Election storage election = elections[electionID];
        address[] memory addresses;
        (addresses,,) = allCandidatesByElectionID(electionID);

        address[] memory votersAddress = new address[](election.voteCount);
        address[] memory candidatesAddress = new address[](election.candidateCount * election.voteCount);
        uint[] memory notes = new uint[](election.candidateCount * election.voteCount);

        uint index = 0;
        for(uint i = 0; i < election.voteCount; i++) {
            Vote storage vote = election.votes[i];
            votersAddress[i] = vote.voter_address;
            for(uint j = 0; j < election.candidateCount; j++) {
                candidatesAddress[index] = addresses[j];
                notes[index] = vote.ballot[addresses[j]];
                index++;
                emit printNumbers(notes);
            }
        }

        return (votersAddress, candidatesAddress, notes);
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
