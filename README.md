# Member Management Demo

A deliberately small **Member Management** application built to demonstrate a
**professional Git and GitHub team workflow** — branching strategy, pull
requests, code review, conflict resolution, CI, and documentation.

> The application is intentionally simple (CRUD on members). The point of this
> repository is **how the code is built and shipped**, not the app itself.

---

## Project Overview

The app lets a user **create, view, edit, and delete** members. It is built with
React + Vite and tested with Vitest. Every feature was delivered through the same
lifecycle a real team uses: issue → feature branch → commits → pull request →
review → merge.

See [`docs/`](docs/) for the full workflow evidence (PRs, reviews, conflict
resolution) and [`docs/diagrams/`](docs/diagrams/) for the branching and
lifecycle diagrams.

## Features

| Feature | Description | Delivered in |
| --- | --- | --- |
| Create member | Form with validation + duplicate-email guard | PR #5 |
| Search members | Case-insensitive filter on name/email/role | PR #6 |
| Edit member | Reuses the form in edit mode | PR #7 |
| Delete member | Confirmation dialog before removal | PR #8 |
| Stricter validation | Hardened email rule (bugfix + conflict resolution) | PR #9 |

## Technologies Used

| Layer | Tech |
| --- | --- |
| Frontend | React 18, Vite 5 |
| Language | JavaScript (ES2022) |
| Testing | Vitest, Testing Library, jsdom |
| Quality | ESLint |
| CI | GitHub Actions |
| Persistence | `localStorage` with in-memory fallback |

## Installation

```bash
git clone https://github.com/luigi043/member-management-demo.git
cd member-management-demo
npm ci
```

## Usage

```bash
npm run dev       # start the dev server (Vite)
npm test          # run unit tests once
npm run test:watch
npm run lint      # run ESLint
npm run build     # production build
```

## Project Structure

```
member-management-demo/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── pull_request_template.md
│   └── workflows/ci.yml
├── src/
│   ├── components/   # presentational React components
│   ├── pages/        # MembersPage orchestrator
│   ├── services/     # CRUD business logic
│   └── utils/        # validation, search, storage (pure, testable)
├── tests/            # Vitest unit tests
├── docs/
│   ├── workflow/     # branching, commits, reviews, conflict resolution
│   └── diagrams/     # Mermaid git-flow / lifecycle / architecture
├── scripts/          # reproducible git-history builder
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## Git Workflow

This project uses **GitHub Flow with a `develop` integration branch**:

```
main      ← production-ready, tagged releases
  ↑ (release merge)
develop   ← integration branch, always green
  ↑ (PR merge --no-ff)
feature/* , bugfix/*   ← short-lived branches, one per issue
```

Full details: [`docs/workflow/branching-strategy.md`](docs/workflow/branching-strategy.md)
and [`docs/workflow/git-workflow.md`](docs/workflow/git-workflow.md).

### Commit convention

[Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`,
`docs:`, `test:`, `refactor:`, `chore:`. See
[`docs/workflow/commit-conventions.md`](docs/workflow/commit-conventions.md).

## Diagrams

The diagrams below render automatically on GitHub. Source files live in
[`docs/diagrams/`](docs/diagrams/) and can also be viewed at
[mermaid.live](https://mermaid.live).

### Branching model

[`docs/diagrams/git-flow.mmd`](docs/diagrams/git-flow.mmd)

```mermaid
gitGraph
   commit id: "chore: initial setup"
   branch develop
   checkout develop
   commit id: "chore: dev baseline"
   branch feature/member-registration
   checkout feature/member-registration
   commit id: "feat: form + validation"
   commit id: "test: registration"
   checkout develop
   merge feature/member-registration tag: "PR #5"
   branch feature/member-search
   checkout feature/member-search
   commit id: "feat: search filter"
   checkout develop
   merge feature/member-search tag: "PR #6"
   branch feature/member-update
   checkout feature/member-update
   commit id: "feat: edit member"
   checkout develop
   merge feature/member-update tag: "PR #7"
   branch feature/member-delete
   checkout feature/member-delete
   commit id: "feat: delete + confirm"
   checkout develop
   merge feature/member-delete tag: "PR #8"
   branch bugfix/form-validation
   checkout bugfix/form-validation
   commit id: "fix: stricter email"
   checkout develop
   merge bugfix/form-validation tag: "PR #9 (conflict)"
   checkout main
   merge develop tag: "v1.0.0"
```

### Feature lifecycle

[`docs/diagrams/lifecycle.mmd`](docs/diagrams/lifecycle.mmd)

```mermaid
flowchart TD
    A[Create GitHub Issue] --> B[Create feature branch<br/>feature/*]
    B --> C[Develop feature]
    C --> D[Commit<br/>Conventional Commits]
    D --> E[Push branch to origin]
    E --> F[Open Pull Request]
    F --> G[CI runs:<br/>lint + test + build]
    G --> H{Code review}
    H -- Changes requested --> I[Address feedback]
    I --> D
    H -- Approved --> J[Merge to develop<br/>--no-ff]
    J --> K[Delete feature branch]
    K --> L{Release ready?}
    L -- No --> A
    L -- Yes --> M[Merge develop to main<br/>tag vX.Y.Z]
    M --> N[Deploy]
```

### Application architecture

[`docs/diagrams/architecture.mmd`](docs/diagrams/architecture.mmd)

```mermaid
flowchart LR
    subgraph UI[React UI]
      P[MembersPage] --> F[MemberForm]
      P --> L[MemberList]
      L --> I[MemberItem]
      P --> S[SearchBar]
      P --> C[ConfirmDialog]
    end
    subgraph Logic[Business logic]
      SVC[memberService]
      VAL[validation]
      SR[search]
    end
    subgraph Data[Persistence]
      ST[storage<br/>localStorage + memory fallback]
    end
    P --> SVC
    F --> VAL
    P --> SR
    SVC --> VAL
    SVC --> ST
```

## Reproducing the Git History

Run a simulated branch/merge rehearsal in a new disposable directory (Git Bash on Windows, Bash on Linux/macOS):

```bash
bash scripts/build-git-history.sh
git -C <printed-rehearsal-directory> log --oneline --graph --all
```

The script copies source assets, excludes Git metadata and dependencies, and never modifies this repository or configures a remote. An explicit output path must not exist. This creates `main` + `develop` + feature/bugfix branches, conventional commits
from a simulated three-person team, `--no-ff` merges for every PR, a real merge
**conflict that is resolved**, and a tagged `v1.0.0` release.

## Contributors

Simulated team for this demonstration:

| Name | Role |
| --- | --- |
| Maya Santos | Team lead / reviewer |
| Liam Costa | Developer |
| Noah Almeida | Developer |

## License

[MIT](LICENSE).

## Classroom walkthrough and current verification

See [the reproducible walkthrough](docs/workflow/classroom-walkthrough.md) for
setup, acceptance checks, history inspection, and a safe conflict rehearsal.
The team names, PR numbers and review conversations in the original records are
**simulated course evidence**, not independently verified hosted GitHub reviews.
The existing commit graph is real local Git history. GitHub Actions reports checks;
branch protection must be configured separately to enforce required checks.

Current work is on `fix/safe-workflow-rehearsal`, based on `develop`.
See [the local review](docs/workflow/pull-requests/local-completion-review.md).

Test output images and the Word report: [Demo5 Test Evidence](docs/test-evidence/Demo5-Test-Evidence.docx). Original PNG and TXT records are alongside the document.
