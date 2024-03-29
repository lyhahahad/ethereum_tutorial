https://takenobu-hs.github.io/downloads/ethereum_evm_illustrated.pdf<br>
*Blockchain<br>
이더리움은 트랜잭션 기반의 상태머신이다.
트랜잭션은 블록에 기록된다.
블록은 이러한 데이터의 패키지이다.
상태의 측면에서 상태 체인이고 블록의 측면에서 보면 블록체인이다.<br>

*world state<br>
상태란 mapping변수로 address->account state이다.<br>

*account<br>
account는 world state의 객체이다.
account state는 nonce, balance, storage hash, code hash로 구성돼 있다.
storage hash에는 account storage가 있고 code hash에는 evm code가 있다.
Account는 EOA(Externally owned account), CA(contract account)로 나뉜다.
EOA의 account state는 nonce, balance로 구성돼 있고 private key로 컨트롤할 수 있다.
CA의 account state는 nonce, balance, storage hash, code hash로 구성돼 있고 evm code로 컨트롤 할 수 있다.<br>

*트랜잭션 <br>
트랜잭션은 EOA에 의루어진다.
contract creation, message call 두종류가 있다.
전자는 컨트랙트 계정을 만드는 것이고 후자는 ether를 보내거나 컨트랙트를 호출할 때 쓰이는 트랜잭션이다.<br>

*message<br>
두 계정 사이를 통과하는 데이터, value이다.
message는 크게 두가지에 의해 발생한다.
transaction, evm code에 생성된다.
트랜잭션에 의해 발생하는 경우는 eoa가 보내는 주체일 때이다.
evm코드에 의해 발생하는 경우는 ca가 보내는 주체일 때이다.<br>

*decentralised database<br>
이더리움 노드는 world state(address->account state mapping변수로 구성된 테이블)을 저장하고 있다.
External actor가 contract creation, message call transaction을 보내기 위해서는
web3 api를 통해 world state 노드와 통신해야 한다.<br>

*Atomicity and order<br>
각각의 트랜잭션은 더 이상 쪼갤 수 없다.
트랜잭션은 오버랩 될 수 없다.
트랜잭션은 항상 순서대로 실행된다.
트랜잭션의 순서는 보장되있지 않다.
채굴자가 트랜잭션의 순서를 결정한다.
채굴에 성공한 채굴자의 블록이 체인에 이어진다.<br>

*evm<br>
evm code가 실행되는 곳이 evm이다.
evm은 간단한 스택기반 아키텍쳐이다.
스택은 1024개가 넘을 수 없고 push 등과 같은 opcode를 사용하여 작동한다.
이밖에도 휘발성 메모리인 메모리와 비휘발성 메모리인 스토리지가 있다.
evm코드는 바이트코드이다.
메모리와 스토리지는 스택에 의해 호출된다. <br>

*storage, memory, calldata<br>
-storage란?<br>
스토리지에 배치되면 변수가 블록체인에 기록됩니다. 
체인에 있는 모든 것은 그대로 유지됩니다. 
모든 계약에는 자체 저장소가 있으므로 이러한 변수는 영구적입니다. 
따라서 항상 스토리지 변수에 액세스할 수 있습니다. 
값을 수정할 수 있지만 위치는 영구적입니다. 
모든 변경 사항은 블록체인에 등록됩니다.<br>
-memory란?<br>
function에 저장된 변수는 function 내에서 선언됩니다. 
그들은 임시적이고 '수명'은 해당 기능의 런타임에 따라 다릅니다. 
해당 function 내에서만 액세스할 수 있습니다. 
그들의 목적은 계산을 돕는 것입니다. 
또한 EVM은 기능 실행 후 위치를 버립니다. 
function 내부가 아닌 다른 곳에서는 이러한 변수에 액세스할 수 없습니다.<br>
-calldata란?<br>
Calldata는 Solidity의 임시 데이터 위치이기도 합니다. 
함수 실행에 대한 종속성 측면에서 메모리처럼 작동합니다. 
calldata에 저장된 변수는 선언된 함수 내에서만 사용할 수 있습니다.
게다가 calldata 변수는 수정할 수 없습니다.
이는 해당 값을 변경할 수 없음을 의미합니다. <br>
-가스비용<br>
가스비용 : storage > memory > calldata
storage의 전역 데이터를 변경하는 것은 가스비가 많이 드는 작업이다.
좋은 컨트랙트에서는 이런 변경을 줄여야 한다.<br>

*Exception<br>
---컴파일 과정에서 발생하는 에러.<br>
1.invalid jump destination(pc에서 evmcode 사이에서 발생한다.)<br>
배열의 범위를 벗어난 경우
실패한 하위 호출
라이브러리 폴백 함수로 전송된 이더<br>
----실제로 실행하면서 발생하는 에러<br>
2.invalid instruction : 잘못된 지시 evm code operation에서 발생<br>
3.stack underflow : 데이터가 없는데 프로그램이 스택에서 데이터를 꺼내려고 할 경우 발생한다.<br>
4.out-of-gas : 가스비 부족<br>

*Gas<br>
EOA(Externally owned account)->Gas supply + message ->CA(contract account)<br>
                                        <- refund<br>
이더리움 상의 모든 계산은 수수료를 받는다.<br>
pc -> evmcode->operations(Gas)->stack->memory or storage(more gas)<br>
                              ->message call(more gas)<br>
message call과 storage 사용을 최소하하는 것이 gas를 줄이는 방법이다.<br>

*Input and Output of EVM<br>
evm은 message call로부터 input데이터를 받을 수 있다.
evmcode가 실행되는 evm은 log를 return하거나 caller evm에 return값을 준다.
input데이터는 CALLDATALOAD, CALLDATACOPY로 저장되고 전자는 stack에 후자는 memory에 들어간다.<br>

*Byte order<br>
메모리는 linear, byte level에서 주소가 존재한다.
load, store 명령어가 있다.
초기에 0으로 초기화돼있음<br>

*ethereum virtual machine layer<br>
evmcode->evm->ethereum node(process, runtime)->physical processor<br>

*source code in geth<br>
block header = root of state, root of transaction<br>
(state root = “state root”: the root hash of a specialized kind of Merkle tree which stores the entire state of the system: all account balances, contract storage, contract code and account nonces are inside)<br>
transaction = to address, value, input data<br>
world state = mapping for address to account state<br>
account object = address, accountstate<br>

