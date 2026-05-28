// ---------------------------------------------------------------------------
// memberService.js
// CRUD service layer for members. Owns all business rules (id generation,
// validation enforcement, duplicate-email checks) and delegates persistence
// to the storage module. The UI never talks to storage directly.
// ---------------------------------------------------------------------------

import { load, save } from '../utils/storage.js';
import { validateMember } from '../utils/validation.js';

/** Generate a reasonably unique id without external dependencies. */
function generateId() {
  return `m_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

/** Return all members. */
export function getMembers() {
  return load();
}

/** Return a single member by id, or undefined if not found. */
export function getMember(id) {
  return load().find((m) => m.id === id);
}

/**
 * Create a new member.
 * @throws {Error} when validation fails or the email already exists.
 */
export function createMember(data) {
  const { valid, errors } = validateMember(data);
  if (!valid) {
    throw new Error(Object.values(errors).join(' '));
  }

  const members = load();
  const email = data.email.trim().toLowerCase();
  if (members.some((m) => m.email.toLowerCase() === email)) {
    throw new Error('A member with this email already exists.');
  }

  const member = {
    id: generateId(),
    name: data.name.trim(),
    email: data.email.trim(),
    role: (data.role ?? 'Member').trim() || 'Member',
    createdAt: new Date().toISOString(),
  };

  members.push(member);
  save(members);
  return member;
}

/**
 * Update an existing member by id.
 * @throws {Error} when the member is missing or validation fails.
 */
export function updateMember(id, updates) {
  const members = load();
  const index = members.findIndex((m) => m.id === id);
  if (index === -1) {
    throw new Error('Member not found.');
  }

  const merged = { ...members[index], ...updates };
  const { valid, errors } = validateMember(merged);
  if (!valid) {
    throw new Error(Object.values(errors).join(' '));
  }

  members[index] = {
    ...merged,
    name: merged.name.trim(),
    email: merged.email.trim(),
    updatedAt: new Date().toISOString(),
  };
  save(members);
  return members[index];
}

/** Delete a member by id. Returns true if a record was removed. */
export function deleteMember(id) {
  const members = load();
  const next = members.filter((m) => m.id !== id);
  const removed = next.length !== members.length;
  if (removed) save(next);
  return removed;
}
