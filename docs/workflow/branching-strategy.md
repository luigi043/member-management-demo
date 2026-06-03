# Branching Strategy

This project uses **GitHub Flow with a long-lived `develop` integration
branch** — a lightweight model that still demonstrates protected branches,
integration, and release tagging.

## Branch types

| Branch | Lifetime | Source | Merges into | Purpose |
| --- | --- | --- | --- | --- |
| `main` | permanent | — | — | Production-ready, tagged releases only |
| `develop` | permanent | `main` | `main` | Integration branch; always green |
| `feature/*` | short-lived | `develop` | `develop` | One new feature per branch |
| `bugfix/*` | short-lived | `develop` | `develop` | Non-urgent fixes |

## Naming convention

```
feature/member-registration
feature/member-search
feature/member-update
feature/member-delete
bugfix/form-validation
```

Rules:
- lowercase, hyphen-separated slug
- one branch per issue
- delete after merge

## Rules of the model

1. **Never commit directly to `main`.** Releases reach `main` only via a merge
   from `develop`.
2. **`develop` must always be releasable.** CI runs on every PR into it.
3. **Feature branches are short-lived** to minimise divergence and conflicts.
4. **Merge with `--no-ff`** so each feature keeps a visible merge commit in the
   history (good for auditing and reverts).

## Why not trunk-based or full Git Flow?

| Model | Pros | Cons | Fit here |
| --- | --- | --- | --- |
| Trunk-based | Simple, fast CI | Needs strong CI + feature flags | Overkill for a demo |
| Full Git Flow | Explicit release/hotfix branches | Heavy for small teams | Too much ceremony |
| **GitHub Flow + develop** | Simple, shows PR + integration + release | Slightly more than pure GitHub Flow | **Chosen** |

See the rendered diagram in [`../diagrams/git-flow.mmd`](../diagrams/git-flow.mmd).
