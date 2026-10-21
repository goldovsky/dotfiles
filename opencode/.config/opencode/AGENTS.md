# Global instructions

Apply to every project. A project `AGENTS.md` takes precedence on conflict.

## Communication

- Converse in French. Write code, comments, commit messages and files in
  English unless the project says otherwise.
- Be concise and factual. Say so when something is uncertain, and check
  before asserting.

## Git

- **Never commit, push or open a merge request without an explicit request.**
  No exception, even if the work looks finished and the tree is clean.
- Before committing: read `git status`, `git diff` and `git log --oneline -10`,
  follow the repository's existing commit style, stage only the intended files.
- Never commit secrets. Credentials live in `~/.secrets/` and are referenced,
  never copied.

## Work

- Read the project `AGENTS.md`, `README` and `TODO` before proposing changes;
  some ideas have already been rejected there with a reason.
- Prefer editing existing files over creating new ones.
- Run the project's lint, tests or check script after a change when one exists,
  and report what was and was not verified.
- Comments explain why, not what.

## Shell scripts

- `#!/usr/bin/env bash` and `set -euo pipefail`.
- Header comment stating role, usage and the reason the script exists.
