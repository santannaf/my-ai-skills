---
description: "Commit and push changes with a conventional commit message"
---

Analyze the current staged and unstaged changes (git diff and git diff --cached).

Generate a conventional commit message following this pattern:
- feat: for new features
- fix: for bug fixes
- refactor: for refactoring
- docs: for documentation
- chore: for maintenance tasks
- test: for test additions/changes

Steps:
1. Run git diff to understand what changed
2. Stage all changes with git add -A
3. Generate a clear, concise commit message in English
4. Before committing, verify the git author with git config user.name and git config user.email. If they are not set or do not match my identity, ask me before proceeding.
5. Commit and push to the current branch

IMPORTANT: Never use --author flag to override authorship. Never commit as Co-authored-by or on behalf of anyone else. All commits must go out under MY git identity only.

If there are multiple unrelated changes, create separate commits for each logical unit.

Additional context: $ARGUMENTS