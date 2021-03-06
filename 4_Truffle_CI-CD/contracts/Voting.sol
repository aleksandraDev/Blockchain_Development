// SPDX-License-Identifier: GPL
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Voting contract
 * @author Aleksandra Kojic
 * @notice Alyra school exercise
 */
contract Voting is Ownable {
    /**
     * @dev Struct of an Voter
     * @notice it represents a single voter
     */
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }
    /**
     * @dev Struct for a Proposal
     */
    struct Proposal {
        string description;
        uint256 voteCount;
    }
    /**
     * @notice Keeps track of voting session state
     * @dev Only admin can change the state
     */
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    /**
     * @notice Initial state - beginning of session with registering voters
     */
    WorkflowStatus public workflowCurrentStatus =
        WorkflowStatus.RegisteringVoters;

    //
    uint256 winningProposalId;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus previousStatus,
        WorkflowStatus newStatus
    );
    event ProposalRegistered(uint256 proposalId);
    event Voted(address voter, uint256 proposalId);

    /**
     * @dev Get the winner Id
     * @return uint
     */
    function getWinner() public view returns (uint256) {
        return winningProposalId;
    }

    /**
     * @dev Add a voter with his blockchain address
     * @param _addressVoter of voter
     */
    function addVoter(address _addressVoter) external onlyOwner {
        require(
            workflowCurrentStatus == WorkflowStatus.RegisteringVoters,
            "Not Registering Voters Status is on"
        );
        require(
            !voters[_addressVoter].isRegistered,
            "Voter already registered"
        );
        voters[_addressVoter] = Voter(true, false, 0);
        emit VoterRegistered(_addressVoter);
    }

    /**
     * @dev Admin start the proposal process for voters and change the status to ProposalsRegistrationStarted
     * @
     */
    function startProposalSession() external onlyOwner {
        require(
            workflowCurrentStatus == WorkflowStatus.RegisteringVoters,
            "Not in a Registering Voters Status"
        );
        workflowCurrentStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(
            WorkflowStatus.RegisteringVoters,
            WorkflowStatus.VotingSessionStarted
        );
    }

    /**
     * @dev Voter add proposal.
     * @param _description content of proposal
     */
    function addProposal(string memory _description) external {
        require(
            workflowCurrentStatus ==
                WorkflowStatus.ProposalsRegistrationStarted,
            "Not in a Proposals Registration process"
        );
        require(voters[msg.sender].isRegistered, "Voter not registered");

        proposals.push(Proposal(_description, 0));
        uint256 proposalId = proposals.length - 1;
        emit ProposalRegistered(proposalId);
    }

    /**
     * @dev Stop registering proposals and change the status to ProposalsRegistrationEnded
     */
    function stopProposalSession() external onlyOwner {
        workflowCurrentStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(
            WorkflowStatus.ProposalsRegistrationStarted,
            WorkflowStatus.ProposalsRegistrationEnded
        );
    }

    /**
     * @dev Start the voting session.
     */
    function startVotingSession() external onlyOwner {
        require(
            workflowCurrentStatus == WorkflowStatus.ProposalsRegistrationEnded,
            "Proposals Registration not Ended"
        );
        workflowCurrentStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(
            WorkflowStatus.ProposalsRegistrationEnded,
            WorkflowStatus.VotingSessionStarted
        );
    }

    /**
     * @dev Add a vote
     * @param _votedProposalId index of proposal to vote
     */
    function addVote(uint16 _votedProposalId) external {
        require(
            workflowCurrentStatus == WorkflowStatus.VotingSessionStarted,
            "It is not time to vote!"
        );
        require(voters[msg.sender].isRegistered, "Voter can not vote");
        require(!voters[msg.sender].hasVoted, "Voter has already vote");

        voters[msg.sender].votedProposalId = _votedProposalId;
        voters[msg.sender].hasVoted = true;
        proposals[_votedProposalId].voteCount++;

        emit Voted(msg.sender, _votedProposalId);
    }

    /**
     * @dev Stop the voting session.
     */
    function stopVotingSession() public onlyOwner {
        require(
            workflowCurrentStatus == WorkflowStatus.VotingSessionStarted,
            "Not VotingSessionStarted Status"
        );
        workflowCurrentStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(
            WorkflowStatus.VotingSessionStarted,
            WorkflowStatus.VotingSessionEnded
        );
    }

    /**
     * @dev Score the voting session.
     * @notice votesResult calculates votes and emit the event of status change to VotesTallied
     */
    function votesResult() external onlyOwner {
        require(
            workflowCurrentStatus == WorkflowStatus.VotingSessionEnded,
            "Voting session is not ended"
        );

        uint256 _winnerId;
        uint256 _nbVotesWinner;

        workflowCurrentStatus = WorkflowStatus.VotesTallied;

        for (uint16 i; i < proposals.length; i++) {
            if (proposals[i].voteCount > _nbVotesWinner) {
                _winnerId = i;
                _nbVotesWinner = proposals[i].voteCount;
            }
        }
        winningProposalId = _winnerId;

        emit WorkflowStatusChange(
            WorkflowStatus.VotingSessionEnded,
            WorkflowStatus.VotesTallied
        );
    }

    /**
     * @dev Get the winning Proposal Information
     * @return description of the winning proposal
     * @return voteCount : number of votes for the winning proposal
     */
    function getWinningProposal()
        external
        view
        returns (string memory description, uint256 voteCount)
    {
        require(
            workflowCurrentStatus == WorkflowStatus.VotesTallied,
            "Vote Result not already reveal"
        );
        return (
            proposals[winningProposalId].description,
            proposals[winningProposalId].voteCount
        );
    }
}
