// ---------------------------------------------------------------------------
// validation.js
// Pure, framework-agnostic validation helpers for member data.
// Kept free of React/DOM so it can be unit-tested in isolation and reused
// by both the form components and the service layer.
// ---------------------------------------------------------------------------

// Require a real dot-TLD (>= 2 letters). Tightened in PR #9 after `a@b` was
// wrongly accepted. RFC 5321 caps a full address at 254 characters.
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$/;
const MAX_EMAIL_LENGTH = 254;

/**
 * Validate a single member object.
 *
 * @param {{name?: string, email?: string, role?: string}} member
 * @returns {{ valid: boolean, errors: Record<string, string> }}
 *   `valid` is true only when there are no field errors.
 */
export function validateMember(member = {}) {
  const errors = {};

  const name = (member.name ?? '').trim();
  const email = (member.email ?? '').trim();

  // Name: required, minimum 2 characters.
  if (!name) {
    errors.name = 'Name is required.';
  } else if (name.length < 2) {
    errors.name = 'Name must be at least 2 characters.';
  }

  // Email: required, valid shape, within length limit.
  if (!email) {
    errors.email = 'Email is required.';
  } else if (email.length > MAX_EMAIL_LENGTH) {
    errors.email = 'Email is too long.';
  } else if (!EMAIL_PATTERN.test(email)) {
    errors.email = 'Email format is invalid.';
  }

  return { valid: Object.keys(errors).length === 0, errors };
}

/** Convenience boolean wrapper used where only validity matters. */
export function isValidMember(member) {
  return validateMember(member).valid;
}
