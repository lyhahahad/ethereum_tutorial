// https://eips.ethereum.org/EIPS/eip-721
pragma solidity ^0.4.20;

//우선 끝까지 정리하기.
//openzepplin 코드 정답지로 활용해 직접 구현해 보기.
/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
// erc165를 상속한다. 
interface ERC721 /* is ERC165 */ {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    /// @dev This emits when the approved address for an NFT is changed or
    ///  reaffirmed. The zero address indicates there is no approved address.
    ///  When a Transfer event emits, this also indicates that the approved
    ///  address for that NFT (if any) is reset to none.
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    /// @dev This emits when an operator is enabled or disabled for an owner.
    ///  The operator can manage all NFTs of the owner.
   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    // 특정 주소의 토큰 수량을 반환한다.
    // 특정 주소의 토큰 수량을 mapping할 수 있는 변수 필요
    // _balance = mapping(address => uint256)
    //null주소가 입력됐을 경우 오류발생
    // return _balance[address]
    // 상태를 파악하는 함수이기 때문에 view이다.
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) external view returns (uint256);

    // 해당 토큰을 소유한 주소를 찾는다.
    // 토큰id와 소유 주소를 mapping할 수 있는 변수 필요
    // _owner = mapping(uint256 => address)
    //null 주소일 경우 주인이 없다고 보면 되기 때문에 return하지 않는다.
    // return _owner[_tokenId]
    //상태를 파악하는 함수이기 때문에 view이다.
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address);

    //토큰의 소유권을 이전하는 함수
    // ownerOf, balance가 모두 변경돼야 한다.
    //상태를 변경하는 함수이기 때문에 payable이다.
    //오류 발생 조건
    //1.컨트랙트에 메시지를 보낸 주소가 해당 토큰의 owner 혹은 승인받은 주소가 아닐 경우
    //2.to 주소가 null일 경우
    //3.올바릊 않은 tokenId가 들어왔을 경우
    //4.transfer 완료 후 _to가 ca(컨트랙트 계정)일 경우.
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;


    //소유권을 다른 지갑에 넘겨주는 함수.
    //위의 함수와 다르게 data없는 것과 같다.
    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    //오너십을 전송하는 함수.
    //_to주소가 nft를 받을 주소가 아니라면 영구적으로 손상될 수 있다.
    //msg.sender가 현재 소유자, 인증된 operator, approved 주소가 아닐 경우 에러 발생.
    //_from이 현재의 소유자가 아니거나 _to 소유자가 null이면 에러 발생.
    //토큰 id가 올바르지 않은 경우 에러 발생.
    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    // 주소를 승인하는 함수.
    // zero 주소는 승인된 주소가 없다는 것을 의미한다.
    // msd.sender가 현재 소유자, 현재 소유자가 승인한 operator가 아니라면 에러 발생.
    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable;

    // operator 추가.
    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets
    /// @dev Emits the ApprovalForAll event. The contract MUST allow
    ///  multiple operators per owner.
    /// @param _operator Address to add to the set of authorized operators
    /// @param _approved True if the operator is approved, false to revoke approval
    function setApprovalForAll(address _operator, bool _approved) external;

    // 토큰 id에 대한 operator를 반환한다.
    /// @notice Get the approved address for a single NFT
    /// @dev Throws if `_tokenId` is not a valid NFT.
    /// @param _tokenId The NFT to find the approved address for
    /// @return The approved address for this NFT, or the zero address if there is none
    function getApproved(uint256 _tokenId) external view returns (address);

    // 해당 주소가 소유자가 승인한 주소인지 반환한다.
    /// @notice Query if an address is an authorized operator for another address
    /// @param _owner The address that owns the NFTs
    /// @param _operator The address that acts on behalf of the owner
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface ERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}