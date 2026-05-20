// ---------------------------------------------------------------------------
// MemberItem
// Presentational row for a single member. Stateless: all actions are
// delegated upward via callbacks so the component stays reusable and testable.
// ---------------------------------------------------------------------------
export default function MemberItem({ member, onEdit, onDelete }) {
  return (
    <li className="member-item">
      <div className="member-info">
        <span className="member-name">{member.name}</span>
        <span className="member-email">{member.email}</span>
        <span className="member-role badge">{member.role}</span>
      </div>
      <div className="member-actions">
        <button className="link" onClick={() => onEdit(member)}>
          Edit
        </button>
        <button className="link danger" onClick={() => onDelete(member)}>
          Delete
        </button>
      </div>
    </li>
  );
}
