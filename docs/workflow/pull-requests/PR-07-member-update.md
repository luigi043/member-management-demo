# PR #7 — feat: edit member

**Branch:** `feature/member-update` → `develop`
**Author:** Liam Costa · **Reviewer:** Noah Almeida · **Status:** ✅ Merged
**Closes:** #3

## Summary

Adds the ability to edit an existing member by reusing `MemberForm` in edit mode.

## Changes

- `src/services/memberService.js` — `updateMember` with not-found handling
- `src/pages/MembersPage.jsx` — edit state + handler, form switches mode
- `tests/memberService.test.js` — update cases

## Testing

- [x] Update success + not-found tests
- [x] `npm test` passes

---

## Code Review — Noah Almeida

> 🟢 **Approved with a nit (non-blocking)**

**Nit:** consider stamping `updatedAt` on update so the UI could later show "last
edited". Not required for this PR.

> Validation reuse via `validateMember(merged)` is clean. Not-found path is
> tested. 👍

---

## Author response — Liam Costa

> Good idea — added `updatedAt: new Date().toISOString()` in `updateMember`.

**Fix commit:** `feat: stamp updatedAt on member update`

## Merge

```bash
git merge --no-ff feature/member-update -m "Merge PR #7: edit member"
```

CI: ✅ lint · ✅ test · ✅ build
