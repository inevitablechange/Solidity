// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Original {
    uint public number;

    function setNumber(uint _number) public {
        number = _number;
    }
}

contract Original_2 {
        uint public number;
        string public letter;
        bytes4 public b;

    function setAll(uint _number, string memory _letter, bytes4 _b) public {
        (number, letter, b) = (_number, _letter, _b);
    }
}

contract Call {
    uint public number;
    
    function callOriginal(address _addr, uint _number) public returns (bytes memory) {
    (bool success, bytes memory data) = _addr.call(abi.encodeWithSignature("setNumber(uint256)", _number));
        require(success, "Failed");
        return data;
    }
}

contract Delegate_Call {
    uint public number;

    function delegateOriginal(address _addr, uint _number) public {
        //다른 컨트랙트의 함수만 사용하고, 상태변수는 여기서 바꿔준다.
        (bool success, ) = _addr.delegatecall(abi.encodeWithSignature("setNumber(uint256)",_number));
        require(success,"nope");
    }
}

contract Delegate_Call2 {
    uint public number2;

    function delegateOriginal(address _addr, uint _number) public {
        //다른 컨트랙트의 함수만 사용하고, 상태변수는 여기서 바꿔준다.
        //(상태변수명은 달라도 상관없다. 슬롯 기준으로 상태변수를 변경하기 때문에. 다만, 타입 변환가능한 것끼리 하거나 같아야한다.)
        (bool success, ) = _addr.delegatecall(abi.encodeWithSignature("setNumber(uint256)",_number));
        require(success,"nope");
    }
}

contract Delegate_Call3 {
    struct Data {
        uint number;
        string letter;
        bytes4 b;
    }

    Data public d;

    function delegateOriginal(address _addr, uint _number, string memory _letter, bytes4 _b) public {
        (bool success, ) = _addr.delegatecall(abi.encodeWithSignature("setAll(uint256,string,bytes4)",_number,_letter,_b));
        require(success,"nope");
    }
}

contract o_addr {
    address public addr;
    
    function setAddress() public {
        addr = msg.sender;
    }
}

contract call_addr {
    address public addr;

    function callSetAddress(address _original) public {
        (bool success, ) = _original.call(abi.encodeWithSignature("setAddress()"));
        require(success, "nope");
    }
}

contract delegatecall_addr {
    address public addr;

    function callSetAddress(address _original) public {
        (bool success, ) = _original.delegatecall(abi.encodeWithSignature("setAddress()"));
        require(success, "nope");
    }
}