import React from 'react';
import { Button, Grid, Header } from 'semantic-ui-react';

enum WorkflowStatus {
  RegisteringVoters,
  ProposalsRegistrationStarted,
  ProposalsRegistrationEnded,
  VotingSessionStarted,
  VotingSessionEnded,
  VotesTallied
}

interface Props {
  onChangePhase: () => void;
  onTallingVotes: () => void;
  onGetWinner: () => void;
  status: WorkflowStatus;
}

const AdminPanel = ({ onChangePhase, onTallingVotes, onGetWinner, status }: Props) => {
  return (
    <Grid.Column verticalAlign='top'>
      <Header as='h3'>Admin Panel</Header>
      <div style={{ display: 'flex' }}>
        <Button primary icon='play' size='small' content='Change status' onClick={onChangePhase} />
        {status === WorkflowStatus.VotingSessionEnded && (
          <Button secondary icon='calculator' size='small' content='Count votes' onClick={onTallingVotes} />
        )}
        {status === WorkflowStatus.VotesTallied && (
          <Button color='teal' icon='calculator' size='small' content='Show winner' onClick={onGetWinner} />
        )}
      </div>
    </Grid.Column>
  );
};

export default AdminPanel;
