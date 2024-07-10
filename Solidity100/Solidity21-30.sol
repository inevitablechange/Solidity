// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Question21{
    /*
    3의 배수만 들어갈 수 있는 array를 구현하세요.
    */
    uint[] numbers;

    function MultiplesofThree(uint _num) public {
        require(_num % 3 == 0, "not multiples of three");
        numbers.push(_num);
    }
}

contract Question22{
    /*
    뺄셈 함수를 구현하세요. 임의의 두 숫자를 넣으면 자동으로 둘 중 큰수로부터 작은 수를 빼는 함수를 구현하세요.
    예) 2,5 input → 5-2=3(output)
    */
    function subtract(uint _a, uint _b) public pure returns(uint) {
        if(_a > _b) {
            return _a - _b;
        }
        return _b - _a;
    }
}

contract Question23{
    /*
    3의 배수라면 “A”를, 나머지가 1이 있다면 “B”를, 나머지가 2가 있다면 “C”를 반환하는 함수를 구현하세요.
    */ 
    function ABC(uint _num) public pure returns(string memory) {
        if(_num % 3 == 0) {
            return "A";
        } else if(_num % 3 == 1) {
            return "B";
        }
        return "C";
    }


}

contract Question24{
    /*
    string을 input으로 받는 함수를 구현하세요. “Alice”가 들어왔을 때에만 true를 반환하세요.
    */
    function onlyAlice(string memory _name) public pure returns(bool) {
        return keccak256(abi.encodePacked(_name)) == keccak256(abi.encodePacked("Alice")); 
    }
}

contract Question25{
    /*
    배열 A를 선언하고 해당 배열에 n부터 0까지 자동으로 넣는 함수를 구현하세요. 
    */
    uint[] numbers;
    function addNumbers(uint _n) public {
        for(uint i=_n+1;i>0;i--){
            numbers.push(i-1);
        }
    }

}

contract Question26{
    /*
    홀수만 들어가는 array, 짝수만 들어가는 array를 구현하고 숫자를 넣었을 때 자동으로 홀,짝을 나누어 입력시키는 함수를 구현하세요.
    */
    uint[] oddNumbers;
    uint[] evenNumbers;

    function oddOrEven(uint _n) public {
        if(_n % 2 == 0){
            evenNumbers.push(_n);
        }
        oddNumbers.push(_n);
    }
}

contract Question27{
    /*
    string 과 bytes32를 key-value 쌍으로 묶어주는 mapping을 구현하세요. 해당 mapping에 정보를 넣고, 지우고 불러오는 함수도 같이 구현하세요.
    */
    mapping(string => bytes32) keyValue;

    function addValue(string memory _key, bytes32 _value) public {
        keyValue[_key] = _value;
    }

    function deleteValue(string memory _key) public {
        delete keyValue[_key];
    }

    function getValue(string memory _key) public view returns(bytes32) {
        return keyValue[_key];
    }
}

contract Question28{
    /*
    ID와 PW를 넣으면 해시함수(keccak256)에 둘을 같이 해시값을 반환해주는 함수를 구현하세요.
    */
    function idPassword(string memory _id, string memory _pw) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_id,_pw));
    }
}

contract Question29{
    /*
    숫자형 변수 a와 문자형 변수 b를 각각 10 그리고 “A”의 값으로 배포 직후 설정하는 contract를 구현하세요.
    */
    uint public a;
    string public b;

    constructor(uint _a, string memory _b) {
        a=_a;
        b=_b;
    }
}

contract Question30{
    /*
    임의대로 숫자를 넣으면 알아서 내림차순으로 정렬해주는 함수를 구현하세요
    (sorting 코드 응용 → 약간 까다로움)
    
    예 : [2,6,7,4,5,1,9] → [9,7,6,5,4,2,1]
    */
    
    function descending(uint[] memory _numbers) public pure returns(uint[] memory) {
        for(uint i=0;i<_numbers.length;i++) {
            for(uint j=i+1; j<_numbers.length;j++){
                if(_numbers[i] < _numbers[j]){
                    uint temp;
                    temp = _numbers[j];
                    _numbers[j] = _numbers[i];
                    _numbers[i] = temp;
                }
            }
        }
        return _numbers;
    }

}

