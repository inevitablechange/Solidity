// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ICO_Test is ERC1155{
    struct User {
        address addr;
        uint[] tokensBought;
    }

    uint[4] tokenPrice = [
        10000000000000000,
        50000000000000000,
        100000000000000000,
        200000000000000000
    ];

    address owner;
    User[] users;

    constructor() ERC1155(""){
        owner = msg.sender;
    }

    // 토큰 구매 함수
    function buyToken(uint _tokenId, uint _amount) public payable {
        require(tokenPrice[_tokenId] * _amount == msg.value, "check amount");

    }

    // 실행 시 지급해야 할 토큰의 1/2 일괄 지급 (각 토큰개수 * 1/2 기능 추가 필요)
    function giveTokens() public {
        require(msg.sender == owner);
        
        uint[] memory tokenIds = new uint[] (4);
        for(uint i=0;i<4;i++) {
            tokenIds[i] = i+1;
        }

        for(uint j=0; j<users.length;j++) {
            safeBatchTransferFrom(address(this), users[j].addr, tokenIds, users[j].tokensBought, "0x0");
        }
    }

    // 토큰 판매량 기록 함수
    function getMintedAmount() public {

    }

    // 가격 2배로 올리는 함수
    function doublePrice() public {
        require(msg.sender == owner, "only Owner");
        for(uint i=0;i<tokenPrice.length;i++) {
            tokenPrice[i] *= 2;
        }
    }

    // Owner 인출 함수
    function withdraw(uint _amount) public {
        require(msg.sender == owner);
        payable(owner).transfer(_amount);
    }

}