---
key: configuration-boundaries
name: Configuration boundaries
type: principle
level: harness
---

# Configuration boundaries

Agent programming divides by scope. User-scoped configuration programs identity-level behavior —
how the agent communicates, how it uses its everyday tools — for every session on the machine. A
skill programs the mechanics of its own workflow and nothing wider: it neither restates
identity-level behavior nor depends on any particular user-scope choice being present. Each
concern then has exactly one home, and neither drifts against the other.

When the user scope, `~/.claude`, carries behavior, its `CLAUDE.md` takes the same index shape a
skill uses ([a skill is an index](skill-as-index.md)): `@` pointers load the always-active
behavior files with every session, and plain references route to per-tool notes consulted when
the tool is in play.

## Worked examples

- [marathon](https://github.com/standards-lab/claude-plugins/blob/main/plugins/marathon/skills/marathon/SKILL.md)
  — the skill side: its `behavior/` tier holds only workflow conduct (planning discipline), and
  the skill makes no reference to communication style at all.
