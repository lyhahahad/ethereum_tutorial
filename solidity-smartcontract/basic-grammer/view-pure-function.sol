
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
/**
view type의 함수는 보기는 가능하지만 상태를 수정할 수는 없다.
상태 변수 수정, 이벤트 방출, 다른 계약 생성, 이더 보내기 등과 같은 기능 사용이 제한된다.
주로 getter함수에 쓰인다.
 */
contract view_contract {
   function getResult() public view returns(uint product, uint sum){
      uint a = 1; // local variable
      uint b = 2;
      product = a * b;
      sum = a + b; 
   }
}
/**
pure type의 함수는 상태를 읽거나 수정하는 것까지 제한됩니다.
상태변수 읽기, address.balance, msg, tx, block, pure아닌 함수를 호출하는 것이 불가능합니다.
 */
contract pure_contract {
   function getResult() public pure returns(uint product, uint sum){
      uint a = 1; 
      uint b = 2;
      product = a * b;
      sum = a + b; 
   }
}