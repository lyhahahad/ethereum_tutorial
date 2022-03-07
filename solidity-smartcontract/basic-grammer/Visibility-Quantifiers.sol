/*https://www.tutorialspoint.com/solidity/solidity_contracts.htm
external : 다른 컨트랙트에서 사용할 수 있는 함수. 내부적으로는 사용할 수 없다. 
상태 변수는 external로 사용할 수 없다.
public : 공용 함수/변수는 외부 및 내부에서 모두 사용할 수 있다. 공개 상태 변수의 경우 solidity는 자동으로 getter함수를 생성한다.
internal : 내부 기능/변수는 내부적으로 또는 파생된 계약에서만 사용할 수 있다.
private : 비공개 함수/변수는 내부적으로만 사용할 수 있으며 파생계약에서도 사용할 수 없다.
내부, 외부, 파생
external-외부/internal-내부,파생/public-모두/private-내부
 */
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract C {
   //private state variable
   uint private data;
   
   //public state variable
   uint public info;

   //constructor
   constructor() public {
      info = 10;
   }
   //private function
   function increment(uint a) private pure returns(uint) { return a + 1; }
   
   //public function
   function updateData(uint a) public { data = a; }
   function getData() public view returns(uint) { return data; }
   function compute(uint a, uint b) internal pure returns (uint) { return a + b; }
}
//External Contract
contract D {
   function readData() public returns(uint) {
      C c = new C();
      c.updateData(7);         
      return c.getData();
   }
}
//Derived Contract
contract E is C {
   uint private result;
   C private c;
   
   constructor() public {
      c = new C();
   }  
   function getComputedResult() public {      
      result = compute(3, 5); 
   }
   function getResult() public view returns(uint) { return result; }
   function getData() public view returns(uint) { return c.info(); }

}