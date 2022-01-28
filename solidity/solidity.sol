https://solidity-kr.readthedocs.io/ko/latest/introduction-to-smart-contracts.html
// 솔리디티 버전 정하는 코드가
// pragma라는 키워드는 컴파일러가 소스 코드를 어떻게 처리해야 하는지 알려준다.
// 다르게 동작할 수 있는 컴파일러를 사용하지 않도록 방지하는 부분이다.
// erc-721, 20 등 다양한 인터페이스의 명세도 버전마다 다르기 때문에 신경써야 한다.
pragma solidity >=0.4.0 <0.6.0;

contract SimpleStorage {
// 데이터베이스에서 값을 조회하거나 변경할 수 있는 하나의 영역을 정의하는 부분.
    uint storedData;

// set, get함수를 통해 변경하고 조회할 수 있다.
// 변수는 getter와 setter를 가진다.
// 솔리디티는 다른 프로그래밍 언어와 달리 this. 키워드를 사용하지 않는다.
    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}


// 코인 만들기 예제(subcurrency)
// 필요한 것은 이더리움 키 쌍 뿐이다.

pragma solidity ^0.5.0;

contract Coin {

// 누구나 접근 가능한(public) address 타입의 변수 선언.
// address 타입은 160비트로 그 어떤 산술 연산을 허용하지 않는다.
// 이 타입은 컨트랙트 주소나 외부 사용자들의 키 쌍을 저장하는데 적합하다.
// public은 변수의 현재 값을 컨트랙트 바깥에서 접근할 수 있도록 하는 함수이다.
// public을 사용하면 자동으로 다음과 같은 함수를 만든다.
// function minter() returns (address) { return minter; }
// 컴파일러의 작동 방식을 기억해 두자.
    address public minter;

//주소와 양의 정수를 매핑하는 변수이다.
//매핑은 해시 테이블로 볼 수 있다.
//초기에 모든 키값은 바이프 표현이 모두 0인 값에 매핑된다.
//추가한 것인지 무엇인지 알고 전체를 가져오지 않는 상황에서 사용해야 한다.
//위와 마찬가지로 public으로 선언했기 때문에 자동으로 getter를 생산한다.
//function balances(address _account) external view returns (uint) {
//    return balances[_account];
//}  
    mapping (address => uint) public balances;

// 이벤트의 한 종류
// ui는 블록체인 상에서 발생한 이벤트를 큰 비용없이 받아 볼 수 있다. 
// 아래 send함수의 맨마지막에 발생한다.
    event Sent(address from, address to, uint amount);
    Coin.Sent().watch({}, "", function(error, result) {
    if (!error) {
        console.log("Coin transfer: " + result.args.amount +
            " coins were sent from " + result.args.from +
            " to " + result.args.to + ".");
        console.log("Balances now:\n" +
            "Sender: " + Coin.balances.call(result.args.from) +
            "Receiver: " + Coin.balances.call(result.args.to));
    }
})

// 생성자는 컨트랙트 생성시 실행되는 특별한 함수로 이후에는 사용되지 않는다.
// 컨트랙트를 만든 사람의 주소를 영구적으로 저장한다.
// msg는 유용한 전역 변수로 블록체인에 접근할 수 있는 다양한 속성을 담고있다.
    constructor() public {
        minter = msg.sender;
    }
    
// 사용자나 컨트랙트가 호출할 수 있는 함수 : mint, send
// mint는 사용자가 컨트랙트를 만든 사람이 아니라면 아무일도 일어나지 않는다.
// 이는 require 함수에 의해 보장된다.
// require은 인수가 false로 평가될 경우 모든 변경사항을 원래대로 되돌린다.
// require를 두번째로 호출하면 코인이 너무 많아지게 되기 이는 차후에 오버 플로우 에러의 원인이 될 수도 있다.
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;
    }
// 위의 event sent가 아래 마지막 줄에서 실행됨.
// 코인을 전송하려고 이 컨트랙트를 사용해도 블록체인 탐색기로 본 해당 주소에는 변화가 없다.
// 컨트랙트 내의 데이터 저장소에만 저장되기 때문이다.(블록체인에 해당 거래가 기록되지는 않다는 의미)
// event sent를 통해 이사실을 쉽게 확인할 수 있다.
// 이것을 실제로 블록체인에 저장하는 코드가 필요한 듯
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}