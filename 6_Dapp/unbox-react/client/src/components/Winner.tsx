import React from 'react';
import { Card, Icon, Image } from 'semantic-ui-react';

interface Props {
  name: string;
  votes: number;
}

const imgStyles = {
  display: 'flex',
  flexDirection: 'column',
  alignItems: 'center',
  height: '320px',
  justifyContent: 'center',
  width: '300px',
  padding: '10px'
};

const Winner = ({ name, votes }: Props) => (
  <Card style={imgStyles}>
    <Image size='small' src='https://react.semantic-ui.com/images/avatar/large/elliot.jpg' wrapped />
    <Card.Content>
      <Card.Header>{name}</Card.Header>
      <Card.Description>
        {`${name} is a sound engineer living in Paris who enjoys playing guitar and hanging with his cat.`}
      </Card.Description>
    </Card.Content>
    <Card.Content extra>
      <a>
        <Icon name='user' />
        {votes} votes
      </a>
    </Card.Content>
  </Card>
);

export default Winner;
