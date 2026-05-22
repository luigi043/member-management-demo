// ---------------------------------------------------------------------------
// search.js
// Pure search/filter helper for the member list. Kept separate from the
// service so it can be unit-tested and reused by any view.
// ---------------------------------------------------------------------------

/**
 * Case-insensitive filter across name, email and role.
 * @param {Array} members
 * @param {string} query
 * @returns {Array} filtered members (returns all when query is blank)
 */
export function searchMembers(members = [], query = '') {
  const q = query.trim().toLowerCase();
  if (!q) return members;

  return members.filter((m) =>
    [m.name, m.email, m.role]
      .filter(Boolean)
      .some((field) => field.toLowerCase().includes(q))
  );
}
