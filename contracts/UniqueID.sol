pragma solidity >=0.4.22 <0.8.0;

contract UniqueID {
    function generateUniqueId() internal view returns (uint256) {
        bytes20 b = bytes20(keccak256(abi.encodePacked(msg.sender, now)));
        uint addr = 0;
        for (uint index = b.length-1; index+1 > 0; index--) {
            addr += uint8(b[index]) * ( 16 ** ((b.length - index - 1) * 2));
        }
        return addr;
    }
}
