# Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/).

## Format

```
<type>: <short imperative description>

[optional body explaining what and why]

[optional footer, e.g. "Closes #5"]
```

## Types

| Type | Use for |
| --- | --- |
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code change that is neither a fix nor a feature |
| `test` | Adding or updating tests |
| `chore` | Build, tooling, config |

## Examples (from this repo)

```
chore: initialize project with Vite + React
feat: add member registration form
test: add validation unit tests
feat: implement member search filter
feat: add edit member capability
feat: add delete member with confirmation dialog
fix: tighten email validation rule
docs: update README with workflow section
```

## Guidelines

- Use the **imperative mood**: "add", not "added" / "adds".
- Keep the subject line **≤ 72 characters**.
- One logical change per commit.
- Reference the issue in the body or footer (`Closes #N`).
