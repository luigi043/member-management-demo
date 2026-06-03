# Issue Tracker (simulated)

The issues that drove the work. On GitHub these would live in the Issues tab and
be linked from each PR via `Closes #N`.

| # | Title | Type | Assignee | Linked PR | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | Create member registration form | feature | Liam Costa | #5 | Closed |
| 2 | Implement member search | feature | Noah Almeida | #6 | Closed |
| 3 | Add edit member capability | feature | Liam Costa | #7 | Closed |
| 4 | Add delete member with confirmation | feature | Noah Almeida | #8 | Closed |
| 5 | Email validation too permissive | bug | Liam Costa | #9 | Closed |

---

### Issue #1 — Create member registration form
**Type:** feature · **Assignee:** Liam Costa

Users need to add a member by entering name, email and role.

**Acceptance criteria**
- [x] Form with name, email, role fields
- [x] Inline validation errors
- [x] Duplicate email rejected
- [x] Unit tests for validation

---

### Issue #2 — Implement member search
**Type:** feature · **Assignee:** Noah Almeida

Allow filtering the member list as it grows.

**Acceptance criteria**
- [x] Case-insensitive search on name/email/role
- [x] Blank query shows all
- [x] Unit tests for the filter

---

### Issue #3 — Add edit member capability
**Type:** feature · **Assignee:** Liam Costa

**Acceptance criteria**
- [x] Reuse the form in edit mode
- [x] Validation on update
- [x] Service `updateMember` with not-found handling + tests

---

### Issue #4 — Add delete member with confirmation
**Type:** feature · **Assignee:** Noah Almeida

**Acceptance criteria**
- [x] Confirmation dialog before delete
- [x] Service `deleteMember` returns whether a record was removed
- [x] Tests

---

### Issue #5 — Email validation too permissive
**Type:** bug · **Assignee:** Liam Costa

`a@b` is currently accepted. Require a proper TLD and cap length.

**Acceptance criteria**
- [x] Reject addresses without a dot-TLD
- [x] Cap length at 254 chars
- [x] Existing tests still pass
