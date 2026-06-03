# Project Board (Kanban snapshot)

A GitHub Projects board tracked the work across four columns. Final state after
the v1.0.0 release:

| To Do | In Progress | Review | Done |
| --- | --- | --- | --- |
| — | — | — | #1 Registration form |
| | | | #2 Member search |
| | | | #3 Edit member |
| | | | #4 Delete member |
| | | | #5 Email validation fix |

## Column definitions

- **To Do** — accepted issue, not started.
- **In Progress** — branch created, actively being developed.
- **Review** — PR open, awaiting code review / changes.
- **Done** — PR merged into `develop`, branch deleted.

## How a card moves

```
issue created → To Do
branch created → In Progress
PR opened     → Review
PR merged     → Done
```
