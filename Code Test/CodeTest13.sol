// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test13{
    uint[] public numbers;
    uint[4] public number2;
    
    // 1. 숫자들이 들어가는 동적 array number를 만들고 1~n까지 들어가는 함수를 만드세요.
    function dynamicArray(uint _n) public {
        assembly {
            let length := sload(numbers.slot)
            mstore(0x0, numbers.slot)
            
            // base slot(항상 이걸로 정해짐) + length
            for { let i := 0 } lt(i, _n) { i := add(i, 1) } {
                let nslot := add(keccak256(0x0, 0x20), i)
                sstore(nslot, add(i, 1))
            }
            sstore(numbers.slot, _n)
        }
    }

    // 2. 숫자들이 들어가는 길이 4의 array number2를 만들고 여기에 4개의 숫자를 넣어주는 함수를 만드세요.
    function staticArray(uint[4] memory _numbers) public {
        assembly {
            for { let i := 0 } lt(i, 4) { i := add(i, 1) } {
                sstore(add(number2.slot, i), mload(add(_numbers, mul(i, 0x20))))
            }
        }
    }

    // 3. number의 모든 요소들의 합을 반환하는 함수를 구현하세요.
    function addNumbers() public view returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    // 4. number2의 모든 요소들의 합을 반환하는 함수를 구현하세요.
    function addNumbers2() public view returns (uint) {
        uint sum = 0;
        for (uint i = 0; i < number2.length; i++) {
            sum += number2[i];
        }
        return sum;
    }

    // 5. number의 k번째 요소를 반환하는 함수를 구현하세요.
    function getNumber(uint k) public view returns (uint) {
        require(k < numbers.length, "Index out of bounds");
        return numbers[k];
    }

    // 6. number2의 k번째 요소를 반환하는 함수를 구현하세요.
    function getNumber2(uint k) public view returns (uint) {
        require(k < number2.length, "Index out of bounds");
        return number2[k];
    }
}