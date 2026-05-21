import { useState, useEffect } from 'react';
import MemberForm from '../components/MemberForm.jsx';
import MemberList from '../components/MemberList.jsx';
import SearchBar from '../components/SearchBar.jsx';
import { getMembers, createMember } from '../services/memberService.js';
import { searchMembers } from '../utils/search.js';

export default function MembersPage() {
  const [members, setMembers] = useState([]);
  const [query, setQuery] = useState('');
  const [error, setError] = useState('');

  useEffect(() => { refresh(); }, []);
  function refresh() { setMembers(getMembers()); }

  function handleCreate(data) {
    try { createMember(data); setError(''); refresh(); }
    catch (e) { setError(e.message); }
  }

  const visible = searchMembers(members, query);

  return (
    <main className="container">
      <header>
        <h1>Member Management</h1>
        <p className="subtitle">Create, view and search members.</p>
      </header>
      {error && <p className="banner error">{error}</p>}
      <MemberForm onSubmit={handleCreate} />
      <SearchBar value={query} onChange={setQuery} />
      <MemberList members={visible} onEdit={() => {}} onDelete={() => {}} />
    </main>
  );
}
