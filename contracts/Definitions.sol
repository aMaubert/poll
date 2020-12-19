pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

contract Definitions {

    struct Candidate {
        string name;
        string firstName;
        address candidateAddress;
    }

    struct Vote{
        address voter_address;
        uint ballotCount;
        mapping (address => uint8) ballot;      // Un vote correspond à l'adresse du Candidate et des notes.
    }

    enum ElectionState { APPLICATION, VOTE, RESULTS}

    struct Election {
        uint256 id;
        string name;
        ElectionState state;
        uint candidateCount;
        uint voteCount;
        mapping(uint => Candidate) candidates;
        mapping(uint => Vote) votes;
    }
}
