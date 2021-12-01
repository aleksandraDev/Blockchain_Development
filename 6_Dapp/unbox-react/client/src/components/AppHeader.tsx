import React from 'react';
import { Header, Segment } from 'semantic-ui-react';

interface Props {
  address: string;
}

const AppHeader: React.FC<Props> = ({ address }) => (
  <Segment clearing>
    <Header as='h1' floated='left'>
      Voting System
    </Header>
    <Header as='h3' floated='right'>
      {`Connected address: ${address}`}
    </Header>
  </Segment>
);
export default AppHeader;
