// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test6 {
    /*
    숫자를 넣었을 때 그 숫자의 자릿수와 각 자릿수의 숫자를 나열한 결과를 반환하세요.
    예) 2 -> 1,   2 // 45 -> 2,   4,5 // 539 -> 3,   5,3,9 // 28712 -> 5,   2,8,7,1,2 
    */

    function figures(uint _a) public pure returns (uint, uint[] memory) {
        uint count;
        uint tmp = _a;
        while (_a>0) {
            _a /= 10;
            count++;
        }

        uint[] memory numbers = new uint[](count);
        for(uint i=count;i>0;i--) {
            uint remainder = tmp % 10;
            tmp /= 10;
            numbers[i - 1] = remainder;
        }

        return (count, numbers);
    }

    /*
    문자열을 넣었을 때 그 문자열의 자릿수와 문자열을 한 글자씩 분리한 결과를 반환하세요.
    예) abde -> 4,   a,b,d,e // fkeadf -> 6,   f,k,e,a,d,f
    */

    function strings(string memory _s) public pure returns (uint, string[] memory) {
        string[] memory _letters = new string[](bytes(_s).length);

        for(uint i=0;i<_letters.length;i++){
            _letters[i] = string(abi.encodePacked(bytes(_s)[i]));
        }

        return (bytes(_s).length, _letters);
    }

}

contract BASE {

    //bytes는 array와 비슷하게 취급해주면 된다.
    function getBytes(bytes memory _b) public pure returns(uint) {
        return _b.length;
    }

    function getByte1(bytes memory _b, uint _n) public pure returns(bytes1) {
        return _b[_n-1];
    }

    function split(bytes memory b) public pure returns(uint, bytes1[] memory, string memory) {
        uint _length = b.length;

        bytes1[] memory _b = new bytes1[](_length);

        for (uint i=0;i<_length;i++) {
            _b[i] = b[i];
        }

        return (_length, _b, string(abi.encodePacked(_b)));
    }

    function getEncode(string memory b) public pure returns(bytes memory) {
        return abi.encode(b);
    }

    function getEncodePacked(string memory b) public pure returns(bytes memory) {
        return abi.encodePacked(b);
    }
}