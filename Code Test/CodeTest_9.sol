// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test9 {
    /*
    흔히들 비밀번호 만들 때 대소문자 숫자가 각각 1개씩은 포함되어 있어야 한다 
    등의 조건이 붙는 경우가 있습니다. 그러한 조건을 구현하세요.

    입력값을 받으면 그 입력값 안에 대문자, 
    소문자 그리고 숫자가 최소한 1개씩은 포함되어 있는지 여부를 
    알려주는 함수를 구현하세요.
    */ 

    function checkPassword(string memory _pw) public pure returns(bool) {
        bool hasNumber = false;
        bool hasUpper = false;
        bool hasLower = false;
        bytes memory _pwBytes = bytes(_pw);

        //_pw 안에 대문자, 소문자, 숫자 1개씩 포함해야 함
        for(uint i=0; i<_pwBytes.length;i++){
            if(_pwBytes[i] >= 0x30 && _pwBytes[i] <= 0x39) {
                hasNumber = true;
            } else if(_pwBytes[i] >= 0x41 && _pwBytes[i] <= 0x5A) {
                hasUpper = true;
            } else if(_pwBytes[i] >= 0x61 && _pwBytes[i] <= 0x7A) {
                hasLower = true;
            }
        }

        return hasNumber && hasUpper && hasLower;

    }
}
