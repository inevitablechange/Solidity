// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TEST2 {
  /*
    여러분은 선생님입니다. 학생들의 정보를 관리하려고 합니다. 
    학생의 정보는 이름, 번호, 점수, 학점 그리고 듣는 수업들이 포함되어야 합니다.

    번호는 1번부터 시작하여 정보를 기입하는 순으로 순차적으로 증가합니다.

    학점은 점수에 따라 자동으로 계산되어 기입하게 합니다. 90점 이상 A, 80점 이상 B, 70점 이상 C, 60점 이상 D, 나머지는 F 입니다.

    필요한 기능들은 아래와 같습니다.

    * 학생 추가 기능 - 특정 학생의 정보를 추가
    * 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
    * 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
    * 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
    * 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
    * 학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    * 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    * 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    * 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    -------------------------------------------------------------------------------
  */

    struct student {
        string name;
        uint number;
        uint score;
        string grade;
        string[] classLists;
    }

    student[] students;

    // 학생 추가 기능 - 특정 학생의 정보를 추가
    function addStudent(string memory _name, uint _score, string[] memory _classLists) public {
        uint number = students.length + 1;
        string memory grade;

        if(_score >= 90) {
            grade = "A";
        } else if(_score >= 80) {
            grade = "B";
        } else if(_score >= 70) {
            grade = "C";
        } else if(_score >= 60) {
            grade = "D";
        } else {
            grade = "F";
        }

        students.push(student(_name,number,_score,grade,_classLists));
    }

    // 학생 조회 기능(1) - 특정 학생의 번호를 입력하면 그 학생 전체 정보를 반환
   function getStudent(uint _number) public view returns(student memory){
        return students[_number-1];
   }

    // 학생 조회 기능(2) - 특정 학생의 이름을 입력하면 그 학생 전체 정보를 반환
   function getStudent2(string memory _name) public view returns(student memory) {
        require(students.length > 0, "no data");

        for(uint i=0; i<students.length; i++) {
            if(keccak256(abi.encodePacked(students[i].name)) == keccak256(abi.encodePacked(_name))) {
                return students[i];
            }
        }
   }

    // 학생 점수 조회 기능 - 특정 학생의 이름을 입력하면 그 학생의 점수를 반환
   function getStudentScore(string memory _name) public view returns(uint) {
        require(students.length > 0, "no data");   

        for(uint i=0; i<students.length; i++) {
            if(keccak256(abi.encodePacked(students[i].name)) == keccak256(abi.encodePacked(_name))) {
                return students[i].score;
            }
        }
   }

    // 학생 전체 숫자 조회 기능 - 현재 등록된 학생들의 숫자를 반환
   function getNumbers() public view returns (uint) {
        return students.length;
   }

    //  학생 전체 정보 조회 기능 - 현재 등록된 모든 학생들의 정보를 반환
    function getStudents() public view returns(student[] memory) {
        return students;
    } 

    // 학생들의 전체 평균 점수 계산 기능 - 학생들의 전체 평균 점수를 반환
    function getAverageScore() public view returns(uint) {
        if(students.length == 0) return 0;

        uint sum;
        for(uint i=0;i<students.length;i++) {
            sum += students[i].score;
        }

        return sum / students.length;
    }

    // 선생 지도 자격 자가 평가 시스템 - 학생들의 평균 점수가 70점 이상이면 true, 아니면 false를 반환
    function teacherSelfEvaluation() public view returns(bool) {
        require(students.length > 0, "No data");

        uint sum;

        for(uint i=0;i<students.length;i++) {
            sum += students[i].score;
        }

        uint scoreAverage = sum / students.length;
        if(scoreAverage >= 70) {
            return true;
        }        
        return false;
    }


    // 보충반 조회 기능 - F 학점을 받은 학생들의 숫자와 그 전체 정보를 반환
    function Flists() public view returns(uint, student[] memory) {
        require(students.length > 0, "No data");
        
        uint F;
        for(uint i=0; i<students.length;i++){
            if(keccak256(abi.encodePacked(students[i].grade)) == keccak256(abi.encodePacked("F"))){
                F++;
            }
        }

        returns (F, )
    }

}