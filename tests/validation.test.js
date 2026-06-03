import { describe, it, expect } from 'vitest';
import { validateMember, isValidMember } from '../src/utils/validation.js';

describe('validateMember', () => {
  it('accepts a well-formed member', () => {
    const { valid, errors } = validateMember({
      name: 'Ada Lovelace',
      email: 'ada@example.com',
    });
    expect(valid).toBe(true);
    expect(errors).toEqual({});
  });

  it('requires a name', () => {
    const { valid, errors } = validateMember({ name: '', email: 'a@b.com' });
    expect(valid).toBe(false);
    expect(errors.name).toMatch(/required/i);
  });

  it('rejects a name shorter than 2 characters', () => {
    const { errors } = validateMember({ name: 'A', email: 'a@b.com' });
    expect(errors.name).toMatch(/at least 2/i);
  });

  it('rejects an invalid email', () => {
    const { errors } = validateMember({ name: 'Ada', email: 'not-an-email' });
    expect(errors.email).toMatch(/invalid/i);
  });

  it('trims surrounding whitespace before validating', () => {
    expect(isValidMember({ name: '  Ada  ', email: '  ada@example.com ' })).toBe(true);
  });
});
