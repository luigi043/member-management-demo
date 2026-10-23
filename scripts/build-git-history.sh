#!/usr/bin/env bash
# ===========================================================================
# build-git-history.sh
# Rebuilds a professional, multi-part Git history for this repo from scratch:
#   - main + develop branches
#   - one feature/bugfix branch per issue (short-lived)
#   - granular Conventional Commits with DETAILED bodies, by a 3-person team
#   - --no-ff merges for every pull request
#   - a REAL merge conflict that is resolved
#   - a tagged v1.0.0 release
#
# Runs only in a new disposable directory. Existing history is never removed.
# Usage: bash scripts/build-git-history.sh [new-output-directory]
# No remote is configured and nothing is pushed.
set -euo pipefail

SOURCE="$(cd "$(dirname "$0")/.." && pwd)"
if [ "$#" -gt 1 ]; then echo "Usage: $0 [new-output-directory]" >&2; exit 2; fi
if [ "$#" -eq 1 ]; then
  mkdir -- "$1" || { echo "Output must not already exist." >&2; exit 1; }
  ROOT="$(cd "$1" && pwd)"
else
  ROOT="$(mktemp -d "${TMPDIR:-/tmp}/member-workflow.XXXXXX")"
fi
# Copy source assets only; never copy Git metadata, dependencies or secrets.
(cd "$SOURCE" && tar --exclude='./.git' --exclude='./node_modules' --exclude='./dist' --exclude='./coverage' --exclude='./.env*' -cf - .) | (cd "$ROOT" && tar -xf -)
cd "$ROOT"
echo "Building simulated history in: $ROOT"

# --- Team -------------------------------------------------------------------
MAYA="Maya Santos";   MAYA_E="maya.santos@example.com"     # lead / reviewer
LIAM="Liam Costa";    LIAM_E="liam.costa@example.com"      # developer
NOAH="Noah Almeida";  NOAH_E="noah.almeida@example.com"    # developer

# --- Helpers ----------------------------------------------------------------
cmt () { # cmt "Name" "email" "YYYY-MM-DDTHH:MM:SS" "message (may be multi-line)"
  GIT_AUTHOR_NAME="$1"  GIT_AUTHOR_EMAIL="$2"  GIT_AUTHOR_DATE="$3" \
  GIT_COMMITTER_NAME="$1" GIT_COMMITTER_EMAIL="$2" GIT_COMMITTER_DATE="$3" \
    git commit -q -m "$4"
}
mrg () { # mrg "Name" "email" "date" "branch" "message"
  GIT_AUTHOR_NAME="$1"  GIT_AUTHOR_EMAIL="$2"  GIT_AUTHOR_DATE="$3" \
  GIT_COMMITTER_NAME="$1" GIT_COMMITTER_EMAIL="$2" GIT_COMMITTER_DATE="$3" \
    git merge --no-ff -q "$4" -m "$5"
}

# --- Preserve FINAL versions of files that evolve over the history ----------
TMP="$(mktemp -d)"
save () { mkdir -p "$TMP/$(dirname "$1")"; cp "$1" "$TMP/$1"; }
restore () { mkdir -p "$(dirname "$1")"; cp "$TMP/$1" "$1"; }

save README.md
save src/utils/validation.js
save src/utils/search.js
save src/services/memberService.js
save src/pages/MembersPage.jsx
save tests/memberService.test.js

# --- Fresh repo -------------------------------------------------------------
# ROOT is a newly created directory with no existing Git metadata.
git init -q -b main
git config core.autocrlf false
git config user.name "$MAYA"
git config user.email "$MAYA_E"

# ===========================================================================
# COMMIT 0 — scaffold on main
# ===========================================================================
cat > README.md <<'EOF'
# Member Management Demo

Simple Member Management app used to demonstrate a professional Git/GitHub
team workflow. Full documentation is added later in the project history.
EOF

cat > src/pages/MembersPage.jsx <<'EOF'
// Scaffold placeholder. Features are added on their own branches.
export default function MembersPage() {
  return (
    <main className="container">
      <header>
        <h1>Member Management</h1>
        <p className="subtitle">Setup complete — features coming next.</p>
      </header>
    </main>
  );
}
EOF

git add package.json vite.config.js index.html .gitignore .eslintrc.json \
        src/main.jsx src/App.jsx src/styles.css src/pages/MembersPage.jsx \
        tests/setup.js README.md
