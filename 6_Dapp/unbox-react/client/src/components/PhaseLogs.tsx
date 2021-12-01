import React from 'react';
import { Container, Segment } from 'semantic-ui-react';

interface Proposal {
  name: string;
  votes: number;
  id: number;
}

interface Props {
  voters: string[];
  proposals: Proposal[];
}

export const PhaseLogs = ({ voters, proposals }: Props) => {
  return (
    <Container>
      {voters.length > 0 && (
        <Segment color='teal' style={{ textAlign: 'left' }}>
          <b>Voters</b>
          <ol>
            {voters.map((voter) => (
              <li key={voter}>{voter}</li>
            ))}
          </ol>
        </Segment>
      )}
      {proposals.length > 0 && (
        <Segment color='violet' style={{ textAlign: 'left' }}>
          <b>Proposals</b>
          <ol>
            {proposals.map((proposal) => (
              <li key={proposal.id}>
                Registrated proposal <b>{proposal.id}</b> under the name <b>{proposal.name}</b> has{' '}
                <span>{proposal.votes}</span> votes
              </li>
            ))}
          </ol>
        </Segment>
      )}
    </Container>
  );
};
