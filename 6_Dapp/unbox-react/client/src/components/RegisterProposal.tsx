import React, { useState } from 'react';
import { Button, Form, Label } from 'semantic-ui-react';

interface Props {
  onSubmitProposal: (proposal: string) => void;
}

const RegisterProposal = ({ onSubmitProposal }: Props) => {
  const [value, setValue] = useState('');

  const handleChange = ({ target: { value } }) => setValue(value);
  const handleSubmit = () => {
    onSubmitProposal(value);
    setValue('');
  };

  return (
    <Form style={{ display: 'flex', alignItems: 'start' }}>
      <Form.Field>
        <input type='text' placeholder='Proposal' value={value} onChange={handleChange} />
        {!value && (
          <Label basic color='red' pointing>
            Write a proposal
          </Label>
        )}
      </Form.Field>

      <Button primary onClick={handleSubmit}>
        Register proposal
      </Button>
    </Form>
  );
};

export default RegisterProposal;
