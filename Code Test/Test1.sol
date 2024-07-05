// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test1{
    /*
    시간 : 30분
    학생이라는 구조체를 만드세요. 학생은 이름, 번호, 점수, 학점(A,B,C,D)으로 구성되어 있습니다.
    학점은 90점 이상이면 A, 80점 이상이면 B, 70점 이상이면 C, 나머지는 F입니다.  
    학생들이 들어가는 array를 구현하고, 학생 정보를 넣는 함수, 정보를 받는 함수를 구현하세요.

    필수 구현 기능 
    * 학생 추가 기능 - 특정 학생의 정보를 추가
    * 학생 정보 조회 기능 - 특정 학생의 정보를 조회
    */

    struct Student {
        string name;
        uint number;
        uint score;
        string grade;
    }

    Student[] students;

    function pushStudent(string memory _name, uint _number, uint _score) public {
        string memory grade;

        if (_score >= 90) {
            grade = "A";
        } else if(_score >=80) {
            grade = "B";
        } else if(_score >=70) {
            grade = "C";
        } else {
            grade = "F";
        }

        students.push(Student(_name, _number, _score, grade));
    }

    function getStudent(string memory _name) public view returns (Student memory) {
        for(uint i=0; i<students.length;i++){
            if(students[i].name == _name) {
                return students[i];
            }
        }
    }
}