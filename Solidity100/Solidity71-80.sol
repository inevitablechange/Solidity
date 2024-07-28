// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Question71 {
    /* 
    숫자형 변수 a를 선언하고 a를 바꿀 수 있는 함수를 구현하세요.
    한번 바꾸면 그로부터 10분동안은 못 바꾸게 하는 함수도 같이 구현하세요.
    */
    uint public a;
    uint public timer;

    constructor () {
        timer = block.timestamp;
    }
    
    function setA(uint _a) public {
        require(block.timestamp > timer, "10 minutes");
        a = _a;
        timer = block.timestamp + 10 minutes;
    }
}

contract Question72 {
    /* 
    contract에 돈을 넣을 수 있는 deposit 함수를 구현하세요.
    해당 contract의 돈을 인출하는 함수도 구현하되 오직 owner만 할 수 있게 구현하세요.
    owner는 배포와 동시에 배포자로 설정하십시오. 한번에 가장 많은 금액을 예치하면 owner는 바뀝니다.
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 deposit(D), E가 65 deposit(E가 owner)
    */
    struct Customer{
        address addr;
        uint totalAmount;
    }
    struct Owner {
        address addr;
        uint highestAmount;
    }

    Customer[] customers;
    Owner public owner;

    constructor () {
        owner = Owner(msg.sender, 0);
    }

    function getCustomers() public view returns(Customer[] memory){ 
        return customers;
    }

    function deposit() public payable {
        bool alreadyExists;
        for(uint i=0; i<customers.length; i++) {
            if(customers[i].addr == msg.sender) {
                customers[i].totalAmount += msg.value;
                alreadyExists = true;
                if(msg.value > owner.highestAmount) {
                    owner = Owner(msg.sender, msg.value);
                }
            }
        }

        if(!alreadyExists) {
            customers.push(Customer(msg.sender, msg.value));
            if(msg.value > owner.highestAmount) {
                owner = Owner(msg.sender, msg.value);
            }
        }

    }

    function withdraw(uint _amount) public {
        require(owner.addr == msg.sender, "only owner");

        payable(owner.addr).transfer(_amount);
    }


}

contract Question73 {
    /* 
    위의 문제의 다른 버전입니다. 누적으로 가장 많이 예치하면 owner가 바뀌게 구현하세요.
    예) A (배포 직후 owner), B가 20 deposit(B가 owner), C가 10 deposit(B가 여전히 owner), D가 50 deposit(D가 owner), E가 20 deposit(D), E가 45 deposit(E가 owner, E 누적 65), E가 65 deposit(E)
    */
    struct Customer{
        address addr;
        uint totalAmount;
    }
    struct Owner {
        address addr;
        uint totalAmount;
    }

    Customer[] customers;
    Owner public owner;

    constructor () {
        owner = Owner(msg.sender, 0);
    }

    function getCustomers() public view returns(Customer[] memory){ 
        return customers;
    }

    function deposit() public payable {
        bool alreadyExists;
        for(uint i=0; i<customers.length; i++) {
            if(customers[i].addr == msg.sender) {
                customers[i].totalAmount += msg.value;
                alreadyExists = true;
                if(customers[i].totalAmount > owner.totalAmount) {
                    owner = Owner(msg.sender, customers[i].totalAmount);
                }
            }
        }

        if(!alreadyExists) {
            customers.push(Customer(msg.sender, msg.value));
            if(msg.value > owner.totalAmount) {
                owner = Owner(msg.sender, msg.value);
            }
        }

    }

    function withdraw(uint _amount) public {
        require(owner.addr == msg.sender, "only owner");

        payable(owner.addr).transfer(_amount);
    }


}

contract Question74 {
    /* 
    어느 숫자를 넣으면 항상 10%를 추가로 더한 값을 반환하는 함수를 구현하세요.
    예) 20 -> 22(20 + 2, 2는 20의 10%), 0 // 50 -> 55(50+5, 5는 50의 10%), 0 // 42 -> 46(42+4), 4 (42의 10%는 4.2 -> 46.2, 46과 2를 분리해서 반환) // 27 => 29(27+2), 7 (27의 10%는 2.7 -> 29.7, 29와 7을 분리해서 반환)
    */
    function mul(uint _num) public pure returns(uint) {
        return _num * 11 / 10;
    }
}

