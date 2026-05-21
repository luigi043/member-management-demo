// Pure search/filter helper for the member list.
export function searchMembers(members = [], query = '') {
  const q = query.trim().toLowerCase();
  if (!q) return members;
  return members.filter((m) =>
    [m.name, m.email, m.role].some((field) => field.toLowerCase().includes(q))
  );
}
