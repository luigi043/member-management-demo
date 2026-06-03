import { describe, it, expect } from 'vitest';
import { searchMembers } from '../src/utils/search.js';

const sample = [
  { id: '1', name: 'Ada Lovelace', email: 'ada@math.org', role: 'Admin' },
  { id: '2', name: 'Grace Hopper', email: 'grace@navy.mil', role: 'Member' },
  { id: '3', name: 'Alan Turing', email: 'alan@bletchley.uk', role: 'Member' },
];

describe('searchMembers', () => {
  it('returns all members for a blank query', () => {
    expect(searchMembers(sample, '')).toHaveLength(3);
  });

  it('matches on name (case-insensitive)', () => {
    expect(searchMembers(sample, 'ada')).toHaveLength(1);
  });

  it('matches on email fragment', () => {
    expect(searchMembers(sample, 'navy')).toEqual([sample[1]]);
  });

  it('matches on role', () => {
    expect(searchMembers(sample, 'admin')).toEqual([sample[0]]);
  });

  it('returns empty array when nothing matches', () => {
    expect(searchMembers(sample, 'zzz')).toEqual([]);
  });
});
