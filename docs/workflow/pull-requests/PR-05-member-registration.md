# PR #5 — feat: member registration

**Branch:** `feature/member-registration` → `develop`
**Author:** Liam Costa · **Reviewer:** Maya Santos · **Status:** ✅ Merged (after changes)
**Closes:** #1

---

## Summary

Adds the ability to create a member via a validated form, with a duplicate-email
guard in the service layer.

## Changes

- `src/components/MemberForm.jsx` — controlled create/edit form
- `src/utils/validation.js` — pure validation helpers
- `src/services/memberService.js` — `createMember` + duplicate guard
- `tests/validation.test.js`, `tests/memberService.test.js`

## Testing

- [x] Unit tests added (validation + service)
- [x] `npm test` passes locally
- [x] Manual testing completed

---

## Code Review — Maya Santos

> 🔴 **Changes requested**

**1. `memberService.js` — duplicate check is case-sensitive**
> `grace@x.com` and `GRACE@x.com` are the same address. Normalise to lowercase
> before comparing, otherwise duplicates slip through.

**2. `MemberForm.jsx` — form resets on edit**
> The reset-after-submit will also fire in edit mode later. Guard it so it only
> resets after a *create*.

**3. `validation.js` — nit**
> Trim inputs before validating so `"  "` doesn't pass the "required" check.

✅ Architecture, naming, and tests look good otherwise.

---

## Author response — Liam Costa

> Thanks, all valid.
> - Normalised email comparison with `.toLowerCase()`.
> - Reset now guarded with `if (!initial)`.
> - Added `.trim()` in `validateMember`; added a whitespace test.

**Fix commit:** `refactor: normalize email + guard form reset (review feedback)`

---

## Re-review — Maya Santos

> ✅ **Approved.** Duplicate guard verified, whitespace test passes. Good to merge.

---

## Merge

```bash
git checkout develop
git merge --no-ff feature/member-registration -m "Merge PR #5: member registration"
git branch -d feature/member-registration
```

CI: ✅ lint · ✅ test · ✅ build
