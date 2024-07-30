// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TEST10 {
/* 
은행에 관련된 어플리케이션을 만드세요.
은행은 여러가지가 있고, 유저는 원하는 은행에 넣을 수 있다. 
국세청은 은행들을 관리하고 있고, 세금을 징수할 수 있다. 
세금은 간단하게 전체 보유자산의 1%를 징수한다. 세금을 자발적으로 납부하지 않으면 강제징수한다. 

* 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
* 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
* 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
* 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
* 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
* 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
-------------------------------------------------------------------------------------------------
* 은행간 송금 기능 수수료 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
* 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
*/
    address NationalTaxService;

    constructor(address _NationalTaxService) {
        NationalTaxService = _NationalTaxService;
    }

    mapping(address => mapping(address => uint)) balances;
    mapping(address => mapping(address => bool)) registered;

    mapping(address => uint) tax;

    // 회원 가입 기능 - 사용자가 은행에서 회원가입하는 기능
    function register(address _bank) public {
        require(!registered[_bank][msg.sender], "already registered");

        balances[_bank][msg.sender] = 0;
        registered[_bank][msg.sender] = true;
    }

    // 입금 기능 - 사용자가 자신이 원하는 은행에 가서 입금하는 기능
    function deposit(address _bank) public payable{
        require(registered[_bank][msg.sender], "need to register first");

        balances[_bank][msg.sender] += msg.value;
        tax[msg.sender] += msg.value / 100;
    }

    // 출금 기능 - 사용자가 자신이 원하는 은행에 가서 출금하는 기능
    function withdraw(address _bank, uint _amount) public {
        require(registered[_bank][msg.sender], "need to register first");
        require(balances[_bank][msg.sender] > _amount, "not enough money");

        payable(msg.sender).transfer(_amount);
        balances[_bank][msg.sender] -= _amount;
        tax[msg.sender] -= _amount / 100;
    }

    // 은행간 송금 기능 1 - 사용자의 A 은행에서 B 은행으로 자금 이동 (자금의 주인만 가능하게)
    function transferToB(address _bankA, address _bankB, uint _amount) public {
        require(registered[_bankA][msg.sender] && registered[_bankB][msg.sender], "need to register first");
        require(balances[_bankA][msg.sender] > _amount, "not enough money");

        
        balances[_bankA][msg.sender] -= _amount;
        balances[_bankB][msg.sender] += _amount;
    }


    // 은행간 송금 기능 2 - 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동
    // 사용자 1의 A 은행에서 사용자 2의 B 은행으로 자금 이동할 때 A 은행은 그 대가로 사용자 1로부터 1 finney 만큼 수수료 징수.
    function tranferToAnotherUser(address _bankA, address _bankB, uint _amount, address _addr) public {
        require(registered[_bankA][msg.sender], "need to register first");
        require(balances[_bankA][msg.sender] > _amount + 0.001 ether, "not enough money");
        require(registered[_bankB][_addr], "cannot tranfer to non-existing account");

        balances[_bankA][msg.sender] -= _amount + 0.001 ether;
        balances[_bankA][_bankA] += 0.001 ether;
        tax[msg.sender] -= (_amount + 0.001 ether) / 100;

        balances[_bankB][_addr] += _amount;
        tax[_addr] += _amount / 100;
    } 

    // 세금 징수 - 국세청은 주기적으로 사용자들의 자금을 파악하고 전체 보유량의 1%를 징수함. 세금 납부는 유저가 자율적으로 실행. (납부 후에는 납부 해야할 잔여 금액 0으로)
    function payTax() public {
        payable(NationalTaxService).transfer(tax[msg.sender]);

        tax[msg.sender] = 0;
    }


    // 세금 강제 징수 - 국세청에게 사용자가 자발적으로 세금을 납부하지 않으면 강제 징수. 은행에 있는 사용자의 자금이 국세청으로 강제 이동
    function receiveTax(address _bankA, address _bankB) public {
        require(msg.sender == NationalTaxService, "only National Tax Service");

        
        
    }

}