// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.4 <0.9.0;
/**
솔리디티는 해시 알고리즘 함수를 제공한다.
 */
contract Test {   
   function callKeccak256() public pure returns(bytes32 result){
      return keccak256("ABC");
   }  
}