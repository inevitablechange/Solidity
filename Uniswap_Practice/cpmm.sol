// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CPMM is ERC20("lion_liquidity", "lion") {
    IERC20 token_A;
    IERC20 token_B;
 
    constructor(address _token_A, address _token_B) {
        token_A = IERC20(_token_A);
        token_B = IERC20(_token_B);
    }

    function getCurrentBal() public view returns(uint, uint, uint) {
        //각 토큰의 pool balance
        uint balance_A = token_A.balanceOf(address(this));
        uint balance_B = token_B.balanceOf(address(this));
        uint k = balance_A * balance_B;

        return (balance_A, balance_B, k);
    }


    //mint
    function addLiquidity(address _addr1, uint _in1) public {
        require(_addr1 == address(token_A) || _addr1 == address(token_B), "not allowed");
        (uint balance_A, uint balance_B, ) = getCurrentBal();
        bool isA = _addr1 == address(token_A);
        uint total = totalSupply();

        IERC20 token1 = isA ? token_A : token_B;
        IERC20 token2 = isA ? token_B : token_A;
        uint balance1 = isA ? balance_A : balance_B;
        uint balance2 = isA ? balance_B : balance_A;
        uint ratio = isA ? 9 : 1;

       
        //user > pool에 유동성 공급
        if(total == 0) {
                token1.transferFrom(msg.sender,address(this), _in1);
                token2.transferFrom(msg.sender,address(this), _in1 * ratio / 3);
                _mint(msg.sender, _in1);
        } else {
                token1.transferFrom(msg.sender,address(this), _in1);
                token2.transferFrom(msg.sender,address(this), _in1 * balance2 / balance1);
                _mint(msg.sender, total * _in1 / balance1);
        }
        
    } 

    function withdrawLiquidity(uint _n) public {
        (uint a, uint b, ) = getCurrentBal();

        // a_out, b_out 변수가 있을 때는 문제 없이 인출된다. 하지만, 해당 변수들이 없으면 withdraw할 때 에러가 발생한다.
        // 그 이유는 burn 된 이후에 totalSupply()의 값(분모)이 변해서 원래 transfer하려던 값보다 더 많은 값을 transfer 하려하게 된다.
        uint a_out = a * _n / totalSupply();
        uint b_out = b * _n / totalSupply();

        _burn(msg.sender, _n);

        token_A.transfer(msg.sender, a_out);
        token_B.transfer(msg.sender, b_out);
    } 

    function swap(address _tokenIn, uint _amountIn) public {
        require(_tokenIn == address(token_A) || _tokenIn == address(token_B), "not allowed");
        (uint balance_A, uint balance_B, uint k) = getCurrentBal();

        bool isA = _tokenIn == address(token_A);

        IERC20 token1 = isA ? token_A : token_B;
        IERC20 token2 = isA ? token_B : token_A;
        uint balance1 = isA ? balance_A : balance_B;
        uint balance2 = isA ? balance_B : balance_A;

        uint amountOut = balance2 - k / (balance1 + _amountIn); 
        token1.transferFrom(msg.sender, address(this), _amountIn);
        token2.transfer(msg.sender, amountOut * 99 / 100);
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