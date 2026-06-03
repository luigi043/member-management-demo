# Merge Conflict — Worked Example

This documents the real conflict produced and resolved in the project history
(PR #9). Reproduce it with `bash scripts/build-git-history.sh`.

## How the conflict arose

Two branches changed **the same line** of `src/utils/validation.js` — the email
regular expression:

- `hotfix/email-trim` (merged first) relaxed the pattern.
- `bugfix/form-validation` (merged second) tightened the pattern and added a
  length cap.

Because both edited the same region after diverging from a common base, Git
could not auto-merge the second branch.

## What Git showed

```bash
$ git checkout develop
$ git merge --no-ff bugfix/form-validation
Auto-merging src/utils/validation.js
CONFLICT (content): Merge conflict in src/utils/validation.js
Automatic merge failed; fix conflicts and then commit the result.
```

The file contained conflict markers:

```js
<<<<<<< HEAD
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
=======
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$/;
const MAX_EMAIL_LENGTH = 254;
>>>>>>> bugfix/form-validation
```

## How it was resolved

We kept the **stricter** rule from `bugfix/form-validation` (it is a superset of
the hotfix intent) and preserved the length cap:

```js
// Resolved: require a real TLD and cap length (RFC 5321 max is 254).
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[a-zA-Z]{2,}$/;
const MAX_EMAIL_LENGTH = 254;
```

Then:

```bash
$ git add src/utils/validation.js
$ git commit            # completes the merge with a conflict-resolution message
$ npm test              # confirm nothing broke before pushing
```

## Lessons / prevention

- Keep branches short-lived and rebase/merge `develop` in often.
- Coordinate when two people touch the same module.
- Always re-run the test suite **after** resolving, before committing the merge.
