// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract Question81{
    /*
    Contract에 예치, 인출할 수 있는 기능을 구현하세요.
    지갑 주소를 입력했을 때 현재 예치액을 반환받는 기능도 구현하세요.
    */
    mapping(address => uint) balances;

    function deposit() public payable returns(uint) {
        balances[msg.sender] += msg.value;
        return msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "not enough money");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function getDeposit(address _addr) public view returns(uint) {
        return balances[_addr];
    }
}

contract Question82{
    /*
    특정 숫자를 입력했을 때 그 숫자까지의 3,5,8의 배수의 개수를 알려주는 함수를 구현하세요.
    */
    function multiples(uint _number) public pure returns(uint, uint, uint) {
        return (_number / 3, _number / 5, _number / 8);
    }
}

contract Question83{
    /*
    이름, 번호, 지갑주소 그리고 숫자와 문자를 연결하는 mapping을 가진 구조체 사람을 구현하세요.
    사람이 들어가는 array를 구현하고 array안에 push 하는 함수를 구현하세요.
    */
    struct Person {
        string name;
        uint number;
        address addr;
        mapping(uint => string) map;
    }

    Person[] public people;

    function  pushPerson(string memory _name, uint _number, address _addr, uint _n, string memory _s) public {
        Person storage newPerson = people.push();
        newPerson.name = _name;
        newPerson.number = _number;
        newPerson.addr = _addr;
        newPerson.map[_n] = _s;
    }
}

contract Question84{
    /*
    2개의 숫자를 더하고, 빼고, 곱하는 함수들을 구현하세요.
    단, 이 모든 함수들은 blacklist에 든 지갑은 실행할 수 없게 제한을 걸어주세요.
    */
    mapping(address => bool) blacklist;

    function setBlacklist(address _addr) public {
        blacklist[_addr] = true;
    }

    modifier checkBlacklist() {
        require(!blacklist[msg.sender], "nope");
        _;
    }

    function add(uint _a, uint _b) public view checkBlacklist returns(uint) {
        return _a + _b;
    }

    function sub(uint _a, uint _b) public view checkBlacklist returns(uint) {
        return _a - _b;
    }

    function mul(uint _a, uint _b) public view checkBlacklist returns(uint) {
        return _a * _b;
    }
    
}

contract Question85{
    /*
    숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다.
    찬성, 반대 투표는 배포된 후 20개 블록동안만 진행할 수 있게 해주세요.
    */
    uint pros;
    uint cons;
    uint blockNumber;
    mapping(address=>bool) voted;

    constructor() {
        blockNumber = block.number;
    }

    function vote(bool _vote) public {
        require(blockNumber + 20 >block.number, "cannot vote");
        require(!voted[msg.sender], "already voted");

        if(_vote) {
            pros++;
        } else {
            cons++;
        }
        voted[msg.sender] = true;
    }
}

contract Question86{
    /*
    숫자 변수 2개를 구현하세요. 한개는 찬성표 나머지 하나는 반대표의 숫자를 나타내는 변수입니다.
    찬성, 반대 투표는 1이더 이상 deposit한 사람만 할 수 있게 제한을 걸어주세요.
    */
    uint pros;
    uint cons;
    mapping(address=>uint) balances;
    mapping(address=>bool) voted;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function vote(bool _vote) public {
        require(balances[msg.sender] >= 1 ether , "1 ether");
        require(!voted[msg.sender], "already voted");

        if(_vote) {
            pros++;
        } else {
            cons++;
        }
        voted[msg.sender] = true;
    }
}

contract Question87{
    /*
    visibility에 신경써서 구현하세요. 
    숫자 변수 a를 선언하세요. 해당 변수는 컨트랙트 외부에서는 볼 수 없게 구현하세요.
    변화시키는 것도 오직 내부에서만 할 수 있게 해주세요. 
    */
    uint private a;
    function setA(uint _a) private {
        a = _a;
    }
}


contract OWNER {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function setInternal(address _a) internal {
        owner = _a;
    }

    function getOwner() public view returns(address) {
        return owner;
    }
}

contract Question88 is OWNER{    
    /*
    아래의 코드를 보고 owner를 변경시키는 방법을 생각하여 구현하세요.
        contract OWNER {
            address private owner;
        
            constructor() {
                owner = msg.sender;
            }
        
            function setInternal(address _a) internal {
                owner = _a;
            }
        
            function getOwner() public view returns(address) {
                return owner;
            }
        }
        힌트 : 상속
    */

    function callInternal(address _a) public {
        setInternal(_a);
    }

}

contract Question89{    
    /*
    이름과 자기 소개를 담은 고객이라는 구조체를 만드세요.
    이름은 5자에서 10자이내 자기 소개는 20자에서 50자 이내로 설정하세요.
    (띄어쓰기 포함 여부는 신경쓰지 않아도 됩니다. 더 쉬운 쪽으로 구현하세요.)
    */
    struct Customer {
        string name;
        string description;
    }

    Customer[] customers;

    function setCustomer(string memory _name, string memory _description) public returns (uint) {
        require(bytes(_name).length >= 5 && bytes(_name).length <= 10, "name");
        require(bytes(_description).length >= 20 && bytes(_description).length <= 50, "description");

        customers.push(Customer(_name, _description));
        return bytes(_name).length;
    }
}

contract Question90{
    /*
    당신 지갑의 이름을 알려주세요. 아스키 코드를 이용하여 byte를 string으로 바꿔주세요.
    */
    function getNameofAddress() public view returns(string memory) {
       return string(abi.encodePacked(bytes20(msg.sender)));
    }
}
        


