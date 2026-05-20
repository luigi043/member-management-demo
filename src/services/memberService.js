// CRUD service layer for members. Owns business rules; delegates persistence.
import { load, save } from '../utils/storage.js';
import { validateMember } from '../utils/validation.js';

function generateId() {
  return `m_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

export function getMembers() {
  return load();
}

export function getMember(id) {
  return load().find((m) => m.id === id);
}

export function createMember(data) {
  const { valid, errors } = validateMember(data);
  if (!valid) throw new Error(Object.values(errors).join(' '));

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
