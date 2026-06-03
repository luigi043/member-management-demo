# Contributing Guide

Thanks for contributing to **Member Management Demo**. This guide describes the
team workflow every change must follow.

## 1. Pick up an issue

- All work starts from a GitHub Issue (see [`docs/workflow/issues.md`](docs/workflow/issues.md)).
- Assign yourself and move the card to **In Progress** on the project board.

## 2. Create a branch

Branch from `develop` using the naming convention:

| Type | Pattern | Example |
| --- | --- | --- |
| Feature | `feature/<slug>` | `feature/member-registration` |
| Bug fix | `bugfix/<slug>` | `bugfix/form-validation` |

```bash
git checkout develop
git pull
git checkout -b feature/member-registration
```

## 3. Commit using Conventional Commits

```
<type>: <short, imperative description>
```

Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

```bash
git commit -m "feat: add member registration form"
```

Keep commits small and focused. See
[`docs/workflow/commit-conventions.md`](docs/workflow/commit-conventions.md).

## 4. Open a Pull Request

- Target branch: `develop`.
- Fill in the PR template completely and link the issue (`Closes #N`).
- Ensure CI (lint + test + build) is green.

## 5. Code review

- At least **one approval** is required before merge.
- Reviewers use the [code review checklist](docs/workflow/code-review-checklist.md).
- Address every comment; push fixes to the same branch.

## 6. Merge

- Use **Merge commit (`--no-ff`)** so the feature history is preserved.
- Delete the branch after merge.

## Local checks before pushing

```bash
npm run lint
npm test
npm run build
```

## Code style

- Prefer pure, framework-agnostic functions in `utils/` and `services/`.
- Components stay presentational; state lives in `pages/`.
- Add or update tests for every behavioural change.
