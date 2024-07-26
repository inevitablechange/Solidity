// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Question61 {
    /* 
    a의 b승을 반환하는 함수를 구현하세요.
    */
    function power(uint _a, uint _b) public pure returns (uint) {
        return _a ** _b;
    }
}

contract Question62 {
    /* 
    2개의 숫자를 더하는 함수, 곱하는 함수 a의 b승을 반환하는 함수를 구현하는데 3개의 함수 모두 2개의 input값이 10을 넘지 않아야 하는 조건을 최대한 효율적으로 구현하세요.
    */
    modifier lessThanTen(uint _a, uint _b) {
        require(_a <= 10 && _b <= 10, "less than 10");
        _;
    }

    function add(uint _a, uint _b) public pure lessThanTen(_a,_b) returns(uint) {
        return _a + _b;
    }

    function mul(uint _a, uint _b) public pure lessThanTen(_a,_b) returns(uint) {
        return _a * _b;
    }

    function power(uint _a, uint _b) public pure lessThanTen(_a,_b) returns(uint) {
        return _a ** _b;
    }
}

contract Question63 {
    /* 
    2개 숫자의 차를 나타내는 함수를 구현하세요.
    */
    function sub(uint _a, uint _b) public pure returns(uint) {
        return _a - _b;
    }
}

contract Question64 {
    /* 
    지갑 주소를 넣으면 5개의 4bytes로 분할하여 반환해주는 함수를 구현하세요.
    */
    function fourBytesAddress(address _addr) public pure returns(bytes4[5] memory) {
        bytes20 addr = bytes20(_addr);
        bytes4[5] memory result;

        for(uint i=0;i<addr.length;i+=4){
            bytes4 tmp = bytes4(abi.encodePacked(addr[i],addr[i+1],addr[i+2],addr[i+3]));
            result[i/4] = tmp;
        }
        
        return result;
    }
    

}

contract Question65 {
    /* 
    숫자 3개를 입력하면 그 제곱을 반환하는 함수를 구현하세요.
    그 3개 중에서 가운데 출력값만 반환하는 함수를 구현하세요.    
    예) func A : input → 1,2,3 // output → 1,4,9 | func B : output 4 (1,4,9중 가운데 숫자) 
    */

    function power(uint[3] memory _numbers) public pure returns(uint[3] memory) {
        uint[3] memory newNumbers = _numbers;

        for(uint i=0;i<newNumbers.length;i++) {
            newNumbers[i] = newNumbers[i] ** 2;
        }
        
        return newNumbers;
    }
    
    function middleNumber(uint[3] memory _numbers) public pure returns(uint) {
        return power(_numbers)[1];
    }
}

contract Question66 {
    /* 
    특정 숫자를 입력했을 때 자릿수를 알려주는 함수를 구현하세요.
    추가로 그 숫자를 5진수로 표현했을 때는 몇자리 숫자가 될 지 알려주는 함수도 구현하세요.
    */
    function countLength(uint _number) public pure returns(uint) {
        uint count;
        while(_number > 0) {
            _number /= 10;
            count ++;
        }
        return count;
    }

    function countLength2(uint _number) public pure returns(uint) {
        uint count;
        while(_number > 0) {
            _number /= 5;
            count ++;
        }
        return count;
    }

}


/* 
자신의 현재 잔고를 반환하는 함수를 보유한 Contract A와 다른 주소로 돈을 보낼 수 있는 Contract B를 구현하세요.
B의 함수를 이용하여 A에게 전송하고 A의 잔고 변화를 확인하세요.
*/
contract Question67_A {
    receive () external payable {
    }

    function getBalances() public view returns(uint) {
        return address(this).balance;
    }
}

contract Question67_B {

    function receiveEther() public payable returns(uint){
        return msg.value;
    }

    function sendEther(address payable _addr, uint _amount) public {
        require(address(this).balance >= _amount, "not enough balance");
        _addr.transfer(_amount);
    }

}


contract Question68 {
    /* 
    계승(팩토리얼)을 구하는 함수를 구현하세요. 계승은 그 숫자와 같거나 작은 모든 수들을 곱한 값이다. 
    예) 5 → 1*2*3*4*5 = 120, 11 → 1*2*3*4*5*6*7*8*9*10*11 = 39916800
    while을 사용해보세요
    */
    function factorial(uint _number) public pure returns(uint){
        uint result = 1;
        for(uint i=2;i<=_number;i++) {
            result *= i;
        }
        return result;
    }

}

contract Question69 {
    /* 
    숫자 1,2,3을 넣으면 1 and 2 or 3 라고 반환해주는 함수를 구현하세요.
    */
    function processNumbers(uint[] memory numbers) public pure returns (string memory) {
        require(numbers[0] == 1 && numbers[1] == 2 && numbers[2] == 3, "Numbers must be 1, 2, 3 in order");
    
        return "1 and 2 or 3";
    }

}

contract Question70 {
    /* 
    번호와 이름 그리고 bytes로 구성된 고객이라는 구조체를 만드세요. bytes는 번호와 이름을 keccak 함수의 input 값으로 넣어 나온 output값입니다. 고객의 정보를 넣고 변화시키는 함수를 구현하세요.
    */
    struct Customer {
        uint number;
        string name;
        bytes something;
    }

    Customer[] customers;

    function setCustomer(uint _number, string memory _name) public {
        bytes memory something = bytes(abi.encodePacked(keccak256(abi.encodePacked(_number, _name))));
        customers.push(Customer(_number, _name, something));
    }

}