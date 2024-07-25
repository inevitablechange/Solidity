// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TEST2 {
    /*
    학생 점수관리 프로그램입니다.
    여러분은 한 학급을 맡았습니다.
    학생은 번호, 이름, 점수로 구성되어 있고(구조체)
    가장 점수가 낮은 사람을 집중관리하려고 합니다.

    가장 점수가 낮은 사람의 정보를 보여주는 기능,
    총 점수 합계, 총 점수 평균을 보여주는 기능,
    특정 학생을 반환하는 기능, -> 숫자로 반환
    가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    */

    struct student{
        uint number;
        string name;
        uint score;
    }

    student[] students;

    function pushStudent(uint _number, string memory _name, uint _score) public {
        students.push(student(_number,_name,_score));
    }

    //가장 점수가 낮은 사람의 정보를 보여주는 기능
    function lowestScore() public view returns (student memory) {
        student memory lowestScoreStudent = students[0];
        for(uint i=0; i<students.length;i++){
            if(students[i].score < lowestScoreStudent.score){
                lowestScoreStudent = students[i];
            }
        }
        return lowestScoreStudent;
    }

    //총 점수 합계, 총 점수 평균을 보여주는 기능,
    function totalScore() public view returns (uint, uint) {
        uint sum;
        for(uint i=0; i<students.length; i++){
            sum += students[i].score;
        }
        return (sum, sum / students.length);
    }

    //특정 학생을 반환하는 기능, -> 학생 정보
    function getStudent(uint _number) public view returns (student memory) {
        for(uint i=0;i<students.length;i++){
            if(students[i].number == _number){
                return students[i];
            }
        }
        revert("Student Not Found");
    }

    // 가능하다면 학생 전체를 반환하는 기능을 구현하세요. ([] <- array)
    function getAllStudents() public view returns (student[] memory) {
        return students;
    }

}
