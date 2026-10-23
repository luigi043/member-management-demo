import { fireEvent, render, screen, cleanup } from '@testing-library/react';
import { afterEach, beforeEach, expect, it } from 'vitest';
import MembersPage from '../src/pages/MembersPage.jsx';
import { clear } from '../src/utils/storage.js';

beforeEach(() => clear());
afterEach(cleanup);

it('keeps rejected duplicate input and clears input after a successful create', () => {
  render(<MembersPage />);
  const name = screen.getByLabelText('Name');
  const email = screen.getByLabelText('Email');
  const submit = () => fireEvent.click(screen.getByRole('button', { name: 'Add member' }));
  fireEvent.change(name, { target: { value: 'Maya Santos' } });
  fireEvent.change(email, { target: { value: 'maya@example.com' } });
  submit();
  expect(name).toHaveValue('');
  fireEvent.change(name, { target: { value: 'Maya Duplicate' } });
  fireEvent.change(email, { target: { value: 'MAYA@example.com' } });
  submit();
  expect(screen.getByText('A member with this email already exists.')).toBeInTheDocument();
  expect(name).toHaveValue('Maya Duplicate');
  expect(email).toHaveValue('MAYA@example.com');
});
