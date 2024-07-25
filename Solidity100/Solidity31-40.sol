// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Question31{
    /*
    string을 input으로 받는 함수를 구현하세요. "Alice"나 "Bob"일 때에만 true를 반환하세요.
    */
    function aliceOrBob(string memory _name) public pure returns(bool) {
        if(keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Alice")) || keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Bob"))) {
            return true;
        } 
        return false;
    }
}

contract Question32{
    /*
    3의 배수만 들어갈 수 있는 array를 구현하되, 3의 배수이자 동시에 10의 배수이면 들어갈 수 없는 추가 조건도 구현하세요.
    예) 3 → o , 9 → o , 15 → o , 30 → x
    */
    uint[] numbers;
    function array(uint _number) public {
        require(_number % 3 == 0, "multiples of three");
        require(_number % 10 != 0, "multiples of ten not allowed");

        numbers.push(_number);
    }
}

contract Question33{
    /*
    이름, 번호, 지갑주소 그리고 생일을 담은 고객 구조체를 구현하세요. 고객의 정보를 넣는 함수와 고객의 이름으로 검색하면 해당 고객의 전체 정보를 반환하는 함수를 구현하세요.
    */
    struct customer {
        string name;
        uint number;
        address addr;
        uint birthday;
    }

    customer[] customers;

    function pushCustomer(string memory _name, uint _number, address _addr, uint _birthday) public {
        customers.push(customer(_name,_number,_addr,_birthday));
    }

    function searchCustomer(string memory _name) public view returns(customer memory) {
        for(uint i=0;i<customers.length;i++) {
            if(keccak256(abi.encodePacked(customers[i].name)) == keccak256(abi.encodePacked(_name))){
                return customers[i];
            }
        }
        revert ("customer not found");
    }
}

contract Question34{
    /*
    이름, 번호, 점수가 들어간 학생 구조체를 선언하세요. 학생들을 관리하는 자료구조도 따로 선언하고 학생들의 전체 평균을 계산하는 함수도 구현하세요.
    */
    struct student {
        string name;
        uint number;
        uint score;
    }

    student[] students;

    function pushStudent(string memory _name, uint _number, uint _score) public {
        students.push(student(_name,_number,_score));
    }

    function getAvgScore() public view returns(uint) {
        uint result;
        for(uint i=0; i<students.length; i++) {
            result += students[i].score;
        }
        return result / students.length;
    }

}

contract Question35{
    /*
    5. 숫자만 들어갈 수 있는 array를 선언하고 해당 array의 짝수번째 요소만 모아서 반환하는 함수를 구현하세요.
    예) [1,2,3,4,5,6] -> [2,4,6] // [3,5,7,9,11,13] -> [5,9,13]
    */
    uint[] numbers;

    function pushNumbers() public {
        for(uint i=0;i<7;i++){
            numbers.push(i);
        }
    }
    
    function filterNumbers() public view returns(uint[] memory){
        uint count;
        for(uint i=0; i<numbers.length;i++) {
            if(numbers[i] % 2 == 0) {
                count++;
            }
        }

        uint[] memory evenNumbers = new uint[](count);
        uint j;
        for(uint i=0;i<numbers.length;i++) {
            if(numbers[i] % 2 == 0) {
                evenNumbers[j] = numbers[i];
                j++;
            }
        }
        return evenNumbers;
    }
}

contract Question36{
    /*
    high, neutral, low 상태를 구현하세요. a라는 변수의 값이 7이상이면 high, 4이상이면 neutral 그 이후면 low로 상태를 변경시켜주는 함수를 구현하세요.
    */
    enum status{
        high,
        neutral,
        low
    }
    
    status public Status;

    function setStatus(uint _a) public {
        if(_a >= 7) {
            Status = status.high;
        } else if(_a>=4) {
            Status = status.neutral;
        } else {
            Status = status.low;
        }
    }

}

contract Question37{
    /*
    1 wei를 기부하는 기능, 1finney를 기부하는 기능 그리고 1 ether를 기부하는 기능을 구현하세요. 최초의 배포자만이 해당 smart contract에서 자금을 회수할 수 있고 다른 이들은 못하게 막는 함수도 구현하세요.
    (힌트 : 기부는 EOA가 해당 Smart Contract에게 돈을 보내는 행위, contract가 돈을 받는 상황)
    */
    address owner;
    constructor () {
        owner = msg.sender;
    }

    function donateOneWei() public payable returns(uint) {
        require(msg.value == 1 wei, "1wei");
        return msg.value;
    }

    function donateOneFinney() public payable returns(uint) {
        require(msg.value == 0.001 ether, "1finney");
        return msg.value;
    }

    function donateOneEther() public payable returns(uint) {
        require(msg.value == 1 ether, "1ether");
        return msg.value;
    }

    function withdraw() public returns(bool) {
        require(owner == msg.sender, "only owner allowed");
        payable(owner).transfer(address(this).balance);
        return true;
    }

}

contract Question38{
    /*
    상태변수 a를 "A"로 설정하여 선언하세요. 이 함수를 "B" 그리고 "C"로 변경시킬 수 있는 함수를 각각 구현하세요. 단 해당 함수들은 오직 owner만이 실행할 수 있습니다. owner는 해당 컨트랙트의 최초 배포자입니다.
    (힌트 : 동일한 조건이 서로 다른 두 함수에 적용되니 더욱 효율성 있게 적용시킬 수 있는 방법을 생각해볼 수 있음)
    */
    string public a = "A";
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setB() public onlyOwner{
        a = "B";
    }

    function setC() public onlyOwner{
        a = "C";
    }
}

contract Question39{
    /*
    특정 숫자의 자릿수까지의 2의 배수, 3의 배수, 5의 배수 7의 배수의 개수를 반환해주는 함수를 구현하세요.
    예) 15 : 7,5,3,2  (2의 배수 7개, 3의 배수 5개, 5의 배수 3개, 7의 배수 2개) // 100 : 50,33,20,14  (2의 배수 50개, 3의 배수 33개, 5의 배수 20개, 7의 배수 14개)
    */
    function getMultiples(uint _num) public pure returns(uint, uint, uint, uint) {
        return (_num/2,_num/3,_num/5,_num/7);
    }
}

contract Question40{
    /*
    숫자를 임의로 넣었을 때 내림차순으로 정렬하고 가장 가운데 있는 숫자를 반환하는 함수를 구현하세요. 가장 가운데가 없다면 가운데 2개 숫자를 반환하세요.
    예) [5,2,4,7,1] -> [1,2,4,5,7], 4 // [1,5,4,9,6,3,2,11] -> [1,2,3,4,5,6,9,11], 4,5 // [6,3,1,4,9,7,8] -> [1,3,4,6,7,8,9], 6
    */
    function test(uint[] memory numbers) public pure returns (uint[] memory, uint[] memory) {
        uint[] memory ascending = numbers;
        for(uint i=0;i<numbers.length;i++) {
            for(uint j=i+1; j<numbers.length;j++) {
                if(numbers[j]<numbers[i]) {
                    (numbers[j], numbers[i]) = (numbers[i], numbers[j]);
                }
             }
        }

        uint[] memory middleNumbers = new uint[](2 - ascending.length % 2);
        if(ascending.length % 2 != 0) {
            middleNumbers[0] = ascending[ascending.length / 2];
            return (ascending, middleNumbers);
        } else {
            middleNumbers[0] = ascending[ascending.length / 2 - 1];
            middleNumbers[1] = ascending[ascending.length / 2];
            return (ascending, middleNumbers);
        }
    }
}

