// contracts/Voting.sol
// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

/// @title Voting System contract
/// @author Aleksandra Kojic
/// @notice You can use this contract for only testing and playing
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.
contract VotingA is Ownable {
    uint256 private totalProposals = 0;
    uint256 public winningProposalId;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }
    struct Proposal {
        string description;
        uint256 voteCount;
    }
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    WorkflowStatus status = WorkflowStatus.RegisteringVoters;

    mapping(uint256 => Proposal) private _proposals;
    mapping(address => Voter) private _voterWhitelist;

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint256 proposalId);
    event Voted(address voter, uint256 proposalId);
    event Winner(string name, uint256 votes);

    /// @notice Modifier verifies the currient step
    /// @dev Use the modifier on functions that change the data to assure functin trigger on the good status
    /// @param _status WorkflowStatus of the contract necessaire for function triggering    
    modifier isStatus(WorkflowStatus _status) {
        require(status == _status);
        _;
    }

    /// @notice Modifier verifies if the address in parameter is the registered voter
    /// @dev Use the modifier to control the proposal and voting process
    /// @param _address Voter address    
    
    modifier isVoter(address _address) {
        require(
            _voterWhitelist[_address].isRegistered == true,
            "It's not a registered voter!"
        );
        _;
    }

    /// @notice Function returns the next step in contract
    /// @dev Called by change status and returns new step
    /// @return next WorkflowStatus
    function nextStatus() internal view returns (WorkflowStatus) {
        return WorkflowStatus(uint256(status) + 1);
    }

    /// @notice Function triggered by owner to proceed on the next step
    /// @dev Function implementation allows just forwarding to the next voting phase 

    function changeStatus() public onlyOwner {
        require(uint256(status) <= 5, "Voting completed!");
        emit WorkflowStatusChange(status, nextStatus());
        status = nextStatus();
    }

    /// @notice Register, initialize and emits event of registered voter
    /// @dev Called by owner if status is RegisteringVoters
    function registerVoter(address _address)
        public
        onlyOwner
        isStatus(WorkflowStatus.RegisteringVoters)
    {
        require(
            _voterWhitelist[_address].isRegistered == false,
            "Voter is already registered"
        );
        _voterWhitelist[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    /// @notice Functions ends registration voter session and sets status on next session
    function endVoterRegistration()
        public
        onlyOwner
        isStatus(WorkflowStatus.RegisteringVoters)
    {
        changeStatus();
    }

    /// @notice Register and initialize proposals of voters
    /// @dev Sends an event of proposal Id
    function addProposal(string memory _name)
        public
        isVoter(msg.sender)
        isStatus(WorkflowStatus.ProposalsRegistrationStarted)
    {
        require(keccak256(abi.encode(_name)) != keccak256(abi.encode("")));
        _proposals[totalProposals] = Proposal(_name, 0);
        emit ProposalRegistered(totalProposals);
        ++totalProposals;
    }

    /// @notice Functions ends proposal registrationg session
    function endProposalRegistration()
        public
        onlyOwner
        isStatus(WorkflowStatus.ProposalsRegistrationStarted)
    {
        changeStatus();
    }

    /// @notice Sets the status and launch the voting session
    function startVoting()
        public
        onlyOwner
        isStatus(WorkflowStatus.ProposalsRegistrationEnded)
    {
        changeStatus();
    }

    /// @notice Register votes on proposals and emit event with voter and proosal id
    /// @dev Only register voter can vote and his choice is registered
    function vote(uint256 _proposalId)
        public
        isVoter(msg.sender)
        isStatus(WorkflowStatus.VotingSessionStarted)
    {
        require(
            !_voterWhitelist[msg.sender].hasVoted,
            "You have already voted"
        );

        require(_proposalId > 0 && _proposalId <= totalProposals);

        // record vote
        _voterWhitelist[msg.sender].hasVoted = true;
        _voterWhitelist[msg.sender].votedProposalId = _proposalId;

        // update candidate vote number
        _proposals[_proposalId].voteCount++;

        // voted event
        emit Voted(msg.sender, _proposalId);
    }


    /// @notice Ends voting seesion
    function endVoting()
        public
        onlyOwner
        isStatus(WorkflowStatus.VotingSessionStarted)
    {
        changeStatus();
    }

    /// @notice Count votes on proposals and switch to the next status
    /// @dev Can be called just by owner if voting session is ended
    function tallingVotes()
        public
        onlyOwner
        isStatus(WorkflowStatus.VotingSessionEnded)
    {
        require(totalProposals > 0, "No proposals");
        uint256 winningVoteCount = 0;
        uint256 _winningProposalId;

        for (uint256 p = 0; p < totalProposals; p++) {
            if (_proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = _proposals[p].voteCount;
                _winningProposalId = p;
            }
        }
        winningProposalId = _winningProposalId;
        changeStatus();
    }

    // function getWinner()
    //     external
    //     view
    //     isStatus(WorkflowStatus.VotesTallied)
    //     returns (string memory winnerDescription_, uint256 voteNumber_)
    // {
    //     require(winningProposalId > 0, "Winner not found");
    //     winnerDescription_ = _proposals[winningProposalId].description;
    //     voteNumber_ = _proposals[winningProposalId].voteCount;
    //     return (
    //         winnerDescription_,
    //         voteNumber_
    //     );
    // }

    /// @notice Emits the winner and his vote number
    function getWinner()
        external
        isStatus(WorkflowStatus.VotesTallied)
    {
        require(winningProposalId > 0, "Winner not found");
        emit Winner( _proposals[winningProposalId].description, _proposals[winningProposalId].voteCount);
    }
}
