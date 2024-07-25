// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test8 {
/*
안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요. 

사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
*/

    struct User {
        string name;
        address addr;
        string[] issues;
        mapping(string =>bool) votes;
    }

    struct Issue {
        uint number;
        string title;
        string body;
        address issuer;
        uint yes;
        uint no;
    }

    mapping(address => User) users;
    mapping(string => Issue) issues;
    mapping(address => mapping(string => uint)) IssueVoteCount;
    uint issueCounts = 1;

    // 사용자 등록 기능 - 사용자를 등록하는 기능
    function setUser(string memory _name) public {
        require(bytes(users[msg.sender].name).length == 0, "already registered");
        require(bytes(_name).length > 0, "name is too short");
        users[msg.sender].name = _name;
        users[msg.sender].addr = msg.sender;
        users[msg.sender].issues = [""];
    }

    // 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function voteForIssue(string memory _title, bool _vote) public {
        require(IssueVoteCount[msg.sender][_title] == 0, "already voted");
        if (_vote) {
            issues[_title].yes++;
        } else {
            issues[_title].no--;
        }
        IssueVoteCount[msg.sender][_title]++;
    }

    // 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    function setIssue(string memory _title, string memory _body) public {
        require(issues[_title].number == 0, "issue already exists");
        issues[_title].number = issueCounts;
        issues[_title].title = _title;
        issues[_title].body = _body;
        issues[_title].issuer = msg.sender;


        users[msg.sender].issues.push(_title);
    }

    // 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getMyIssue() public view returns(Issue[] memory) {
        string[] memory _issues = users[msg.sender].issues;
        uint length = users[msg.sender].issues.length;

        Issue[] memory myIssues = new Issue[] (length);
        for(uint i=0;i<length;i++) {
            myIssues[i] = issues[_issues[i]];
        }

        return myIssues;
    } 

    // 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getAllIssues(string memory _title) public view returns(Issue memory) {
        return issues[_title];
    } 

    // 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    function currentStatus(string memory _title) public view returns(string memory) {

    }
}