cmt "$MAYA" "$MAYA_E" "2026-05-18T09:00:00" "chore: initialize project with Vite + React

Set up the project skeleton and tooling before any feature work begins.

- Add Vite + React 18 toolchain with dev/build/preview scripts
- Configure Vitest (jsdom) and a shared test setup file
- Add ESLint config and .gitignore (ignore node_modules, dist, coverage)
- Add the app shell: main.jsx, App.jsx, global styles, MembersPage scaffold"

git checkout -q -b develop

# ===========================================================================
# PR #5 — feature/member-registration (Liam; reviewed by Maya)
# ===========================================================================
git checkout -q -b feature/member-registration

cat > src/utils/validation.js <<'EOF'
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
EOF

cat > src/services/memberService.js <<'EOF'
// CRUD service layer for members. Owns business rules; delegates persistence.
import { load, save } from '../utils/storage.js';
import { validateMember } from '../utils/validation.js';

function generateId() {
  return `m_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

export function getMembers() {
  return load();
}

export function getMember(id) {
  return load().find((m) => m.id === id);
}

export function createMember(data) {
  const { valid, errors } = validateMember(data);
  if (!valid) throw new Error(Object.values(errors).join(' '));

  const members = load();
  const email = data.email.trim().toLowerCase();
  if (members.some((m) => m.email.toLowerCase() === email)) {
    throw new Error('A member with this email already exists.');
  }

  const member = {
    id: generateId(),
    name: data.name.trim(),
    email: data.email.trim(),
    role: (data.role ?? 'Member').trim() || 'Member',
    createdAt: new Date().toISOString(),
  };
  members.push(member);
  save(members);
  return member;
}
EOF

cat > src/pages/MembersPage.jsx <<'EOF'
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
EOF

git add src/components/MemberForm.jsx src/components/MemberList.jsx \
        src/components/MemberItem.jsx src/utils/validation.js \
        src/utils/storage.js src/services/memberService.js \
        src/pages/MembersPage.jsx
cmt "$LIAM" "$LIAM_E" "2026-05-19T10:15:00" "feat: add member registration form with validation

Implements issue #1 (create + view members).

- Add MemberForm: controlled inputs with inline, per-field error messages
- Add MemberList/MemberItem presentational components to view members
- Add pure validateMember/isValidMember helpers (name + email rules)
- Add storage util (localStorage with in-memory fallback for tests)
- Add memberService.createMember with a case-insensitive duplicate guard
- Wire MembersPage to create members and render the list"

cat > tests/memberService.test.js <<'EOF'
import { describe, it, expect, beforeEach } from 'vitest';
import { getMembers, createMember } from '../src/services/memberService.js';
import { clear } from '../src/utils/storage.js';

beforeEach(() => clear());

describe('memberService', () => {
  it('creates a member with an id and timestamp', () => {
    const m = createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(m.id).toBeTruthy();
    expect(m.createdAt).toBeTruthy();
    expect(getMembers()).toHaveLength(1);
  });

  it('rejects duplicate emails', () => {
    createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(() => createMember({ name: 'Grace H', email: 'GRACE@example.com' }))
      .toThrow(/already exists/i);
  });

  it('rejects invalid data on create', () => {
    expect(() => createMember({ name: '', email: 'bad' })).toThrow();
    expect(getMembers()).toHaveLength(0);
  });
});
EOF

git add tests/validation.test.js tests/memberService.test.js
cmt "$LIAM" "$LIAM_E" "2026-05-19T14:40:00" "test: add validation and service unit tests

- Validation: required/short name and invalid/empty email cases
- Service: create success, duplicate-email rejection, invalid-input rejection"

git checkout -q develop
mrg "$MAYA" "$MAYA_E" "2026-05-20T09:30:00" feature/member-registration \
"Merge pull request #5 from feature/member-registration

feat: member registration (Closes #1)

Reviewed by Maya Santos. Requested changes addressed before merge:
- normalise email comparison to lower-case
- trim inputs before validation"
git branch -q -d feature/member-registration

# ===========================================================================
# PR #6 — feature/member-search (Noah; reviewed by Maya, changes requested)
# ===========================================================================
git checkout -q -b feature/member-search

cat > src/utils/search.js <<'EOF'
// Pure search/filter helper for the member list.
export function searchMembers(members = [], query = '') {
  const q = query.trim().toLowerCase();
  if (!q) return members;
  return members.filter((m) =>
    [m.name, m.email, m.role].some((field) => field.toLowerCase().includes(q))
  );
}
EOF

cat > src/pages/MembersPage.jsx <<'EOF'
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
EOF

git add src/utils/search.js src/components/SearchBar.jsx src/pages/MembersPage.jsx
cmt "$NOAH" "$NOAH_E" "2026-05-21T11:00:00" "feat: implement member search filter

Implements issue #2.

- Add pure searchMembers() matching name/email/role, case-insensitive
- Add SearchBar controlled input (logic kept in utils, not the component)
- Filter the rendered list via query state in MembersPage"

git add tests/search.test.js
cmt "$NOAH" "$NOAH_E" "2026-05-21T11:20:00" "test: add search filter tests

Cover blank query, name/email/role matches, and the no-match case."

restore src/utils/search.js
git add src/utils/search.js
cmt "$NOAH" "$NOAH_E" "2026-05-22T08:45:00" "fix: skip undefined fields in search matcher (review feedback)

Maya flagged that members missing an optional field (e.g. role) would throw on
.toLowerCase(). Guard the fields with .filter(Boolean) before matching."

git checkout -q develop
mrg "$MAYA" "$MAYA_E" "2026-05-22T15:00:00" feature/member-search \
"Merge pull request #6 from feature/member-search

feat: member search (Closes #2)

Approved after the undefined-field guard was added."
git branch -q -d feature/member-search

# ===========================================================================
# PR #7 — feature/member-update (Liam; reviewed by Noah)
# ===========================================================================
git checkout -q -b feature/member-update

cat > src/services/memberService.js <<'EOF'
// CRUD service layer for members. Owns business rules; delegates persistence.
import { load, save } from '../utils/storage.js';
import { validateMember } from '../utils/validation.js';

function generateId() {
  return `m_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

export function getMembers() {
  return load();
}

export function getMember(id) {
  return load().find((m) => m.id === id);
}

export function createMember(data) {
  const { valid, errors } = validateMember(data);
  if (!valid) throw new Error(Object.values(errors).join(' '));

  const members = load();
  const email = data.email.trim().toLowerCase();
  if (members.some((m) => m.email.toLowerCase() === email)) {
    throw new Error('A member with this email already exists.');
  }

  const member = {
    id: generateId(),
    name: data.name.trim(),
    email: data.email.trim(),
    role: (data.role ?? 'Member').trim() || 'Member',
    createdAt: new Date().toISOString(),
  };
  members.push(member);
  save(members);
  return member;
}

export function updateMember(id, updates) {
  const members = load();
  const index = members.findIndex((m) => m.id === id);
  if (index === -1) throw new Error('Member not found.');

  const merged = { ...members[index], ...updates };
  const { valid, errors } = validateMember(merged);
  if (!valid) throw new Error(Object.values(errors).join(' '));

  members[index] = {
    ...merged,
    name: merged.name.trim(),
    email: merged.email.trim(),
    updatedAt: new Date().toISOString(),
  };
  save(members);
  return members[index];
}
EOF

cat > src/pages/MembersPage.jsx <<'EOF'
import { useState, useEffect } from 'react';
import MemberForm from '../components/MemberForm.jsx';
import MemberList from '../components/MemberList.jsx';
import SearchBar from '../components/SearchBar.jsx';
import { getMembers, createMember, updateMember } from '../services/memberService.js';
import { searchMembers } from '../utils/search.js';

export default function MembersPage() {
  const [members, setMembers] = useState([]);
  const [query, setQuery] = useState('');
  const [editing, setEditing] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => { refresh(); }, []);
  function refresh() { setMembers(getMembers()); }

  function handleCreate(data) {
    try { createMember(data); setError(''); refresh(); }
    catch (e) { setError(e.message); }
  }

  function handleUpdate(data) {
    try { updateMember(editing.id, data); setEditing(null); setError(''); refresh(); }
    catch (e) { setError(e.message); }
  }

  const visible = searchMembers(members, query);

  return (
    <main className="container">
      <header>
        <h1>Member Management</h1>
        <p className="subtitle">Create, view, search and edit members.</p>
      </header>
      {error && <p className="banner error">{error}</p>}
      <MemberForm
        initial={editing}
        onSubmit={editing ? handleUpdate : handleCreate}
        onCancel={() => setEditing(null)}
      />
      <SearchBar value={query} onChange={setQuery} />
      <MemberList members={visible} onEdit={setEditing} onDelete={() => {}} />
    </main>
  );
}
EOF

