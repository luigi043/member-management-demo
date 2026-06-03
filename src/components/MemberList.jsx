import MemberItem from './MemberItem.jsx';

// ---------------------------------------------------------------------------
// MemberList
// Renders the collection of members or an empty-state message.
// Pure presentational component driven entirely by props.
// ---------------------------------------------------------------------------
export default function MemberList({ members, onEdit, onDelete }) {
  if (!members.length) {
    return <p className="empty-state">No members yet. Add the first one above.</p>;
  }

  return (
    <ul className="member-list">
      {members.map((member) => (
        <MemberItem
          key={member.id}
          member={member}
          onEdit={onEdit}
          onDelete={onDelete}
        />
      ))}
    </ul>
  );
}
