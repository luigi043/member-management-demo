import { useState, useEffect } from 'react';
import MemberForm from '../components/MemberForm.jsx';
import MemberList from '../components/MemberList.jsx';
import SearchBar from '../components/SearchBar.jsx';
import ConfirmDialog from '../components/ConfirmDialog.jsx';
import {
  getMembers,
  createMember,
  updateMember,
  deleteMember,
} from '../services/memberService.js';
import { searchMembers } from '../utils/search.js';

// ---------------------------------------------------------------------------
// MembersPage
// Top-level orchestrator that wires the service layer to the presentational
// components. Holds the view state (member list, search query, edit target,
// pending delete) and keeps a single source of truth via `refresh()`.
// ---------------------------------------------------------------------------
export default function MembersPage() {
  const [members, setMembers] = useState([]);
  const [query, setQuery] = useState('');
  const [editing, setEditing] = useState(null);
  const [pendingDelete, setPendingDelete] = useState(null);
  const [error, setError] = useState('');

  // Load members once on mount.
  useEffect(() => {
    refresh();
  }, []);

  function refresh() {
    setMembers(getMembers());
  }

  function handleCreate(data) {
    try {
      createMember(data);
      setError('');
      refresh();
      return true;
    } catch (e) {
      setError(e.message);
      return false;
    }
  }

  function handleUpdate(data) {
    try {
      updateMember(editing.id, data);
      setEditing(null);
      setError('');
      refresh();
      return true;
    } catch (e) {
      setError(e.message);
      return false;
    }
  }

  function handleDelete() {
    deleteMember(pendingDelete.id);
    setPendingDelete(null);
    refresh();
  }

  const visible = searchMembers(members, query);

  return (
    <main className="container">
      <header>
        <h1>Member Management</h1>
        <p className="subtitle">Create, view, edit and delete members.</p>
      </header>

      {error && <p className="banner error">{error}</p>}

      <MemberForm
        initial={editing}
        onSubmit={editing ? handleUpdate : handleCreate}
        onCancel={() => setEditing(null)}
      />

      <SearchBar value={query} onChange={setQuery} />

      <MemberList
        members={visible}
        onEdit={setEditing}
        onDelete={setPendingDelete}
      />

      <ConfirmDialog
        open={Boolean(pendingDelete)}
        message={`Delete ${pendingDelete?.name}? This cannot be undone.`}
        onConfirm={handleDelete}
        onCancel={() => setPendingDelete(null)}
      />
    </main>
  );
}
