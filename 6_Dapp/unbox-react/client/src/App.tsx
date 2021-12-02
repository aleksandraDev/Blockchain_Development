import React, { useState, useEffect } from 'react';
import VotingContract from './contracts/VotingA.json';
import getWeb3, { setAccountChangeListener } from './utils/getWeb3';
import { Grid, Segment, Loader, Divider } from 'semantic-ui-react';
import './App.css';
import AppHeader from 'components/AppHeader';
import { RegisterVoters } from 'components/RegisterVoters';
import { PhaseLogs } from 'components/PhaseLogs';
import Title from 'components/Title';
import AdminPanel from 'components/AdminPanel';
import RegisterProposal from 'components/RegisterProposal';
import Voting from 'components/Voting';
import Winner from 'components/Winner';

enum WorkflowStatus {
  RegisteringVoters,
  ProposalsRegistrationStarted,
  ProposalsRegistrationEnded,
  VotingSessionStarted,
  VotingSessionEnded,
  VotesTallied
}

interface Proposal {
  name: string;
  votes: number;
  id: number;
}

const App = () => {
  const [state, setState] = useState<any>({
    web3: null,
    accounts: null,
    contract: null,
    owner: null,
    events: [],
    selectedAccount: null
  });
  const [workflowStatus, setWorkflowStatus] = useState(WorkflowStatus.RegisteringVoters);
  const [voters, setVoters] = useState<string[]>([]);
  const [proposals, setProposals] = useState<Proposal[]>([]);
  const [winner, setWinner] = useState({ name: '', votes: 0 });

  useEffect(() => {
    init();
  }, []);

  const init = async () => {
    try {
      // Get network provider and web3 instance.
      const web3: any = await getWeb3();
      console.log('web3', web3);
      console.log('VotingContract', VotingContract);

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = VotingContract.networks[networkId];
      const instance = new web3.eth.Contract(VotingContract.abi, deployedNetwork && deployedNetwork.address);

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      setState({ ...state, web3, accounts, contract: instance });

      instance.events.allEvents(
        {
          fromBlock: 0
        },
        (error, event) => {
          if (error) throw new Error(error);
          handleEvents(event);
        }
      );

      await setAccountChangeListener(handleChangeAccount);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(`Failed to load web3, accounts, or contract. Check console for details.`);
      console.error(error);
    }
  };

  const handleChangeAccount = (account) => {
    if (account) {
      setState((prevState) => ({ ...prevState, selectedAccount: account.toLowerCase() }));
    }
  };

  const handleEvents = (event) => {
    if (event) {
      console.log('event', event.event, event);
    }
    if (event.event === 'OwnershipTransferred') {
      setState((prevState) => ({
        ...prevState,
        owner: event.returnValues.newOwner?.toLowerCase(),
        events: [...prevState.events, event]
      }));
    }
    if (event.event === 'WorkflowStatusChange') {
      setWorkflowStatus(Number(event.returnValues.newStatus));
    }
    if (event.event === 'VoterRegistered') {
      const newVoter = event.returnValues.voterAddress;
      setVoters((prevState) => [...prevState, newVoter.toLowerCase()]);
    }
    if (event.event === 'Voted') {
      const proposalId = event.returnValues.proposalId;
      setProposals((prevProposals) =>
        prevProposals.map((p) => (p?.id === Number(proposalId) ? { ...p, votes: p.votes + 1 } : p))
      );
    }
    if (event.event === 'Winner') {
      const name = event.returnValues.name;
      const votes = event.returnValues.votes;
      setWinner((prevState) => ({ ...prevState, name, votes }));
    }
  };

  const handleChangeStatus = async () => {
    const { contract } = state;
    await contract?.methods?.changeStatus().send({ from: state.owner });
  };

  const handleVoterSubmit = async (voter: string) => {
    if (voter) {
      await state.contract.methods.registerVoter(voter).send({ from: state.owner });
    }
  };

  const handleProposalSubmit = async (proposal: string) => {
    if (proposal) {
      const response = await state.contract.methods.addProposal(proposal).send({ from: state.selectedAccount });
      if (response.events.ProposalRegistered.event === 'ProposalRegistered') {
        const id = response.events.ProposalRegistered.returnValues.proposalId;
        const newProposal: Proposal = { id: Number(id), name: proposal, votes: 0 };
        setProposals((prevState) => [...prevState, newProposal]);
      }
    }
  };

  const handleVote = async (id: number) => {
    await state.contract?.methods?.vote(id).send({ from: state.selectedAccount });
  };

  const handleTallingVotes = async () => {
    const res = await state.contract?.methods?.tallingVotes().send({ from: state.selectedAccount });
  };

  const handleGetWinner = async () => {
    await state.contract?.methods?.getWinner().send({ from: state.selectedAccount });
  };

  const loadPhaseComponents = () => {
    switch (workflowStatus) {
      case WorkflowStatus.RegisteringVoters:
        if (state.selectedAccount === state.owner) {
          return <RegisterVoters onVoterSubmit={handleVoterSubmit} />;
        }
        return null;
      case WorkflowStatus.ProposalsRegistrationStarted:
        return <RegisterProposal onSubmitProposal={handleProposalSubmit} />;
      case WorkflowStatus.VotingSessionStarted:
        return <Voting proposals={proposals} onVote={handleVote} />;
      case WorkflowStatus.VotingSessionEnded:
        return <h3>Talling votes ...</h3>;
      case WorkflowStatus.VotesTallied:
        if (winner && winner.votes) {
          return <Winner name={winner.name} votes={winner.votes} />;
        }
        return <h3>Waiting for the winner ...</h3>;
      default:
        return <div>Nothing to show</div>;
    }
  };

  if (!state.web3) {
    return <Loader active size='huge' />;
  }
  return (
    <div className='App'>
      <AppHeader address={state.selectedAccount} />
      <Title phase={workflowStatus} />
      <Segment placeholder style={{ height: '500px' }}>
        <Grid columns={2} relaxed='very' stackable>
          <Grid.Column style={{ display: 'flex', justifyContent: 'center' }}>
            {loadPhaseComponents() || <h4>No access to this phase</h4>}
          </Grid.Column>
          {state.selectedAccount === state.owner && (
            <AdminPanel
              onGetWinner={handleGetWinner}
              onChangePhase={handleChangeStatus}
              onTallingVotes={handleTallingVotes}
              status={workflowStatus}
            />
          )}
        </Grid>
        <Divider vertical></Divider>
      </Segment>
      <PhaseLogs voters={voters} proposals={proposals} />
    </div>
  );
};

export default App;
