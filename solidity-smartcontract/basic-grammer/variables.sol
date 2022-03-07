/**
https://www.tutorialspoint.com/solidity/solidity_variables.htm
state var : 컨트랙트 저장소에 영구적으로 저장되는 변수
local var : 함수가 실행될 때까지 값이 존재하는 변수
global var : 블록체인에 대한 정보를 얻는 데 사용되는 전역 네임페이스에 특수 변수
blockhash, 채굴자의 주소, 블록 난이도, 블록 가스 제한, 블록 번호, 타임스탬프, 잔여 가스, 등이 있고
컨트랙트에서 가장 많이 쓰이는 것으로는 msg 변수가 있다. msg는 메시지에 대한 정보를 담고 있다.
msg.data .senderm .sig .value 등이 있다.
*/


// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract SolidityTest {
   uint storedData;      // State variable
   constructor() public {
      storedData = 10;   // Using State variable
   }
}

contract SolidityTest {
   uint storedData; // State variable
   constructor() public {
      storedData = 10;   
   }
   function getResult() public view returns(uint){
      uint a = 1; // local variable
      uint b = 2;
      uint result = a + b;
      return result; //access the local variable
   }
}