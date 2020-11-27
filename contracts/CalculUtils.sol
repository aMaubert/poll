pragma solidity >=0.4.22 <0.8.0;

contract CalculUtils {
    function divide(uint a, uint b, uint precision) public pure returns (string memory) {
        uint result =  a * (10**precision) / b;
        string memory resultString =  integerToString(result);
        return formatStringNumber(resultString, precision);
    }

    function formatStringNumber(string memory origin, uint decalage) public pure returns (string memory)  {
        bytes memory originBytes = bytes(origin);
        bytes memory res = new bytes(originBytes.length + 1);
        uint resIndex = 0;
        string memory _tempValue = new string(originBytes.length);
        for(uint i = 0; i < originBytes.length ; i++ ) {
            if( i == originBytes.length - decalage){
                res[resIndex++] = byte(',');
            }
            res[resIndex++] = originBytes[i];
        }
        return string(res);
    }

    function integerToString(uint _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
