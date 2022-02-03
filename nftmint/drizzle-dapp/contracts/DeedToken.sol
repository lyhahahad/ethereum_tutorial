pragma solidity >=0.5.0;
// 약한 부분
// 에러 수정하면서 디테일하게 익히기.
// supportedInterfaces
// operators
// supportsInterface
// mint
// burn
// removeInvalidToken

// 하이라이트
// 1. 모든 함수들의 기본적인 구조는 상태변수를 먼저 변경한 후에 emit을 사용하고 
// 디버깅의 경우 require를 사용해 체에 거른다.

// 정리
// ERC721 인터페이스 구현
// 상태 변수
// supportedInterfaces
// tokenOwners
// balances
// allowance
// operators
// allTokens
// allValidTokenIds
// allValidTokenIndex
// 필수 함수
// supportsInterface
// ownerOf
// balanceOf
// transferFrom
// safeTransferFrom
// approve
// setApprovalForAll
// getApproved
// isApprovedForAll

// 확장함수
// totalSupply
// tokenByIndex
// name
// symbol
//NON STANDARD
// mint
// burn
// removeInvalidToken


//인터페이스(표준) 가져오기. erc 721,165
//솔리디티 컴파일 버전에 따라 표쥰 적절하게 수정.
// erc721은 public을 public으로 바꿨기 때문에 인터페이스가 아니라 컨트랙트로 바꾼다.
//라이브러리
//safemath, address


