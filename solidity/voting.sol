// voting예제 분석
// 목적 : 투표 집계가 자동으로 이루어지고 동시에 완전히 투명 하도록 위임 투표를 수행할 수 있는 방법을 보여줌.
// 투표 용지당 하나의 계약을 생성하여 각 옵션에 대한 짧은 이름을 제공한다.
// 의장은 맡은 계약 작성자가 각 주소에 대해 개별적으로 투표할 수 있는 권한을 부여함.
// 스스로 투표하거나 자신이 신뢰하는 사람에게 투표를 위임할 수 있다.

// SPDX-License-Identifier: GPL-3.0
//솔리디티 버젼은 0.7 이상 0.9이하를 사용한다.
pragma solidity >=0.7.0 <0.9.0;

// 요약 정리
// 상태변수
// Voter(struct) : 투표자를 의미하는 변수로 위임받은 표의 총량(weight), 투표여부(voted), 위임을 했다면 위임 주소(delegate), 어떤 제안에 투표했는지(vote)로 구성됨.
// Proposal(struct) : 단일 제안을 담는 변수로 제안의 이름(name), 받은 표의 숫자(votecount)로 구성된다.
// chairperson(address) : 의장의 주소를 담는 변수.
// voters(mapping(address => Voter)) : 주소를 통해 각 voter 변수를 찾을 수 있는 변수.
// proposals(Proposal[]) : 모든 제안이 담겨 있는 배열. 

// 생성자
// bytes32[]타입의 proposalNames 변수를 받는다.
// 의장은 msg.sender가 된다.
// proposals변수에 proposalNames에 있는 내용을 proposal타입으로 바꾸어 push한다.
// proposalNames은 제안들이 담겨 있는 배열 변수이다.
// 제안들이 담긴 데이터를 받아 각 제안들에 대한 투표를 생성한다.

// 메서드
// giveRightToVote(address voter) : 의장이 voter에게 투표 권한을 부여하는 메서드.
// 의장이 아닐 경우, 이미 투표한 경우, 투표 용지가 0개가 아니라면 실행할 수 없다.
// 의장이 이미 투표하지 않았고 위임 받은 투표용지가 없는 voter에게 투표권한을 +1해줄 때 사용하는 함수이다.
// delegate(address to) : to 주소에 투표 권한을 위임한다.
// 이미 투표했거나 본인이 본인 주소에 위임할 때는 위임이 불가하다.

/// @title Voting with delegation.
contract Ballot {
    // This declares a new complex type which will
    // be used for variables later.
    // It will represent a single voter.
    struct Voter {
        uint weight; // weight is accumulated by delegation
        bool voted;  // if true, that person already voted
        address delegate; // person delegated to
        uint vote;   // index of the voted proposal
    }

    // This is a type for a single proposal.
    struct Proposal {
        bytes32 name;   // short name (up to 32 bytes)
        uint voteCount; // number of accumulated votes
    }

    address public chairperson;

    // This declares a state variable that
    // stores a `Voter` struct for each possible address.
    mapping(address => Voter) public voters;

    // A dynamically-sized array of `Proposal` structs.
    Proposal[] public proposals;

    /// Create a new ballot to choose one of `proposalNames`.
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;

        // For each of the provided proposal names,
        // create a new proposal object and add it
        // to the end of the array.
        for (uint i = 0; i < proposalNames.length; i++) {
            // `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }

    // Give `voter` the right to vote on this ballot.
    // May only be called by `chairperson`.
    function giveRightToVote(address voter) external {
        //require함수가 false가 나와 실행이 종료되는 경우 과거 evm에서는 gas가 사용됐는데 지금은 사용되지 않는다.
        //때문에 require를 사용하는 것은 상당히 효율적이다.
        // If the first argument of `require` evaluates
        // to `false`, execution terminates and all
        // changes to the state and to Ether balances
        // are reverted.
        // This used to consume all gas in old EVM versions, but
        // not anymore.
        // It is often a good idea to use `require` to check if
        // functions are called correctly.
        // As a second argument, you can also provide an
        // explanation about what went wrong.
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    /// Delegate your vote to the voter `to`.
    function delegate(address to) external {
        // assigns reference
        // voters 변수는 mapping 변수로 주소를 통해 해당 주소의 voting정보를 가져올 수 있다.
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");

        require(to != msg.sender, "Self-delegation is disallowed.");
        
        
        //while루프는 많은 가스를 요구하기 때문에 상당히 위험하다.
        ------------------------------------------------------------
        // Forward the delegation as long as
        // `to` also delegated.
        // In general, such loops are very dangerous,
        // because if they run too long, they might
        // need more gas than is available in a block.
        // In this case, the delegation will not be executed,
        // but in other situations, such loops might
        // cause a contract to get "stuck" completely.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // We found a loop in the delegation, not allowed.
            require(to != msg.sender, "Found loop in delegation.");
        }

        // Since `sender` is a reference, this
        // modifies `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            // If the delegate already voted,
            // directly add to the number of votes
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate did not vote yet,
            // add to her weight.
            delegate_.weight += sender.weight;
        }
    }

    /// Give your vote (including votes delegated to you)
    /// to proposal `proposals[proposal].name`.
    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        // If `proposal` is out of the range of the array,
        // this will throw automatically and revert all
        // changes.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Computes the winning proposal taking all
    /// previous votes into account.
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

    // Calls winningProposal() function to get the index
    // of the winner contained in the proposals array and then
    // returns the name of the winner
    function winnerName() external view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}