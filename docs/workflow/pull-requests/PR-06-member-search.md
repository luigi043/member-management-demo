# PR #6 — feat: member search

**Branch:** `feature/member-search` → `develop`
**Author:** Noah Almeida · **Reviewer:** Maya Santos · **Status:** ✅ Merged (after changes)
**Closes:** #2

## Summary

Adds a case-insensitive search box that filters the member list by name, email
or role.

## Changes

- `src/utils/search.js` — pure `searchMembers` filter
- `src/components/SearchBar.jsx` — controlled search input
- `src/pages/MembersPage.jsx` — wires query state to the list
- `tests/search.test.js`

## Testing

- [x] Unit tests for the filter (5 cases)
- [x] `npm test` passes

---

## Code Review — Maya Santos

> 🔴 **Changes requested**

**1. Put filtering logic in `utils`, not the component**
> Keep `SearchBar` dumb. Move the matching logic into `utils/search.js` so it's
> unit-testable in isolation. (Done in latest push? please confirm.)

**2. Guard against missing fields**
> `m.role` may be undefined for older records — filter those out before
> `.toLowerCase()` to avoid a crash.

---

## Author response — Noah Almeida

> - Logic already lives in `utils/search.js`; `SearchBar` only emits the query.
> - Added `.filter(Boolean)` before matching so missing fields are skipped.
> - Added a test with a member missing `role`.

**Fix commit:** `fix: skip undefined fields in search matcher`

---

## Re-review — Maya Santos

> ✅ **Approved.** Clean separation, good edge-case test.

## Merge

```bash
git merge --no-ff feature/member-search -m "Merge PR #6: member search"
```

CI: ✅ lint · ✅ test · ✅ build
