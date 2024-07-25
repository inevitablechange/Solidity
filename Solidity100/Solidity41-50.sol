// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Question41{
    /*
    숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 그 배열에 숫자를 넣는 함수를 구현하세요.
    배열을 초기화하는 함수도 구현하세요. (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
    */

    uint[4] numbers;
    uint counter;

    function setNumber(uint _n) public {
        numbers[counter] = _n;
        counter++;
    }

    function resetNumbers() public {
        delete numbers;
    }
}

contract Question42{
    /*
    이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요.
    새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
    */

    struct customer {
        string name;
        uint number;
        address addr;
    }

    customer[] customers;

    function setCustomer(string memory _name, uint _number) public {
        require(bytes(_name).length >= 5, "name is too short");
        customers.push(customer(_name,_number,msg.sender));

    }
}

contract Question43{
    /*   
    은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다.
    해당 contract에 ether를 예치할 수 있는 기능을 만드세요. 또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요.
    힌트 : mapping을 꼭 이용하세요.
    */
    mapping(address => uint) balances;

    function deposit() public payable returns (uint) {
        balances[msg.sender] += msg.value;
        return msg.value;
    }

    function withdraw() public {
        payable(msg.sender).transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
    }

    function currentBalance() public view returns(uint) {
        return balances[msg.sender];
    }

}

contract Question44{
    /* 
    string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
    */
    string[] strings;
    function pushString(string memory _string) public {
        require(bytes(_string).length >= 4, "too short");
        strings.push(_string);
    } 
}

contract Question45{
    /*
    숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
    */
    uint[] numbers;

    function pushNumber(uint _n) public {
        require(_n <= 100, "need to be lower than 100");
        numbers.push(_n);
    }
}

contract Question46{
    /*   
    3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
    (예 : 15 -> 가능, 3의 배수 // 40 -> 가능, 10의 배수이면서 50보다 작음 // 66 -> 가능, 3의 배수 // 70 -> 불가능 10의 배수이지만 50보다 큼)
    */
    uint[] numbers;
    function pushNumber(uint _n) public {
        require(_n <= 50 && (_n % 3 == 0 || _n % 10 == 0));
        numbers.push(_n);
    }
}

contract Question47{
    /*
    배포와 함께 배포자가 owner로 설정되게 하세요. owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
    */
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _addr) public {
        require(msg.sender == owner);
        owner = _addr;
    }
}


/*
A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
*/

contract Question48_A{
    function add(uint _n1, uint _n2) public pure returns (uint){
        return _n1 + _n2;        
    }
}

contract Question48_B{
    Question48_A a = new Question48_A();

    //a의 상태변수를 바꾸는 게 아니여서 a의 컨트랙트 주소를 넣을 필요가 없다
    function contractA_add() public view returns (uint) {
        return a.add(2,3);
    }
}

contract Question49{
    /*        
    긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
    예) 459273 → 273 // 492871 → 871 // 92218 → 218
    */

    function getLastThree(uint _n) public pure returns(uint) {
        return _n % 1000;
    }
}

contract Question50{
    /*        
    숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요. 
    예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15 
    응용 문제 : 3개 아닌 n개의 숫자 이어붙이기
    */
    function concatNumbers(uint[] memory numbers) public pure returns(uint) {
        uint result;
        for(uint i=0;i<numbers.length;i++) {
            result += numbers[i] * 10 ** (numbers.length - i - 1);
        }
        return result;
    }
}

contract TOSTRING {
    function A(uint _a) public pure returns(string memory) {
        return Strings.toString(_a);
    }

    // string.concat(a,b);
    function getNumbers(uint[] memory _numbers) public pure returns(string memory) {
        string memory _res;
        for(uint i=0; i<_numbers.length; i++) {
            _res = string.concat(_res, Strings.toString(_numbers[i]));
        }
        return _res;
    }

    function getDigits(uint _num) public pure returns(uint) {
        uint idx = 1;
        while(_num >= 10) {
            _num = _num/10;
            idx ++;
        }

        return idx;
    }

    function uintToBytes(uint8 _num) public pure returns(bytes1) {
        return bytes1(_num);
    }

    function uintToString(uint _num) public pure returns(string memory) {
        if (_num == 0) {
            return "0";
        } else{
            uint digits = getDigits(_num);
            bytes memory _b = new bytes(digits);

            while(_num != 0) {
                digits--;
                _b[digits] = bytes1(uint8(48+_num%10));
                _num /= 10;
            }
        return string(_b);

        }

    }

    function FINAL(uint[] memory _num) public pure returns(string memory) {
        bytes memory _b = new bytes(_num.length);
        for(uint i=0; i<_num.length; i++) {
            _b = abi.encodePacked(_b, uintToString(_num[i]));
        }

        return string(abi.encodePacked(_b));
    }
}