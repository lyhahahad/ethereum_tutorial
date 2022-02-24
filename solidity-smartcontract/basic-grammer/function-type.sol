// https://docs.soliditylang.org/en/v0.8.11/types.html#function-types
// 함수에는 내부/외부 함수가 있다.
// 내부함수는 현재 계약의 컨텍스트 외부에서 실행할 수 없다.
// 내부 라이브러리 함수 및 상속된 함수도 포함하는 현재 코드 단위 내에서 호출가능.
// 외부함수는 주소와 함수 서명으로 구성되며 외부 함수 호출을 통해 전달 및 반환될 수 있다.
// public vs private = contract내부 or 외부 호출 가능 유무 public 둘다 가능 private 내부에서만 가능
// internal vs external = contract 내부 or 상속된 contract에서 가능, contract 외부에서만 가능(내부 호출 불가능)

// 함수 유형은 다음과 같이 표기된다.
// function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]
// 매개변수와 달리 반환 부분은 비어있을 수 없다.
// 함수가 아무것도 반환하지 않으면 returns부분 전체를 생략해야 한다.
// 기본적인 함수는 내부적이므로 internal 키워드를 생략할 수 있다.
// 컨트랙트내의 함수들은 이러한 생략이 불가능하다.
// function type A는 매개 변수, return type, internal/external속성이 같으면 아래 조건에 따라 상태 변경 조건을 변경한 type B로 바꿀 수 있다.
// pure 함수는 view, non-payable 함수로
// view 함수는 non-payable 함수로
// payable은 non-payable 함수로 바뀔 수 있다.
// 다른 함수 유형으로의 변환은 불가능하다.

// payable과 non-payable은 함수의 지불가능성에 대한 규칙이다.
// payable은 0 ether 지불 또한 승인한다. 
// 이것은 non-payble이기도하다.
// non-payable은 모든 ether send를 reject한다.
// 때문에 payable은 non-payable이될 수 있지만 non-payable 함수는 payable로 바꿀 수 없다.

// 함수 유형 변수가 초기화되지 않은 경우 호출하면 패닉 오류가 발생한다.
// 함수에 삭제를 사용한 후 호출해도 마찬가지 결과가 나온다.

// public 함수는 내부와 외부에서 모두 사용할 수 있다.
// function f를 internal 함수로 사용하려면 f로 사용하고 external form으로 사용하려면 this.f로 사용하면 된다.

// this.f이후~

// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.4 <0.9.0;

contract Example {
    function f() public payable returns (bytes4) {
        assert(this.f.address == address(this));
        return this.f.selector;
    }

    function g() public {
        this.f{gas: 10, value: 800}();
    }
}