contract DeedToken is ERC721, ERC165{
    using safeMath for uint256;
    using Address for address;
    
    // using for 구문을 사용하면 uint256 클래스 변수들에 safemath 라이브러리 메서드가 추가되도록 한다.
    // unit a = 10;
    // unit b = 10;

    // safeMath.add(a,b);
    // a.add(b);

    // 상태 변수() 선언 ERC 165 구현하기 위해 BOOL 리턴하는 MAPPING 상태변수 선언.
    // supportedInterfaces는 ERC165 인터페이스에 있다.
    // 어떤 인터페이스를 구현했는지 알려주는 함수를 사용할 때 사용.
    mapping(bytes4 => bool) supportedInterfaces;

    // 토큰을 누가 가지고 있는지 소유자 정보를 담음.
    // 토큰 id를 넣으면 소유자 주소가 return된다.
    mapping(uint256 => address)tokenOwners;
    // 특정 소유 계정이 가진 밸런스를 담는데 사용.
    // 특정 주소를 넣으면 해당 주소의 토큰 수량이 return된다.
    mapping(address =>uint256) balances;
    // 어떤 토큰id를 가진 어떤 address가 소유권 이전 승인 권리를 갖고 있는가?
    //토큰 id를 넣으면 권리를 가진 주소가 나온다.
    mapping(uint256=>address) allowance;
    // 어떤 소유자 계정이 다수에게 자신이 가진 토큰을 관리할 수 있도록 하는 변수
    // 특정 주소를 넣으면 해당 주소를 관리할 수 있는 bool을 return해준다.
    mapping(address =>mapping(address=>bool)) operators;

    // mapping 타입은 테이블이라고 생각하면 된다.
// 이모티콘의 얼굴, 눈, 입모양 구조.
    struct asset{
        uint8 x;
        uint8 y;
        uint8 z;
    }

    asset[] public allTokens;

// enumertaion
// 유효한 토큰 id만 가지는 배열
    uint256[] public allValidTokenIds;
// 토큰 id를 가지고 인덱스를 구할 수 있는 변수
    mapping(uint256 => uint256) private allValidTokenIndex;

    // 생성자
    constructor() public{
        // 165인터페이스를 구현하는 부분.
        // 721의 셀렉의 xor값을 넣어야 한다.
        // 0x80ac58cd는 721 인터페이스에 있다.
        // 0x80ac58cd는 721 인터페이스의 함수들의 xor값이다.
        supportedInterfaces[0x80ac58cd] = true; //erc721
        supportedInterfaces[0x01ffc9a7] = true; //erc165
        
        // erc 165 구현.
        // 키에 해당하는 인터페이스 아이디에 맞는 것이 있다면 true, 아니라면 false 
        function supportsInterface(bytes4 interfaceID) public view returns (bool){
            return supportedInterfaces[interfaceID];
        }

        // erc 721 구현.

        // 특정 주소의 밸런스 리턴하는 함수.
        function balanceOf(address _owner) public view returns (uint256){
            return balances[_owner];
        }

        // 해당 토큰 id의 주인을 찾는 함수.
        function ownerOf(uint256 _tokenId) public view returns (address){
            address addr_owner = tokenOwners[_tokenId]
            // addr_owner값이 null 값 즉 소유자가 없다면 예외를 발생시켜라
            require(addr_owner != address(0),"Token is invalid");
            return tokenOwners[_tokenId];
        }

        // 소유권 이전 함수
        function transferFrom(address _from, address _to, uint256 _tokenId) public payable{
            // external이 아니라 public으로 선언했기 때문에 가져다 쓸 수 있는 것.
            address addr_owner = ownerOf(_tokenId); 
            // 토큰 owner가 from으로 들어온 address와 일치해야 한다. 소유권 확인.
            require(addr_owner == _from, "_from us NOT the owner of the token");
            // null 계정으로의 전송 막음.
            require(_to != address(0),"transfer _to address 0x0");
            // 소유권이전을 허가 받은 allowance에 있는 주소일 경우 전송 가능.
            address addr_allowed = allowance[_tokenId];
            // 중개인 계정에 토큰 소유권을 이전할 수 있는 권리가 true인지
            bool isOp = operators[addr_owner][msg.sender];
            // 이전이 가능한 경우는 크게 세가지이다.
            // 소유자가 전송하거나
            // allowance에 있는 계정이거나
            // operators에서 승인이 확인된 지갑이거나(중개자.)
            require(addr_owner == msg.sender || addr_allowed == msg.sender || isOp,"msg.sender can NOT transfer the token");
            // tokenOwners 바꾸기.
            tokenOwners[_tokenId] = _to;
            // 토큰 수량 맞추기.
            balances[_from] = balances[_from].sub(1);
            balances[_to] = balances[_to].add(1)
            
            // 이전의 allowance 리셋.
            if (allowance[_tokenId] != address(0)){
                delete allowance[_tokenId];
            }

            // 이벤트 발생시키기.
            emit Transfer(_from, _t0, tokenId);

        }

        function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public payable{
        //기능상 transferFrom과 같지만 추가 컨트랙트 계정을 구분하는 기능이 추가된다.
           transferFrom(_from, _to, _tokenId);
           
        //address 라이브러리에 있는 iscontract가 여기서 사용된다.
        // _to 주소가 컨트랙트 주소일 경우.
           if(_to.iscontract){
            //ERC721TokenReceiver는 erc721을 받을 수 있는 컨트랙트 용 인터페이스이다.
            //컨트랙트는 인터페이스인 ERC721TokenReceived의 컨트랙트를 구현하고 있어야 한다.
            // 아래 함수는 return값이 onERC721Received 셀렉터(함수아이디라고 생각하면 됨)가 나온다.
            bytes4 result = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data)

            //keccak256는 셀렉터를 가져오는 함수.
            // 토큰이 가지 못하도록 예외를 발생시킴.
            require(result == bytes4(keccak256("onERC721Received(address, address, uint256, bytes)"),"Receipt of the token is NOT completed"));

           }


        }

        function safeTransferFrom(address _from, address _to, uint256 _tokenId) public payable{
            safeTransferFrom(_from, _to, _tokenId, "");
        }

        // allowance에 토큰 아이디 할당.
        function approve(address _approved, uint256 _tokenId) public payable{
            address addr_owner = ownerOf(_tokenId);
            bool isOp = operators[addr_owner][msg.sender];
            
            // operators에 계정이 있으면 approve가 가능하다.
            require(addr_owner == msg.sender || isOp, "Not approved by owner");
            // allowance 해당 토큰 아이디 부분 approved 주소로 바꿈.
            allowance[_tokenId] = _approved;

            // 표준에 있는 것처럼 approval이라는 이벤트 발생시키면됨.
            emit Approval(addr_owner, _approved, _tokenId);
        }
        
        function setApprovalForAll(address _operator, bool _approved) public{
            // msg.sender 주소를 사용할 수 있도록 _operator를 승인해준다. true로 바꿔준다.
            operators[msg.sender][_operator] = _approved;
            emit ApprovalForAll(msg.sender, _operator,_approved);
        }
        
        function getApproved(uint256 _tokenId) public view returns (address){
            // 해당 토큰 주소 이전 권한을 가진 주소 반환
            return allowance[_tokenId];
        }
        
        function isApprovedForAll(address _owner, address _operator) public view returns (bool){
            // _owner 주소의 이전 권한을 _operator가 갖고있나?
            return operators[_owner][_operator];
        }

        // non - standard
        // 토큰 생성, 토큰 삭제 함수  
        // asset의 x,y,z 값을 받아와야 한다.
        function mint(uint8 _x, uint8 _y, uint _z) external payable {
            // asset 구조체를 만들어준다.
            asset memory newAsset = asset(_x,_y,_z);
            // allTokens은 asset 타입 변수들을 담는 배열이다.
            // push하면 return으로 배열의 길이가 나온다.
            // 그것을 사용해 tokenId를 정해줄 수 있다.
            uint tokenId = allTokens.push(newAsset)-1;
            // 토큰 오너는 mint함수를 실행한 계정(msg.sender)가 된다.
            tokenOwners[tokenId] = msg.sender;
            // 밸런스 추가하기.
            balances[msg.sender] = balances[msg.sender].add(1);
            //----------------민트 기본 끝-----------------
            // +a enumeration
            // allValidTokenIndex는 id로 인덱스를 구할 수 있는 mapping 변수
            // 가장 최근에 생성된 id의 인덱스를 기존의 토큰 id 배열의 길이로 한다.
            // 이때 배열의 길이는 추가되기전 tokenIds의 개수로 한 개 더 작다.
            // 인덱스는 길이보다 한개 더 작으므로 Index를 먼저 지정해준다.
            allValidTokenIndex[tokenId] = allValidTokenIds.length;
            // 인덱스 설정 후 tokenid를 넣어준다.
            // allValidTokenIds는 유효한 tokenid만 갖는다.
            allValidTokenIds.push(tokenId);

            //생성할 때도 역시 transfer가 실행된다. 
            // null주소에서 mint를 실행한 주소로 전송된다.
            emit Transfer(address(0), msg.sender, tokenId);
        }

        function burn(uint256 _tokenId) external {
            // 토큰 삭제는 소유계정만 할 수 있다.
            address addr_owner = ownerOf(_tokenId)
            require(addr_owner == msg.sender,"msg.sender is NOT the owner of the token");
            // allowance는 소유권 이전 권한이 있는 주소이다.
            // 해당 토큰은 더이상 존재하지 않을 것이기 때문에
            // allowance에서도 없애준다.
            if(allowance[_tokenId] != address(0)){
                delete allowance[_tokenId];
            }
            tokenOwners[_tokenId] = address(0)
            balances[msg.sender] = balance[msg.sender].sub(1);
            
            emit Transfer(addr_owner, address(0), _tokenId);
        
            //인덱스 다시 계산해주기.
            removeInvalidToken(_tokenId);
        }

        // 유효한 토큰 id를 담고 있는 allValidTokenIds에서 해당 토큰을 없애주고
        // 토큰 id를 대입하면 대입하면 토큰 인덱스를 알 수 있도록 하는 mapping 변수 allValidTokenIndex에서도 빼준다.        function removeInvalidToken(uint256 _tokenId) private {
        function removeInvalidToken(uint256 _tokenId) private {
            uint256 lastIndex = allValidTokenIds.length.sub(1);
            uint256 removeIndex = allValidTokenIndex[_tokenId];

            uint256 lastTokenId = allValidTokenIds[lastIndex];

            //swap
            // allVaildTokenIds에서 제거하고자 하는 토큰 id의 인덱스에 있는 값을 마지막 토큰 id로 바꿔준다.
            allVaildTokenIds[removeIndex] = lastTokenIds;
            // 마지막 토큰 id의 인덱스를 제거하고자하는 토큰의 인덱스로 바꿔준다.
            allvaildTokenIndex[lastTokenId] = removeIndex;
        
            // 마지막 인덱스를 삭제해준다.
            allVaildTokenIds.length = allValidTokenIds.length.sub(1);
            // 제거하고자하는 토큰 아이디의 인덱스를 무의미한 값으로 설정한다.
            allValidTokenIndex[_tokenId] = 0; // no meaning
        }

        //erc721Enumerable
        // 유효한 토큰의 개수 return
        function totalSupply() public view returns(uint){
            return allValidTokenIds.length;
        }

        // 인덱스로 토큰 가져오는 함수.
        function tokenByIndex(uint 256) public view returns(uint){
            //조건 : 인덱스는 반드시 전체 공급량보다 작아야 한다.
            require(index<totalSupply());
            return allValidTokenIds[index];
        }

        //erc721metadata
        // name return해주는 함수
        function name() external pure returns (string memory){
            return "EMOJI TOKEN";
        }
        function symbol() external pure returns (string memory){
            return "EMJ"
        }

    }
}

contract ERC721TokenReceiver{
    function onERC721Received(address _operator, address _from, uint256 _tokenId, byte memory data) public returns(bytes4);
}
