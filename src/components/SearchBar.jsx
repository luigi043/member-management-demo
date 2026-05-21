// ---------------------------------------------------------------------------
// SearchBar
// Controlled search input. Emits the raw query string upward; filtering logic
// lives in utils/search.js to keep this component dumb and reusable.
// ---------------------------------------------------------------------------
export default function SearchBar({ value, onChange }) {
  return (
    <div className="search-bar">
      <input
        type="search"
        placeholder="Search by name, email or role…"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        aria-label="Search members"
      />
    </div>
  );
}
