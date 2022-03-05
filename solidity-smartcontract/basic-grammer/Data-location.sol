// 참조형 변수인 data location에는 크게 3가지가 있다.
// 1.memory
// 2.storage
// 3.calldata : function의 인수가 저장되는 수정 불가능하고 비영구적인 영역이다.
// 가능하면 복사를 방지하고 데이터를 수정할 수 없도록 하기 때문에 calldata를 데이터 위치로 사용한다.
// arrays, structs는 함수에서 반환될 수는 있지만 할당하는 것은 불가능하다.
// 0.6.9 버젼 이전에 참조 유형 인수는 calldata in external functions, memory in public functions, memory or storage in internal and private 로 제한돼 있었다.
// 하지만 이후 버전에서는 memory와 calldata의 경우 visibility와 관계없이 자유롭게 사용할 수 있다.
// 0.5.0 버젼 이전에는 data location 생략이 가능했다. 하지만 이후 버전에서는 복잡한 type의 경우 반드시 datalocation을 명시해 주어야 한다.

// data location은 데이터의 지속성뿐만 아니라 할당의 의미와도 관련이 있다.
// -storage와 memory 산의 할당은 항상 독립적인 복사본을 만든다.
// -memory에서 memory로의 할당은 참조만 생성한다. 
// 이는 하나의 메모리 변수에 대한 변경 사항이 동일한 데이터를 참조하는 다른 모든 메모리 변수에서도 볼 수 있음을 의미한다.
// (메모리 할당의 경우 동일한 것을 참조하는지 반드시 체크한 후 사용해야 한다. storage와 memory간의 할당은 독립적으로 이루어지기 때문에 값의 변화의 영향을 제한할 수 있다.)
// -storage에서 local storage var로의 할당 역시 참조(주소)만 할당한다.
// -storage로의 할당은 항상 copy를 만들어 낸다.
// =>정리하면 
// =>storage<->memory, to storage, from calldata 할당은 copy
// =>memory <-> memory, storage->local var 할당은 참조, 때문에 하나의 변화가 전체에 영향을 줄 수 있다.

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract C {
    //x의 data location은 storage이다.
    //data location을 생략해도되는 유일한 location이다.
    // The data location of x is storage.
    // This is the only place where the
    // data location can be omitted.
    uint[] x;

    // x와 달리 'memory memoryArray'는 메모리로의 할당을 명시했다.
    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        // x는 storage이다. to storage할당은 항상 copy를 통해 이루어진다.
        x = memoryArray; // works, copies the whole array to storage
        // y는 storage로 명시했고 이는 local storage에 해당한다. storage x를 할당 받았다. 이때는 참조를 사용한다.
        // 즉 x혹은 y의 변화는 서로에게 영향을 준다.
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        y[7]; // fine, returns the 8th element
        y.pop(); // fine, modifies x through y
        delete x; // fine, clears the array, also modifies y
        // y를 삭제 혹은 reset은 작동하지 않는다.
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // This does not work either, since it would "reset" the pointer, but there
        // is no sensible location it could point to.
        // delete y
        //storage->local storage, reference
        g(x); // calls g, handing over a reference to x
        //storage->memory, copy
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
}