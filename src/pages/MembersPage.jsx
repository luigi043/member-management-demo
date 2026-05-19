import { useState, useEffect } from 'react';
import MemberForm from '../components/MemberForm.jsx';
import MemberList from '../components/MemberList.jsx';
import { getMembers, createMember } from '../services/memberService.js';

export default function MembersPage() {
  const [members, setMembers] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => { refresh(); }, []);
  function refresh() { setMembers(getMembers()); }

  function handleCreate(data) {
    try { createMember(data); setError(''); refresh(); }
    catch (e) { setError(e.message); }
  }

  return (
    <main className="container">
      <header>
        <h1>Member Management</h1>
        <p className="subtitle">Create and view members.</p>
      </header>
      {error && <p className="banner error">{error}</p>}
      <MemberForm onSubmit={handleCreate} />
      <MemberList members={members} onEdit={() => {}} onDelete={() => {}} />
    </main>
  );
}
