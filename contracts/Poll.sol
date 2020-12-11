// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "./Election.sol";
import "./CalculUtils.sol";

contract Poll  {
  address public owner = msg.sender;
  uint public last_completed_migration;

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

  function pingTest() public pure returns (string memory) {
    string memory pong =  "Pong";
    return pong;
  }

  function floatTest(uint a, uint b) public pure returns (uint) {
    if (b != 0)
      return (a * 100) / b ;
    else
      return 0;
  }
}
