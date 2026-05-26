import { describe, it, expect, beforeEach } from 'vitest';
import {
  getMembers,
  createMember,
  updateMember,
} from '../src/services/memberService.js';
import { clear } from '../src/utils/storage.js';

beforeEach(() => clear());

describe('memberService', () => {
  it('creates a member with an id and timestamp', () => {
    const m = createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(m.id).toBeTruthy();
    expect(m.createdAt).toBeTruthy();
    expect(getMembers()).toHaveLength(1);
  });

  it('rejects duplicate emails', () => {
    createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(() => createMember({ name: 'Grace H', email: 'GRACE@example.com' }))
      .toThrow(/already exists/i);
  });

  it('rejects invalid data on create', () => {
    expect(() => createMember({ name: '', email: 'bad' })).toThrow();
    expect(getMembers()).toHaveLength(0);
  });

  it('updates an existing member', () => {
    const m = createMember({ name: 'Alan', email: 'alan@example.com' });
    const updated = updateMember(m.id, { name: 'Alan Turing' });
    expect(updated.name).toBe('Alan Turing');
    expect(updated.updatedAt).toBeTruthy();
  });

  it('throws when updating a missing member', () => {
    expect(() => updateMember('nope', { name: 'X' })).toThrow(/not found/i);
  });
});
