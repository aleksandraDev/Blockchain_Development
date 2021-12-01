import React from 'react';
import { Button, Grid, Table } from 'semantic-ui-react';

interface Proposal {
  name: string;
  votes: number;
  id: number;
}

interface Props {
  proposals: Proposal[];
  onVote: (id: number) => void;
}

const Voting = ({ proposals, onVote }: Props) => {
  return (
    <div>
      <h3>Proposal list</h3>
      <Table singleLine>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell>ID</Table.HeaderCell>
            <Table.HeaderCell>Name</Table.HeaderCell>
            <Table.HeaderCell>Vote number</Table.HeaderCell>
            <Table.HeaderCell>Vote action</Table.HeaderCell>
          </Table.Row>
        </Table.Header>

        <Table.Body>
          {proposals.map((p) => (
            <Table.Row key={p.id}>
              <Table.Cell>{p.id}</Table.Cell>
              <Table.Cell>{p.name}</Table.Cell>
              <Table.Cell>{p.votes}</Table.Cell>
              <Table.Cell>
                <Button circular color='linkedin' icon='paper plane' onClick={() => onVote(p.id)} />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table.Body>
      </Table>
    </div>
  );
};

export default Voting;
