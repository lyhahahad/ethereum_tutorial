// SPDX-License-Identifier: GPL-3.0

/**
Restricted Access
컨트랙트의 상태는 public으로 지정되지 않는 한 read-only이다.
modifer를 사용하여 계약의 상태를 수정하거나 계약의 기능을 호출할 수 있는 사람을 제한할 수 있다.
 */
pragma solidity >=0.6.4 <0.9.0;

contract Test {
   address public owner = msg.sender;
   uint public creationTime = now;

   modifier onlyBy(address _account) {
      require(
         msg.sender == _account,
         "Sender not authorized."
      );
      _;
   }
   function changeOwner(address _newOwner) public onlyBy(owner) {
      owner = _newOwner;
   }
   modifier onlyAfter(uint _time) {
      require(
         now >= _time,
         "Function called too early."
      );
      _;
   }
   function disown() public onlyBy(owner) onlyAfter(creationTime + 6 weeks) {
      delete owner;
   }
   modifier costs(uint _amount) {
      require(
         msg.value >= _amount,
         "Not enough Ether provided."
      );
      _;
      if (msg.value > _amount)
         msg.sender.transfer(msg.value - _amount);
   }
   function forceOwnerChange(address _newOwner) public payable costs(200 ether) {
      owner = _newOwner;
      if (uint(owner) & 0 == 1) return;        
   }
}