contract Question75 {
    /* 
    문자열을 넣으면 n번 반복하여 쓴 후에 반환하는 함수를 구현하세요.
    예) abc,3 -> abcabcabc // ab,5 -> ababababab
    */
    function ntimes(string memory _string, uint _n) public pure returns(string memory) {
        string memory tmp;
        for(uint i=0;i<_n;i++) {
            tmp = string.concat(tmp, _string);
        }
        return tmp;
    }
}

contract Question76 {
    /* 
    숫자 123을 넣으면 문자 123으로 반환하는 함수를 직접 구현하세요. 
    (패키지없이)
    */

    function getDigits(uint _num) public pure returns(uint) {
        uint count;
        while (_num > 0) {
            _num /= 10;
            count++;
        }

        return count;
    }

    function toStrings(uint _num) public pure returns(string memory) {
        uint digits = getDigits(_num);

        bytes memory _numBytes = new bytes (digits);
        
        for(uint i=digits; i > 0; i--) {
            _numBytes[digits - 1] = bytes1(uint8(_num % 10 + 48));
            _num /= 10;
        }

        return string(_numBytes);
    }

}

import "@openzeppelin/contracts/utils/Strings.sol";
contract Question77 {
    /* 
    위의 문제와 비슷합니다. 이번에는 openzeppelin의 패키지를 import 하세요.
    힌트 : import "@openzeppelin/contracts/utils/Strings.sol";
    */
    function numToString(uint _num) public pure returns(string memory) {
        return Strings.toString(_num);
    }
}

contract Question78 {
    /* 
    숫자만 들어갈 수 있는 array를 선언하세요. array 안 요소들 중 최소 하나는 10~25 사이에 있는지를 알려주는 함수를 구현하세요.
    예) [1,2,6,9,11,19] -> true (19는 10~25 사이) // [1,9,3,6,2,8,9,39] -> false (어느 숫자도 10~25 사이에 없음)
    */
    uint[] numbers = [1,2,3,9];

    function between10and25() public view returns(bool) {
        for(uint i=0;i<numbers.length;i++) {
            if(numbers[i] >= 10 && numbers[i] <=25) {
                return true;
            }
        }
        return false;
    }
}

/* 
3개의 숫자를 넣으면 그 중에서 가장 큰 수를 찾아내주는 함수를 Contract A에 구현하세요.
Contract B에서는 이름, 번호, 점수를 가진 구조체 학생을 구현하세요.
학생의 정보를 3명 넣되 그 중에서 가장 높은 점수를 가진 학생을 반환하는 함수를 구현하세요.
구현할 때는 Contract A를 import 하여 구현하세요.
*/
contract Question79_A {
    function highest(uint[3] memory _numbers) public pure returns (uint, uint) {
        uint tmp;
        uint idx;

        for(uint i=0; i<3;i++) {
            if(tmp < _numbers[i]){
                tmp = _numbers[i];
                idx = i;
            }
        }
        return (tmp, idx);
    }
}

contract Question79_B{
    struct Student {
        string name;
        uint number;
        uint score;
    }

    Student[3] students;
    Question79_A a = new Question79_A();

    function setStudent() public {
        students[0] = Student("paul",123,45);
        students[1] = Student("aaron",123,56);
        students[2] = Student("joe",123,12);
    }

    function topStudent() public view returns(Student memory) {
        uint[3] memory scores;
        for (uint i=0;i<3;i++) {
            scores[i] = students[i].score;
        }

        (, uint idx) = a.highest(scores);

        return students[idx];
    }
}

contract Question80 {
    /* 
    지금은 동적 array에 값을 넣으면(push) 가장 앞부터 채워집니다.
    1,2,3,4 순으로 넣으면 [1,2,3,4] 이렇게 표현됩니다.
    그리고 값을 빼려고 하면(pop) 끝의 숫자부터 빠집니다. 가장 먼저 들어온 것이 가장 마지막에 나갑니다.
    이런 것들을 FILO(First In Last Out)이라고도 합니다.
    가장 먼저 들어온 것을 가장 먼저 나가는 방식을 FIFO(First In First Out)이라고 합니다.
    push와 pop을 이용하되 FIFO 방식으로 바꾸어 보세요.
    */
    uint[] numbers;
    
    function pushNumber(uint number) public {
        numbers.push(number);
    }

    function popNumber() public {
        require(numbers.length > 0, "no data");
        for(uint i=0; i<numbers.length - 1; i++) {
            numbers[i] = numbers[i+1];
        }
        numbers.pop();
    }

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}


