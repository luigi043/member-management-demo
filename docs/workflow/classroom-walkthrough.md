# Reproducible classroom walkthrough

## Prerequisites and setup

Use Node.js 22 LTS, npm, Git, and Git Bash on Windows (Bash on macOS/Linux).
Open a terminal in `member-management-demo`, the nested repository:

```sh
npm ci
npm test
npm run lint
npm run build
npm run dev
```

Open the Vite URL printed in the terminal. Create a member, search by name/email,
edit the member, reload to confirm persistence, cancel a delete, then confirm a
delete. Try a duplicate email in different case: an error appears and the entered
form data stays available to correct. Data is stored in this browser only.

## Inspect the preserved history

```sh
git status --short
git log --oneline --graph --all --decorate
git log --merges --oneline develop
git show 616aad0
git show 0e13d51
git show v1.0.0 --stat
```

`616aad0` demonstrates a search fix after simulated review feedback. `0e13d51`
contains the resolved validation conflict. Original feature branch names remain
in merge messages even though short-lived branch refs were deleted.

## Repeat the branch and conflict exercise safely

```sh
bash scripts/build-git-history.sh
```

The script prints a new temporary rehearsal directory. Optionally pass a new,
nonexistent directory as its only argument. It refuses an existing directory,
including this checkout. It copies source assets without `.git`, dependencies,
build artifacts, coverage or `.env*`. It creates actual feature branches and
merges, triggers a validation conflict, resolves it, and tags a simulated release.
Inspect that directory using `git -C <path> log --graph --all --oneline`.
The rehearsal has no remote and cannot replace this checkout's history.
Run `npm ci` there before running application checks. Keep or remove that
rehearsal directory yourself after class.

## Practice the next real change

Start from a clean checkout of develop, create `feature/<short-description>`,
make one focused change, and run the three checks above. Inspect `git diff`,
stage only your intended files, and create a Conventional Commit. Review the
branch diff against develop using the checklist in this folder. A hosted draft
PR requires authenticated GitHub access and an explicitly authorized push.
Do not force-push the existing teaching history.

## Evidence boundaries

The named team and PR records are educational simulations. Local Git commits
and merges can be inspected directly; they do not establish that hosted PRs or
human approvals occurred. CI YAML does not itself enable branch protection.
No deployment is needed for this exercise.
