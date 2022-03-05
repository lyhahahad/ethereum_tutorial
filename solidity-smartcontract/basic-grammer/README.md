### solidity grammer <br>
1.Data-location<br>
storage, memory, calldata가 존재한다.<br>
A=>B == B=A<br>
storage=>memory copy<br>
storage=>local storage reference<br>
memory=>storage copy(00=>storage는 항상 copy)<br>
memory=>memory reference<br>
calldata=>memory or storage copy<br>
calldata는 함수의 인수를 담고 수정이 불가능하고 비영구적이다.<br>

2.Arrays<br>
