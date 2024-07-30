// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TEST12{
    /*
    주차정산 프로그램을 만드세요. 주차시간 첫 2시간은 무료, 그 이후는 1분마다 200원(wei)씩 부과합니다. 
    주차료는 차량번호인식을 기반으로 실행됩니다.
    주차료는 주차장 이용을 종료할 때 부과됩니다.
    ----------------------------------------------------------------------
    차량번호가 숫자로만 이루어진 차량은 20% 할인해주세요.
    차량번호가 문자로만 이루어진 차량은 50% 할인해주세요.
    */

    mapping (string => uint) car;

    function enter(string memory carNumber) public {
        require(car[carNumber] == 0, "need to pay");
        car[carNumber] = block.timestamp;
    }
    
    function getCost(string memory _carNumber) public view returns(uint) {
        uint parkingTime = block.timestamp - car[_carNumber];
        uint freeTime = 60 * 60 * 2;
        uint fee = (parkingTime - freeTime) * 200 wei / 60;

        if (parkingTime < freeTime) {
            return 0;
        } else {
            return fee;
        }
    }

    function leave(string memory _carNumber) public payable{
        require(car[_carNumber] != 0, "didn't enter yet");
        bool numberExists;
        bool stringExists;

        for (uint i=0;i<bytes(_carNumber).length;i++) {
            if(bytes(_carNumber)[i] >= bytes1(uint8(0+48)) && bytes(_carNumber)[i] <= bytes1(uint8(9+48))) {
                numberExists = true;
            } else {
                stringExists = true;
            }
        }

        uint fee = getCost(_carNumber);
        if(numberExists && !stringExists) {
            fee = fee * 80 / 100;
        } else if(!numberExists && stringExists) {
            fee = fee * 50 / 100;
        }

        if (fee == 0) {
            delete car[_carNumber];
        } else {
            require(msg.value == fee, "not enough money");
            delete car[_carNumber];
        }

    }
}