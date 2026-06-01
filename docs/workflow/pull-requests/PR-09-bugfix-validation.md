# PR #9 — fix: tighten email validation

**Branch:** `bugfix/form-validation` → `develop`
**Author:** Liam Costa · **Reviewer:** Maya Santos · **Status:** ✅ Merged (merge conflict resolved)
**Closes:** #5

## Summary

`a@b` was accepted as valid. This requires a real dot-TLD and caps the address
length at 254 chars (RFC 5321).

## Changes

- `src/utils/validation.js` — stricter `EMAIL_PATTERN` + `MAX_EMAIL_LENGTH`
- `tests/validation.test.js` — added rejection cases

## ⚠️ Merge conflict

This PR conflicted with `hotfix/email-trim` (merged earlier) because both edited
the `EMAIL_PATTERN` line. Resolution kept the stricter rule. Full write-up:
[`../conflict-resolution.md`](../conflict-resolution.md).

```bash
git merge --no-ff bugfix/form-validation
# CONFLICT (content): Merge conflict in src/utils/validation.js
# -> resolved by keeping the stricter pattern + length cap
git add src/utils/validation.js
git commit
npm test   # all green after resolution
```

## Testing

- [x] New rejection tests (`a@b`, no TLD)
- [x] Existing tests still pass post-resolution

---

## Code Review — Maya Santos

> ✅ **Approved.** Good catch. Conflict resolved correctly — stricter pattern is
> the right call and the length cap is a sensible addition.

CI: ✅ lint · ✅ test · ✅ build