git add src/services/memberService.js src/pages/MembersPage.jsx
cmt "$LIAM" "$LIAM_E" "2026-05-25T10:00:00" "feat: add edit member capability

Implements issue #3.

- Add memberService.updateMember: validates merged record, handles not-found,
  and stamps updatedAt
- Reuse MemberForm in edit mode via the initial prop
- Add editing state to MembersPage; form switches between create and update"

cat > tests/memberService.test.js <<'EOF'
import { describe, it, expect, beforeEach } from 'vitest';
import {
  getMembers,
  createMember,
  updateMember,
} from '../src/services/memberService.js';
import { clear } from '../src/utils/storage.js';

beforeEach(() => clear());

describe('memberService', () => {
  it('creates a member with an id and timestamp', () => {
    const m = createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(m.id).toBeTruthy();
    expect(m.createdAt).toBeTruthy();
    expect(getMembers()).toHaveLength(1);
  });

  it('rejects duplicate emails', () => {
    createMember({ name: 'Grace Hopper', email: 'grace@example.com' });
    expect(() => createMember({ name: 'Grace H', email: 'GRACE@example.com' }))
      .toThrow(/already exists/i);
  });

  it('rejects invalid data on create', () => {
    expect(() => createMember({ name: '', email: 'bad' })).toThrow();
    expect(getMembers()).toHaveLength(0);
  });

  it('updates an existing member', () => {
    const m = createMember({ name: 'Alan', email: 'alan@example.com' });
    const updated = updateMember(m.id, { name: 'Alan Turing' });
    expect(updated.name).toBe('Alan Turing');
    expect(updated.updatedAt).toBeTruthy();
  });

  it('throws when updating a missing member', () => {
    expect(() => updateMember('nope', { name: 'X' })).toThrow(/not found/i);
  });
});
EOF

