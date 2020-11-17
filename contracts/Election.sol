pragma solidity >=0.4.22 <0.8.0;

import "./Candidate.sol";

contract Election {
    address public owner = msg.sender;
    uint public last_completed_migration;

    enum State {Applications, Vote, Finished}

    struct Election {
        string name;
        State state;
        Candidate[] candidates;
    }


    modifier restricted() {
        require(
            msg.sender == owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }
}
