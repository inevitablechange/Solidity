// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test4 {
    /*
    간단한 게임이 있습니다.
    유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
    참가할 때 참가비용 0.01ETH를 내야합니다. (payable 함수)
    4명까지만 들어올 수 있는 방이 있습니다. (array)
    선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

    예) 
    방 안 : "empty" 
    -- A 입장 --
    방 안 : A 
    -- B, D 입장 --
    방 안 : A , B , D 
    -- F 입장 --
    방 안 : A , B , D , F 
    A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
    방 안 : "empty" 

    유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
    예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

    * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    * 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    ---------------------------------------------------------------------------------------------------
    * 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
    */

    struct user{
        uint number;
        string name;
        address addr;
        uint balance;
        uint score;
    }

    address payable owner;

    mapping(address => user) users; //동적배열보다 mapping 활용하는 것이 좋음 (검색, msg.sender 활용 등에 용이)
    address[4] public room;
    uint public idx;

    constructor() {
        owner = payable(msg.sender); // msg.sender에도 payable을 넣어줘야 한다.
    }

    modifier onlyOwner{
        require(msg.sender == owner, "only owner");
        _;
    }

    modifier morethanTwoEther {
        _;
        require(address(this).balance >= 2 ether, "nope");
    }

    // 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    function signIn(string memory name) public {
        require(bytes(users[msg.sender].name).length == 0, "nope");
        users[msg.sender] = user(idx++,name,msg.sender,0,0);
    }

    // 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function getUser(address addr) public view returns(user memory) {
        return users[addr];
    }

    // 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function payForGame() public payable {
        require(bytes(users[msg.sender].name).length != 0 && (msg.value == 0.01 ether || users[msg.sender].balance >= 0.01 ether), "pay 0.01 eth");

        if(msg.value ==0) {
            users[msg.sender].balance -= 0.01 ether;
        }

        if(getLength() == 3) {
            room[3] = msg.sender;
            getScore();
            delete room;
        } else {
            room[getLength()] = msg.sender;
        }

    }

    function getLength() public view returns(uint) {
        for(uint i=0; i<4; i++) {
            if (users[room[i]].number == 0) {
                return i;
            }
        }
        return 4;
    }

    function getScore() public {
        for(uint i=0;i<room.length;i++) {
            users[room[i]].score += 4-i;
        }
    }


    // 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function changeScoreToEth(uint _n) public {
        require(users[msg.sender].score >= _n, "nope");
        
        users[msg.sender].score -= _n;
        payable(msg.sender).transfer(0.1 ether * (_n / 10));
    }

    function changeScoreToEthMax() public {
        require(users[msg.sender].score >= 10, "nope");
        uint amount = users[msg.sender].score / 10;
        users[msg.sender].score %= 10;

        payable(msg.sender).transfer(amount * 0.1 ether); 
    }

    // 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
    function withdraw(uint etherAmount) public onlyOwner morethanTwoEther{
        owner.transfer(0.01 ether * etherAmount);
    }

    function withdrawMax() public onlyOwner morethanTwoEther{
        owner.transfer(address(this).balance);
    }

    // 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능
    function deposit() public payable{
        users[msg.sender].balance += msg.value;
    }

}