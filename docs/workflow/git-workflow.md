# Git Workflow — Step by Step

The exact command sequence used to deliver one feature, end to end. This is the
lifecycle every PR in this repo followed.

## 0. One-time setup

```bash
git init
git branch -M main
git add .
git commit -m "chore: initialize project with Vite + React"
git checkout -b develop          # integration branch
```

> On GitHub you would also: create the remote repo, `git remote add origin …`,
> `git push -u origin main develop`, and enable branch protection on both.

## 1. Start from an issue

Create the issue (e.g. *#1 Create member registration form*), assign it, move it
to **In Progress** on the board.

## 2. Create the feature branch

```bash
git checkout develop
git pull                          # stay current
git checkout -b feature/member-registration
```

## 3. Develop + commit (small, conventional commits)

```bash
# ...write code...
git add src/components/MemberForm.jsx src/utils/validation.js
git commit -m "feat: add member registration form with validation"

git add tests/validation.test.js
git commit -m "test: add validation unit tests"
```

## 4. Push the branch

```bash
git push -u origin feature/member-registration
```

## 5. Open the Pull Request

Target `develop`, fill the template, link the issue (`Closes #1`). CI starts
automatically.

## 6. Code review

Reviewer leaves comments using the [checklist](code-review-checklist.md). If
changes are requested:

```bash
# ...apply feedback...
git add -A
git commit -m "refactor: extract validation messages"
git push                          # updates the same PR
```

## 7. Approve + merge

After approval and green CI:

```bash
# On GitHub: "Merge pull request" (creates a --no-ff merge commit)
# Locally the equivalent is:
git checkout develop
git merge --no-ff feature/member-registration -m "Merge PR #5: member registration"
git push
git branch -d feature/member-registration
git push origin --delete feature/member-registration
```

## 8. Release

When `develop` is ready to ship:

```bash
git checkout main
git merge --no-ff develop -m "Release v1.0.0"
git tag -a v1.0.0 -m "First release: full member CRUD"
git push origin main --tags
```

## Inspecting history

```bash
git log --oneline --graph --all --decorate
git log --author="Liam Costa"
git show <commit>
```
