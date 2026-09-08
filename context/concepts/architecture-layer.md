# The architecture layer

Settled 2026-09-08, at the `v1.alignment.docs` session, when the pass found that every module
page it rewrote restated a package comment or a README and that the pages it replaced had been
invalidated by one or two releases each. The rule is the architect's, the marathon skill
codifies it (`references/context-engineering.md`, released with the next marathon tag), the
coordinator's `context/design/architecture-layer.md` is the workspace's design record, and
this repository's `CLAUDE.md` states it for sessions here. The session applied the rule to this
repository in full; this note is deleted at its close.

## The rule

This repository is the workspace's architecture. It holds only what has generalized past one
repository: a principle, a definition, a convention. Anything a reader can infer from a
repository's source does not belong here; anything that serves as a general guideline or
development principle does. A repository's implementation is documented in the repository,
with an optional README-indexed `docs/` as the accessibility layer, written for the Go
repositories as one task at v1 completion (`v1.repository-docs`). Knowledge arrives by the
promotion sequence, a concept, then a design note, then a page here, and a page that restates a
repository's implementation is a defect.
