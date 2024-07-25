// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Question51{
    /*
    숫자들이 들어가는 배열을 선언하고 그 중에서 3번째로 큰 수를 반환하세요.
    */
    uint[] public numbers;

    function pushNumber(uint _num) public {
        numbers.push(_num);
    }
    
    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }


    function third() public view returns (uint) {
        require(numbers.length > 3, "too short");
        uint[] memory tmp = numbers;
        for(uint i=0; i<tmp.length; i++) {
            for(uint j=i+1; j<tmp.length;j++) {
                if(tmp[j] > tmp[i]) {
                (tmp[j], tmp[i]) = (tmp[i], tmp[j]);
                }
            }
        }
        return tmp[2];
    }
}

contract Question52{
    /*
    자동으로 아이디를 만들어주는 함수를 구현하세요. 이름, 생일, 지갑주소를 기반으로 만든 해시값의 첫 10바이트를 추출하여 아이디로 만드시오.
    */
    function createId(string memory _name, uint _birthday, address _addr) public pure returns(bytes32, bytes memory) {
        bytes32 beforeId = keccak256(abi.encodePacked(_name,_birthday,_addr));
        bytes memory id = new bytes(10);
        for(uint i=0; i<10;i++) {
            id[i] = beforeId[i];
        }

        return (beforeId, id);

    }
}

contract Question53{
    /*
    시중에는 A,B,C,D,E 5개의 은행이 있습니다. 각 은행에 고객들은 마음대로 입금하고 인출할 수 있습니다. 각 은행에 예치된 금액 확인, 입금과 인출할 수 있는 기능을 구현하세요.
    힌트 : 이중 mapping을 꼭 이용하세요.
    */

    mapping(string => mapping(address => uint)) balances;

    modifier checkBank(string memory _bank) {
        require(keccak256(abi.encodePacked(_bank)) == keccak256(abi.encodePacked("A"))
        || keccak256(abi.encodePacked(_bank)) == keccak256(abi.encodePacked("B"))
        || keccak256(abi.encodePacked(_bank)) == keccak256(abi.encodePacked("C"))
        || keccak256(abi.encodePacked(_bank)) == keccak256(abi.encodePacked("D"))
        || keccak256(abi.encodePacked(_bank)) == keccak256(abi.encodePacked("E"))
        , "nope");
        _;
    }


    function deposit(string memory _bank) public payable checkBank(_bank) {
        balances[_bank][msg.sender] += msg.value;
    }

    function withdraw(string memory _bank, uint _amount) public checkBank(_bank) {
        payable(msg.sender).transfer(_amount);
        balances[_bank][msg.sender] -= _amount;
    }

    function myBalances(string memory _bank) public view checkBank(_bank) returns(uint) {
        return balances[_bank][msg.sender];
    }

}

contract Question54{
    /*
    기부받는 플랫폼을 만드세요. 가장 많이 기부하는 사람을 나타내는 변수와 그 변수를 지속적으로 바꿔주는 함수를 만드세요.
    */
    
    struct Donator {
        address addr;
        uint amount;
    }

    Donator[] public Donators;
    Donator public Highest;

    function setDonator() public payable {
        bool exists = false;

        for(uint i=0;i<Donators.length;i++) {
            if(Donators[i].addr == msg.sender) {
                Donators[i].amount += msg.value;
                exists = true;
            }
        }

        if(!exists) {
            Donators.push(Donator(msg.sender, msg.value));
        }

    }

    function setHighest() public {
        for(uint i=0;i<Donators.length;i++) {
            if(Highest.amount < Donators[i].amount) {
                Highest = Donators[i];
            }
        }
    }

}

contract Question55{
    /*
    배포와 함께 owner를 설정하고 owner를 다른 주소로 바꾸는 것은 오직 owner 스스로만 할 수 있게 하십시오.
    */
    address public owner;
    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _addr) public {
        require(owner == msg.sender, "only owner");
        owner = _addr;
    }
}

contract Question56{
    /*
    위 문제의 확장버전입니다. owner와 sub_owner를 설정하고 owner를 바꾸기 위해서는 둘의 동의가 모두 필요하게 구현하세요.
    */
    address public owner;
    address public subowner;
    mapping(address => bool) approval;

    constructor(address _addr) {
        owner = msg.sender;
        subowner = _addr;
    }

    function getApproval() public {
        require(owner == msg.sender || subowner == msg.sender, "only owner / subowner");
        approval[msg.sender] = true;
    }

    function changeOwner(address _addr) public {
        require(owner == msg.sender, "need owner/subowner approval");
        require(approval[owner] && approval[subowner], "need owner/subowner approval");
        owner = _addr;
        approval[owner] = false;
        approval[subowner] = false;
    }
}

contract Question57{
    /*
    위 문제의 또다른 버전입니다. owner가 변경할 때는 바로 변경가능하게 sub-owner가 변경하려고 한다면 owner의 동의가 필요하게 구현하세요.
    */
    address public owner;
    address public subowner;
    mapping(address => bool) approval;

    constructor(address _addr) {
        owner = msg.sender;
        subowner = _addr;
    }

    function getApproval() public {
        require(owner == msg.sender, "only owner");
        approval[msg.sender] = true;
    }

    function changeOwner(address _addr) public {
        require(owner == msg.sender || subowner == msg.sender, "only owner/subowner");
        if(subowner == msg.sender) require(approval[owner], "need owner's approval");
        owner = _addr;
        approval[owner] = false;
    }
}

contract Question58{
    /*
    A contract에 a,b,c라는 상태변수가 있습니다. a는 A 외부에서는 변화할 수 없게 하고 싶습니다. b는 상속받은 contract들만 변경시킬 수 있습니다. c는 제한이 없습니다. 각 변수들의 visibility를 설정하세요.
    */
    uint private a;
    uint internal b;
    uint public c;
}

contract Question59{
    /*
    현재시간을 받고 2일 후의 시간을 설정하는 함수를 같이 구현하세요.
    */
    uint public later;

    function setTwoDays() public {
        uint currentTime = block.timestamp;
        
        later = currentTime + 2 days;
    } 
}

contract Question60{
    /*
    방이 2개 밖에 없는 펜션을 여러분이 운영합니다. 각 방마다 한번에 3명 이상 투숙객이 있을 수는 없습니다. 특정 날짜에 특정 방에 누가 투숙했는지 알려주는 자료구조와 그 자료구조로부터 값을 얻어오는 함수를 구현하세요.    
    예약시스템은 운영하지 않아도 됩니다. 과거의 일만 기록한다고 생각하세요.    
    힌트 : 날짜는 그냥 숫자로 기입하세요. 예) 2023년 5월 27일 → 230527
    */

    mapping (uint => mapping(uint => string[2])) reservation;

    function setReservation(uint _date, uint _room, string[2] memory _names) public {
        require(_room < 2, "no room");
        reservation[_date][_room] = _names;
    }

    function getReservation(uint _date) public view returns(string[2] memory, string[2] memory) {
        return (reservation[_date][0], reservation[_date][1]);
    }
}