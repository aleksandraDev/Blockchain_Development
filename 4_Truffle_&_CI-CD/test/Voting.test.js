const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const Voting = artifacts.require('Voting');

contract('Voting', (accounts) => {
	const admin = accounts[0];
	const voter1 = accounts[1];
	const voter2 = accounts[2];
	const voter3 = accounts[3];

	let voting;

	before(async () => {
		voting = await Voting.new({ from: admin });
	});

	/*  Registration of Voters */
	it('should return voting state of RegisteringVoters', async () => {
		let currentState = await voting.workflowCurrentStatus();
		let expectedState = Voting.WorkflowStatus.RegisteringVoters;
		expect(currentState).to.be.bignumber.equal(new BN(expectedState));
	});

	it('should register voters and emit event VoterRegistered', async () => {
		let receipt = await voting.addVoter(voter1, { from: admin });
		let receipt2 = await voting.addVoter(voter2, { from: admin });

		expectEvent(receipt, 'VoterRegistered', { voterAddress: voter1 });
		expectEvent(receipt2, 'VoterRegistered', { voterAddress: voter2 });
	});

	it('should return that voter1 is registered', async () => {
		let voterData = await voting.voters(voter1);

		expect(voterData.isRegistered).to.equal(true);
	});

	it('should revert if voter is already registered', async () => {
		await expectRevert(voting.addVoter(voter1, { from: admin }), 'Voter already registered');
	});

	it('should try to register voter if not admin', async () => {
		await expectRevert(
			voting.addVoter(voter1, { from: voter1 }),
			'Ownable: caller is not the owner'
		);
	});

	/*  Registration of proposals */
	it('should revert if voter adds proposal, while status not ProposalsRegistrationStarted', async () => {
		await expectRevert(
			voting.addProposal('prop1', { from: voter1 }),
			'Not in a Proposals Registration process'
		);
	});

	it('should change status to ProposalsRegistrationStarted', async () => {
		await voting.startProposalSession();
		currentState = await voting.workflowCurrentStatus();
		expectedState = Voting.WorkflowStatus.ProposalsRegistrationStarted;
		expect(currentState).to.be.bignumber.equal(new BN(expectedState));
	});

	it('should revert if not registered voter adds proposal', async () => {
		await expectRevert(voting.addProposal('prop1', { from: voter3 }), 'Voter not registered');
	});

	it('should add one voter proposal', async () => {
		let proposal1 = 'proposal1';
		let response = await voting.addProposal(proposal1, { from: voter1 });
		const proposalData = await voting.proposals(0);
		expect(proposalData.description).to.equal(proposal1);
		expectEvent(response, 'ProposalRegistered', { proposalId: new BN(0) });
	});

	it('should add second voter proposal', async () => {
		let proposal2 = 'proposal2';
		let proposalId = 1;
		let response = await voting.addProposal(proposal2, { from: voter2 });
		const proposalData = await voting.proposals(proposalId);
		expect(proposalData.description).to.equal(proposal2);
		expectEvent(response, 'ProposalRegistered', { proposalId: new BN(proposalId) });
	});

	/*  Start voting sessiong */

	it('should revert proposal registration not ended', async () => {
		await expectRevert(
			voting.startVotingSession({ from: admin }),
			'Proposals Registration not Ended'
		);
	});

	it('should change status to ProposalsRegistrationEnded', async () => {
		await voting.stopProposalSession();
		currentState = await voting.workflowCurrentStatus();
		expectedState = Voting.WorkflowStatus.ProposalsRegistrationEnded;
		expect(currentState).to.be.bignumber.equal(new BN(expectedState));
	});

	it('should revert when its not time for voting', async () => {
		await expectRevert(voting.addVote(0, { from: voter1 }), 'It is not time to vote!');
	});

	it('should change status to start voting', async () => {
		let event = await voting.startVotingSession();
		currentState = await voting.workflowCurrentStatus();
		expectedState = Voting.WorkflowStatus.VotingSessionStarted;
		expect(currentState).to.be.bignumber.equal(new BN(expectedState));
		expectEvent(event, 'WorkflowStatusChange', {
			previousStatus: new BN(Voting.WorkflowStatus.ProposalsRegistrationEnded),
			newStatus: new BN(Voting.WorkflowStatus.VotingSessionStarted),
		});
	});

	it('should revert if voter can not vote', async () => {
		await expectRevert(voting.addVote(0, { from: voter3 }), 'Voter can not vote');
	});

	it('should register the vote', async () => {
		const proposalID = 0;
		let response = await voting.addVote(proposalID, { from: voter1 });
		let response2 = await voting.addVote(proposalID, { from: voter2 });
		let voter = await voting.voters(voter1);
		let voterSec = await voting.voters(voter2);
		expect(voter.hasVoted).to.equal(true);
		expect(voterSec.hasVoted).to.equal(true);
		expectEvent(response, 'Voted', { voter: voter1, proposalId: new BN(proposalID) });
		expectEvent(response2, 'Voted', { voter: voter2, proposalId: new BN(proposalID) });
	});

	/*  End of voting session */
	it('should revert as voting session not ended', async () => {
		await expectRevert(voting.votesResult(), 'Voting session is not ended');
	});

	it('should change status to VotingSessionEnded', async () => {
		await voting.stopVotingSession();
		currentState = await voting.workflowCurrentStatus();
		expectedState = Voting.WorkflowStatus.VotingSessionEnded;
		expect(currentState).to.be.bignumber.equal(new BN(expectedState));
	});

	it('should revert getting Winner as voting not tailled', async () => {
		await expectRevert(voting.getWinningProposal(), 'Vote Result not already reveal');
	});

	it('should count votes and emit event of status change to VotesTailled', async () => {
		currentState = await voting.workflowCurrentStatus();
		let res = await voting.votesResult();
		expectEvent(res, 'WorkflowStatusChange', {
			previousStatus: new BN(Voting.WorkflowStatus.VotingSessionEnded),
			newStatus: new BN(Voting.WorkflowStatus.VotesTallied),
		});
	});

	it('should return the winning proposal', async () => {
		let prop1 = 'proposal1';
		let voteCount = 2;
		let winner = await voting.getWinningProposal();
		expect(winner.description).to.equal(prop1);
		expect(winner.voteCount).to.be.bignumber.equal(new BN(voteCount));
	});
});
