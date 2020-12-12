pragma solidity >=0.4.22 <0.8.0;

contract Ping {

    function pingTest() public pure returns (string memory) {
        string memory pong =  "Pong";
        return pong;
    }

}
