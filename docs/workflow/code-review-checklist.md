# Code Review Checklist

Reviewers work through this list on every PR. A box left unchecked is a blocking
comment until resolved.

## Architecture
- [ ] Separation of concerns respected (UI vs service vs storage)
- [ ] No business logic leaking into presentational components
- [ ] Reusable, non-duplicated code

## Readability
- [ ] Clear, intention-revealing naming
- [ ] Consistent formatting (passes ESLint)
- [ ] Comments explain *why*, not *what*

## Correctness
- [ ] Handles empty / invalid input
- [ ] Edge cases covered (duplicate email, missing record)
- [ ] No obvious off-by-one / state bugs

## Security
- [ ] All user input validated
- [ ] No injection of unescaped user data
- [ ] Errors handled, not swallowed

## Testing
- [ ] Unit tests added/updated for new behaviour
- [ ] Edge cases tested
- [ ] `npm test` passes in CI

## Documentation
- [ ] README / docs updated where relevant
- [ ] PR description complete and issue linked