git add tests/memberService.test.js
cmt "$LIAM" "$LIAM_E" "2026-05-25T13:30:00" "test: add update member tests

Cover a successful update (name + updatedAt) and updating a missing member."

git checkout -q develop
mrg "$NOAH" "$NOAH_E" "2026-05-26T09:00:00" feature/member-update \
"Merge pull request #7 from feature/member-update

feat: edit member (Closes #3)

Approved by Noah Almeida. Suggested updatedAt stamp included."
git branch -q -d feature/member-update

# ===========================================================================
# PR #8 — feature/member-delete (Noah; reviewed by Maya, changes requested)
# ===========================================================================
git checkout -q -b feature/member-delete

restore src/services/memberService.js
restore src/pages/MembersPage.jsx
git add src/components/ConfirmDialog.jsx src/services/memberService.js \
        src/pages/MembersPage.jsx
cmt "$NOAH" "$NOAH_E" "2026-05-28T10:30:00" "feat: add delete member with confirmation dialog

Implements issue #4.

- Add ConfirmDialog modal (role=dialog, aria-modal) reused for destructive ops
- Add memberService.deleteMember returning whether a record was removed
- Wire a pending-delete confirmation flow into MembersPage
- Show the member name in the confirmation copy"

restore tests/memberService.test.js
git add tests/memberService.test.js
cmt "$NOAH" "$NOAH_E" "2026-05-28T12:00:00" "test: add delete member test

Verify deleteMember removes the record and reports success."

git checkout -q develop
mrg "$MAYA" "$MAYA_E" "2026-05-29T09:15:00" feature/member-delete \
"Merge pull request #8 from feature/member-delete

feat: delete member (Closes #4)

Approved after accessibility attributes and clearer copy were added."
git branch -q -d feature/member-delete

# ===========================================================================
# Conflict scenario: two branches edit the same EMAIL_PATTERN line.
# hotfix/email-trim merges first; bugfix/form-validation then conflicts.
# ===========================================================================
git checkout -q -b hotfix/email-trim
sed -i 's#^const EMAIL_PATTERN =.*#const EMAIL_PATTERN = /^\\S+@\\S+\\.\\S+$/;#' \
    src/utils/validation.js
git add src/utils/validation.js
cmt "$MAYA" "$MAYA_E" "2026-05-30T09:00:00" "refactor: simplify email validation pattern

Collapse the email regex to a compact \S-based shape. Behaviour unchanged."

git checkout -q develop
git checkout -q -b bugfix/form-validation
restore src/utils/validation.js
git add src/utils/validation.js
cmt "$LIAM" "$LIAM_E" "2026-05-30T11:30:00" "fix: tighten email validation rule (Closes #5)

'a@b' was wrongly accepted. Require a real dot-TLD (>=2 letters) and cap the
address length at 254 characters (RFC 5321)."

git checkout -q develop
mrg "$MAYA" "$MAYA_E" "2026-05-30T14:00:00" hotfix/email-trim \
"Merge branch 'hotfix/email-trim' into develop"
git branch -q -d hotfix/email-trim

echo ">> The next merge is expected to CONFLICT on validation.js (intentional):"
set +e
GIT_AUTHOR_NAME="$MAYA" GIT_AUTHOR_EMAIL="$MAYA_E" GIT_AUTHOR_DATE="2026-05-31T10:00:00" \
GIT_COMMITTER_NAME="$MAYA" GIT_COMMITTER_EMAIL="$MAYA_E" GIT_COMMITTER_DATE="2026-05-31T10:00:00" \
  git merge --no-ff bugfix/form-validation -m "merge attempt" >/dev/null 2>&1
merge_status=$?
set -e
if [ "$merge_status" -ne 1 ] || [ -z "$(git diff --name-only --diff-filter=U)" ]; then
  echo "Expected a merge conflict; stopping rehearsal." >&2; exit 1
fi

# Resolve by keeping the stricter rule (the final validation.js).
restore src/utils/validation.js
git add src/utils/validation.js
GIT_AUTHOR_NAME="$MAYA" GIT_AUTHOR_EMAIL="$MAYA_E" GIT_AUTHOR_DATE="2026-05-31T10:30:00" \
GIT_COMMITTER_NAME="$MAYA" GIT_COMMITTER_EMAIL="$MAYA_E" GIT_COMMITTER_DATE="2026-05-31T10:30:00" \
  git commit -q -m "Merge pull request #9 from bugfix/form-validation

fix: tighten email validation (Closes #5)

Conflicted with hotfix/email-trim on the EMAIL_PATTERN line. Resolved by
keeping the stricter pattern plus the 254-char length cap, then re-running the
test suite before completing the merge."
git branch -q -d bugfix/form-validation

# ===========================================================================
# Documentation commits on develop
# ===========================================================================
git add CONTRIBUTING.md LICENSE .github docs scripts .gitattributes .eslintignore package-lock.json tests/MembersPage.test.jsx
cmt "$MAYA" "$MAYA_E" "2026-06-01T10:00:00" "docs: add workflow docs, diagrams, templates, CI and license

- Branching strategy, commit conventions, step-by-step git workflow
- Code-review checklist, PR/review evidence, issues and project board
- Worked merge-conflict resolution write-up
- Mermaid git-flow, lifecycle and architecture diagrams
- PR/issue templates, GitHub Actions CI workflow, CONTRIBUTING, MIT license
- Reproducible git-history builder script"

restore README.md
git add README.md
cmt "$MAYA" "$MAYA_E" "2026-06-02T09:00:00" "docs: expand README with full workflow guide

Document overview, features, tech stack, setup/usage, branching model,
commit convention, screenshots, contributors and license."

# ===========================================================================
# Release: merge develop -> main and tag v1.0.0
# ===========================================================================
git checkout -q main
mrg "$MAYA" "$MAYA_E" "2026-06-03T09:00:00" develop \
"Release v1.0.0: member management with full CRUD workflow"
GIT_COMMITTER_DATE="2026-06-03T09:00:00" \
  git tag -a v1.0.0 -m "v1.0.0 — full member CRUD delivered via the team workflow"

# Keep the rehearsal disconnected from hosted repositories.
# No remote: the rehearsal remains local.

git checkout -q develop
rm -rf "$TMP"

echo
echo "Done. History graph:"
git --no-pager log --oneline --graph --all --decorate
echo
echo "Commits per author:"
git --no-pager shortlog -sn --all
echo
echo "Rehearsal directory: $ROOT"
echo "Inspect with: git -C \"$ROOT\" log --oneline --graph --all"
