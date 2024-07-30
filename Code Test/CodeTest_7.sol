// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test7 {
    /* 
    * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    --------------------------------------------------------
    * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    */

    struct status{
        uint speed;
        uint gas;
        bool isOn;
        uint balances;
    }

    mapping(address=>status) public drivers;

    function setDriver() public {
        drivers[msg.sender] = status(0,0,false,0);
    }

    // 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function excel() public {
        require(drivers[msg.sender].gas > 30 && drivers[msg.sender].speed < 70 && drivers[msg.sender].isOn, "cannot use excel");
        drivers[msg.sender].gas -= 20;
        drivers[msg.sender].speed += 10;
    }

    // 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function fillGas() public payable {
        require(msg.value == 1 ether || drivers[msg.sender].balances >= 1 ether, "1 ether");
        if(drivers[msg.sender].balances >= 1 ether) {
            drivers[msg.sender].balances -= 1 ether;
            drivers[msg.sender].gas = 100;
        } else {
            drivers[msg.sender].gas = 100;
        }
        
       
    }

    // 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function breaks() public {
        require(drivers[msg.sender].gas >= 10 && drivers[msg.sender].speed > 0 && drivers[msg.sender].isOn, "cannot use break");
        drivers[msg.sender].gas -= 10;
        drivers[msg.sender].speed -= 10;
    }

    // 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function off() public {
        require(drivers[msg.sender].speed == 0, "speed needs to be 0");
        drivers[msg.sender].isOn = false;
    }

    // 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function on() public {
        drivers[msg.sender].isOn = true;
        drivers[msg.sender].speed = 0;
    }

    // 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    function charge() public payable{
        drivers[msg.sender].balances = msg.value;
    }
}

contract Test7_2{
    /* 
    * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    --------------------------------------------------------
    * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    */

    enum CarStatus {
        stop,
        off,
        driving
    }

    struct Car{
        uint speed;
        uint gas;
        uint balances;
        CarStatus status;
    }

    Car public myCar;

    // 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
    function accel() public {
        require(myCar.gas > 30 && myCar.speed < 70 && myCar.status == CarStatus.driving || myCar.status == CarStatus.stop, "cannot use excel");
        myCar.gas -= 20;
        myCar.speed += 10;
        if(myCar.status != CarStatus.driving) {
            myCar.status=CarStatus.driving;
        }
    }

    // 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
    function breaks() public {
        require(myCar.gas >= 10 && myCar.speed > 0 && myCar.status == CarStatus.driving, "cannot use break");
        myCar.gas -= 10;
        myCar.speed -= 10;
        if(myCar.speed == 0) {
            myCar.status=CarStatus.stop;
        }
    }

    // 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
    function on() public {
        require(myCar.status == CarStatus.off);
        myCar.status = CarStatus.stop;
    }

    // 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
    function off() public {
        require(myCar.speed == 0, "speed needs to be 0");
        myCar.status = CarStatus.off;
    }



    // 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
    function fillGas() public payable {
        require(msg.value == 1 ether && myCar.status == CarStatus.off || myCar.balances >= 1 ether, "1 ether");
        if(myCar.balances >= 1 ether) {
            myCar.balances -= 1 ether;
            myCar.gas = 100;
        } else {
            myCar.gas = 100;
        }
        
    }


    // 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감 
    function charge() public payable{
        require((msg.value == 1 ether || address(this).balance >=1 ether) && myCar.status == CarStatus.off,"Nope");
        myCar.gas = 100;
        payable(address(0)).transfer(1 ether);
    }

    receive() external payable{}
}