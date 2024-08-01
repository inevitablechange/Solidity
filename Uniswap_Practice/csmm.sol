// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CSMM is ERC20("lion_liquidity", "lion") {
    IERC20 token_A;
    IERC20 token_B;
 
    constructor(address _token_A, address _token_B) {
        token_A = IERC20(_token_A);
        token_B = IERC20(_token_B);
    }

    function getCurrentBal() public view returns(uint, uint) {
        //각 토큰의 pool balance
        uint balance_A = token_A.balanceOf(address(this));
        uint balance_B = token_B.balanceOf(address(this));

        return (balance_A, balance_B);
    }

    //mint
    function addLiquidity(address _addr1, uint _n1) public {
        require(_addr1 == address(token_A) || _addr1 == address(token_B), "not allowed");
        (uint balance_A, uint balance_B) = getCurrentBal();

        bool isAToken = _addr1 == address(token_A);

        IERC20 token1 = isAToken ? token_A : token_B;
        IERC20 token2 = isAToken ? token_B : token_A;

        uint _n2 = isAToken ? _n1 * balance_B / balance_A : _n1 * balance_A / balance_B;


        //user > pool에 유동성 공급
        token1.transferFrom(msg.sender, address(this), _n1);
        token2.transferFrom(msg.sender, address(this), _n2);

        //LP Token Mint
        uint total = totalSupply();
        if(total > 0) {
            _mint(msg.sender, total * (_n1 + _n2) / (balance_A + balance_B));
        } else {
            //total supply가 0일 때 (분모가 없기 때문에 임의적으로 정해줘야 한다 아래의 경우에는 3:1비율)
            _mint(msg.sender, 2 * _n1);
        }
    } 

    function withdrawLiquidity(uint _n) public {
        //LP Token Burn 후 Liquidity 제거
        _burn(msg.sender, _n);
        token_A.transfer(msg.sender, _n/2);
        token_B.transfer(msg.sender, _n/2);
    } 

    function swap(address _tokenAddr, uint _amount) public {
        require(_tokenAddr == address(token_A) || _tokenAddr == address(token_B), "check address");
        bool isA = _tokenAddr == address(token_A);

        if(isA) { //A 판매(pool 에 들어옴), B 구매 (pool에서 나감)
            token_A.transferFrom(msg.sender, address(this), _amount); //돈 받는 거 먼저 코드 실행할 것
            token_B.transfer(msg.sender,_amount * 99 / 100); //fee 1% 가정
        } else { //B 판매(pool 에 들어옴), A 구매 (pool에서 나감)
            token_B.transferFrom(msg.sender, address(this), _amount); //돈 받는 거 먼저 코드 실행할 것
            token_A.transfer(msg.sender,_amount * 99 / 100); //fee 1% 가정
        }
    }
}

contract Token_A is ERC20("A Token", "A") {
    function mint() public {
        _mint(msg.sender,100);
    }
}

contract Token_B is ERC20("B Token", "B") {
    function mint() public {
        _mint(msg.sender,100);
    }
}