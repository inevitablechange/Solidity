// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract TEST11{
    /*
    로또 프로그램을 만드려고 합니다. 
    숫자와 문자는 각각 4개 2개를 뽑습니다. 6개가 맞으면 1이더, 5개의 맞으면 0.75이더, 
    4개가 맞으면 0.25이더, 3개가 맞으면 0.1이더 2개 이하는 상금이 없습니다. 

    참가 금액은 0.05이더이다.

    예시 1 : 8,2,4,7,D,A
    예시 2 : 9,1,4,2,F,B
    */

    function lottery (uint[4] memory _numbers, string[2] memory _strings) public payable {
        require(msg.value == 0.5 ether, "0.5 ether");
        
        string[6] memory strings;

        for(uint i=0;i<_numbers.length;i++) {
            strings[i] = Strings.toString(_numbers[i]);
        }

        for(uint i=0;i<_strings.length;i++) {
            strings[i+4] = _strings[i];
        }

        
    }
}