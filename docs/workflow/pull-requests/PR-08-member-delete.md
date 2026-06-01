# PR #8 — feat: delete member

**Branch:** `feature/member-delete` → `develop`
**Author:** Noah Almeida · **Reviewer:** Maya Santos · **Status:** ✅ Merged (after changes)
**Closes:** #4

## Summary

Adds delete with a confirmation dialog so members aren't removed by accident.

## Changes

- `src/components/ConfirmDialog.jsx` — reusable confirm modal
- `src/services/memberService.js` — `deleteMember` returns removed boolean
- `src/pages/MembersPage.jsx` — pending-delete state + handler
- `tests/memberService.test.js` — delete case

## Testing

- [x] Delete test
- [x] `npm test` passes
- [x] Manual: cancel + confirm paths

---

## Code Review — Maya Santos

> 🔴 **Changes requested**

**1. Accessibility**
> Add `role="dialog"` and `aria-modal="true"` to the modal so it's announced to
> screen readers.

**2. Confirm copy**
> Show the member name in the prompt ("Delete Ada Lovelace?") so users know what
> they're deleting.

---

## Author response — Noah Almeida

> - Added `role="dialog"` + `aria-modal="true"`.
> - Prompt now interpolates the member name.

**Fix commit:** `fix: a11y + clearer copy on delete dialog`

---

## Re-review — Maya Santos

> ✅ **Approved.** Thanks for the a11y fix.

## Merge

```bash
git merge --no-ff feature/member-delete -m "Merge PR #8: delete member"
```

CI: ✅ lint · ✅ test · ✅ build
