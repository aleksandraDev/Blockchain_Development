import React from 'react';
import { Step } from 'semantic-ui-react';

interface Props {
  phase: number;
}

const STATUS = [
  'Registering Voters',
  'Proposals Registration Started',
  'Proposals Registration Ended',
  'Voting Session Started',
  'Voting Session Ended',
  'Votes Tallied'
];

const Title = ({ phase }: Props) => (
  <Step.Group ordered size='mini'>
    {STATUS.map((label, index) => (
      <Step completed={index < phase} active={phase === index} disabled={phase < index} key={label}>
        <Step.Content>
          <Step.Title>{label}</Step.Title>
        </Step.Content>
      </Step>
    ))}
  </Step.Group>
);
export default Title;
