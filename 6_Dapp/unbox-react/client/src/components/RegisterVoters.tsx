import React, { useState } from 'react';
import { Button, Form, Label } from 'semantic-ui-react';

interface Props {
  onVoterSubmit: (voter: string) => void;
}

export const RegisterVoters = ({ onVoterSubmit }: Props) => {
  const [value, setValue] = useState('');

  const handleChange = ({ target: { value } }) => setValue(value);
  const handleSubmit = () => {
    onVoterSubmit(value);
    setValue('');
  };

  return (
    <Form style={{ display: 'flex', alignItems: 'flex-start' }}>
      <Form.Field>
        <input type='text' placeholder='Voter address' value={value} onChange={handleChange} />
        {!value && (
          <Label basic color='red' pointing>
            Please enter a voter address
          </Label>
        )}
      </Form.Field>

      <Button primary onClick={handleSubmit}>
        Register voter
      </Button>
    </Form>
  );
};
