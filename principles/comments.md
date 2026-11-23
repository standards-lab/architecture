---
key: comments
name: Five kinds of comment
type: principle
level: architecture
---

# Five kinds of comment

Every comment in code, tests, scripts, and configuration (TOML, YAML, `.gitignore`, Dockerfiles,
compose files) is one of exactly five kinds:

- **Package documentation:** a package or module comment, and a doc comment on each exported
  identifier. A script's or a module's header comment counts as its package comment.
- **A suppression's reason:** the reason a lint requires where code sets a rule aside, written on
  the suppression or the construct, such as Rust's `// SAFETY:` on an `unsafe` block.
- **A pin hold's reason:** the reason a version is held back from the latest release that
  [rolling currency](rolling-currency.md) tracks, written beside the pin.
- **Third-party provenance:** one line per source of code taken from outside the workspace,
  naming the upstream, its tag or commit, and its license, with a short clause saying what
  changed, such as `From <upstream> (<tag or commit>), <license>: <what changed>`; with it stays
  any notice the license requires. Code taken from the workspace's own repositories and spikes
  carries no provenance comment: its lineage is recorded in the workspace's references catalog,
  once per repository at a commit, not per file.
- **Reference:** one line pointing a code or configuration file at the document or principle
  that governs it, in place of restating it, such as
  `See architecture/principles/rolling-currency.md`.

Any other comment is removed, or the code changes so that it needs none.

Package documentation is public, and "exported" follows each ecosystem: Go's exported
identifiers; Rust's `//!` headers and `pub` items; C#'s `public` and `protected` members; CSS's
custom properties, classes, and layers. A doc comment on an unexported identifier or a test
function is not package documentation and goes; reasoning with no other home moves into names,
an exported doc, or a docs page. A data file's header, such as a SQL file's, is its package
documentation; a comment inside a statement body is one of the five kinds or goes. A
configuration file's header is at most a short description of the file plus `See` reference
lines; its reasoning lives in the docs or the README.

A comment is where the justification for not doing the right thing gets written, and nothing keeps
it true once the code beside it changes. The code itself, its names, its tests, and its checks carry
everything else, and each of them fails visibly when it goes stale. The five kinds remain because
each says what the code cannot: what an API promises its consumer, why a rule or a version is set
aside, where third-party code came from and under what license, and which document governs it.
Provenance stays in source only for third-party code, whose license travels with it; internal
lineage has [one authoritative home](context-architecture.md), so it lives in one record rather than
in comments that drift from it. A reference stays true because its target is the single source of
truth, and the repository's check resolves each reference, so a stale one fails visibly. The
reasoning follows Lauren Tan, "All Code Is Slop (Except Mine)", AI Engineer Code 2026.

## How the principle is enforced

Each ecosystem's stock lint rule can require a suppression's reason, for example:

- Go: golangci-lint's `nolintlint`, with `require-explanation` and `require-specific`.
- TypeScript: typescript-eslint's `ban-ts-comment`, set to `allow-with-description`.
- ESLint directives: `@eslint-community/eslint-comments`' `require-description`.
- Rust: clippy's `allow_attributes_without_reason`.

A repository's check resolves every reference comment, so a stale reference fails it.
The standards-reviewer judges every other comment.
