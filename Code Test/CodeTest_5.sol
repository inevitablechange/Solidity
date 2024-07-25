// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Test5{
    /* 
    숫자를 시분초로 변환하세요.
    예) 100 -> 1 min 40 sec
    600 -> 10min 
    1000 -> 16min 40sec
    5250 -> 1hour 27min 30sec
    */
    function uintToTime(uint number) public pure returns(string memory) {
       uint hour = number / 3600;
       uint minute = (number % 3600) / 60;
       uint second = number % 60;

       if(hour == 0) {
            return string.concat(Strings.toString(minute)," minutes ", Strings.toString(second), " seconds");
       }
       if(minute == 0) {
            return string.concat(Strings.toString(second), " seconds");
        }
        return string.concat(Strings.toString(hour)," hours ",Strings.toString(minute)," minutes ", Strings.toString(second), " seconds");
    }
}