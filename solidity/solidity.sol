https://solidity-kr.readthedocs.io/ko/latest/introduction-to-smart-contracts.html
// 솔리디티 버전 정하는 코드가
// pragma라는 키워드는 컴파일러가 소스 코드를 어떻게 처리해야 하는지 알려준다.
// 다르게 동작할 수 있는 컴파일러를 사용하지 않도록 방지하는 부분이다.
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

    // Events allow light clients to react to
    // changes efficiently.
    event Sent(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    constructor() public {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}