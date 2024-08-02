// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Question91{
    /*
    배열에서 특정 요소를 없애는 함수를 구현하세요. 
    예) [4,3,2,1,8] 3번째를 없애고 싶음 → [4,3,1,8]
    */
    uint[] numbers;

    function setNumbers(uint[] memory _numbers) public {
        numbers = _numbers;
    }

    function remove(uint _k) public {
        for(uint i=_k;i<numbers.length-1;i++) {
            numbers[i] = numbers[i+1];
        }
        numbers.pop();
    }

    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }

}

contract Question92{
    /*
    특정 주소를 받았을 때, 그 주소가 EOA인지 CA인지 감지하는 함수를 구현하세요.
    */
    function CAorEOA(address _addr) public view returns (string memory) {
        if(_addr.code.length > 0)  {
            return "CA";
        }
        return "EOA";
    }
 
}

contract Question93{
    /*
    다른 컨트랙트의 함수를 사용해보려고 하는데, 그 함수의 이름은 모르고 methodId로 추정되는 값은 있다.
    input 값도 uint256 1개, address 1개로 추정될 때 해당 함수를 활용하는 함수를 구현하세요.
    */
    function useMethodId(address _addr, bytes4 _methodId, uint256 _num, address _addr2) public {
        (bool success, ) =  _addr.call(abi.encodeWithSelector(_methodId, _num, _addr2));
        require(success, "nope");
    }

}

contract Question94{
    /*
    inline - 더하기, 빼기, 곱하기, 나누기하는 함수를 구현하세요.
    */
    function add(uint _a, uint _b) public pure returns(uint result) {
        assembly{
            result := add(_a, _b)
        }
    }

    function sub(uint _a, uint _b) public pure returns(uint result) {
        assembly{
            result := sub(_a, _b)
        }
    }

    function mul(uint _a, uint _b) public pure returns(uint result) {
        assembly{
            result := mul(_a, _b)
        }
    }

    function div(uint _a, uint _b) public pure returns(uint result) {
        assembly{
            result := div(_a, _b)
        }
    }

}

contract Question95{
    /*
    inline - 3개의 값을 받아서, 더하기, 곱하기한 결과를 반환하는 함수를 구현하세요.
    */
    function add(uint _a, uint _b, uint _c) public pure returns(uint result) {
        assembly{
            result := add(add(_a, _b), _c)
        }
    }

    function mul(uint _a, uint _b, uint _c) public pure returns(uint result) {
        assembly{
            result := mul(mul(_a, _b), _c)
        }
    }

}

contract Question96{
    /*
    inline - 4개의 숫자를 받아서 가장 큰수와 작은 수를 반환하는 함수를 구현하세요.
    */
    function highestLowest(uint[4] memory _numbers) public pure returns(uint highest, uint lowest) {
        assembly{
            let start := _numbers // 
            for{let i:=0} lt(i,4) {i := add(i,1)} {
                for{let j:= add(i,1)} lt(j,4) {j := add(j,1)} {
                    if gt(mload(add(start,mul(0x20,j))),mload(add(start,mul(0x20,i)))) {
                        let tmp := mload(add(start,mul(0x20,j)))
                        mstore(add(start,mul(0x20,j)), mload(add(start,mul(0x20,i))))
                        mstore(add(start,mul(0x20,i)), tmp)
                    }
                }
            }
            highest := mload(start)
            lowest := mload(add(start,mul(0x20,3)))
        }
    }
}

contract Question97{
    /*
    inline - 상태변수 숫자만 들어가는 동적 array numbers에 push하고 pop하는 함수 그리고 전체를 반환하는 구현하세요.
    */
    uint[] numbers;

    function setNumbers(uint[] memory _numbers) public {
        numbers = _numbers;
    }

    function getNumbers() public view returns(uint[] memory) {
        return numbers;
    }

    function pushArray(uint _number) public {
        assembly {
            let slot := numbers.slot
            let length := sload(numbers.slot)

            let pushSlot := add(keccak256(0x0,0x20),length)

            sstore(slot, add(length,1))
            sstore(pushSlot, _number)
        }
    }

    function popArray() public {
        assembly {
            let slot := numbers.slot
            let length := sload(numbers.slot)

            let popSlot := add(keccak256(0x0,0x20),sub(length,1))

            sstore(popSlot, 0)
            sstore(slot, sub(length,1))
        }
    }
}


contract Question98{    
    /*
    inline - 상태변수 문자형 letter에 값을 넣는 함수 setLetter를 구현하세요..
    */
    string public letter;


    function setLetter(string memory _letter) public {
        assembly {
            let length := mload(_letter)
            let slotNum := letter.slot
            let slots := add(div(length, 32),1)

            //bytes and string storage 방법 확인 : https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html
            if lt(length, 31) { 
            let sum := add(mload(add(_letter,0x20)), mul(length,2))
            sstore(slotNum, sum)
            } 
            if gt(length, 32) {
                sstore(slotNum, add(mul(length,2),1))
                for {let i:=0} lt(i,slots) {i := add(i,1)} {
                    sstore(add(keccak256(slotNum,0x20),i),mload(add(_letter,mul(0x20,add(i,1)))))
                }
            }
        }
    }

}

contract Question99{    
    /*
    inline - bytes4형 b의 값을 정하는 함수 setB를 구현하세요.
    */
    bytes4 public b = 0x61231321;

    function setB(bytes4 _b) public returns(bytes32 result){
        assembly{
            let shiftedB := shr(224, _b) 
            sstore(b.slot, shiftedB)
            result := sload(b.slot)
        }
    }
}

contract Question100{

    bytes public b = "0x1234";

    /*
    inline - bytes형 변수 b의 값을 정하는 함수 setB를 구현하세요.
    */
    function setB(bytes memory _b) public {
        assembly{
            let length := mload(_b)
            let slotNum := b.slot
            let slots := add(div(length, 32),1)

            //bytes and string storage 방법 확인 : https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html
            if lt(length, 31) { 
            let sum := add(mload(add(_b,0x20)), mul(length,2))
            sstore(slotNum, sum)
            } 
            if gt(length, 32) {
                sstore(slotNum, add(mul(length,2),1))
                for {let i:=0} lt(i,slots) {i := add(i,1)} {
                    sstore(add(keccak256(slotNum,0x20),i),mload(add(_b,mul(0x20,add(i,1)))))
                }
            }
        }
    }

}
        


