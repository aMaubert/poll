pragma solidity >=0.4.22 <0.8.0;

import "./CandidateFactory.sol";
pragma experimental ABIEncoderV2;


contract VoteFactory is CandidateFactory {
    mapping (address => bool) hasOwnerVoted;

    event VoteAdded(address voter_address, address[] candidates, uint8[] notes);


    modifier hasVoted(){
        require(hasOwnerVoted[msg.sender] == false, "You have already voted");
        _;
    }


}
