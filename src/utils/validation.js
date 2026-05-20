// Pure validation helpers for member data (no React/DOM, fully testable).
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export function validateMember(member = {}) {
  const errors = {};
  const name = (member.name ?? '').trim();
  const email = (member.email ?? '').trim();

  if (!name) errors.name = 'Name is required.';
  else if (name.length < 2) errors.name = 'Name must be at least 2 characters.';

  if (!email) errors.email = 'Email is required.';
  else if (!EMAIL_PATTERN.test(email)) errors.email = 'Email format is invalid.';

  return { valid: Object.keys(errors).length === 0, errors };
}

export function isValidMember(member) {
  return validateMember(member).valid;
}
