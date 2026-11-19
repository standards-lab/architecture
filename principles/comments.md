---
key: comments
name: Four kinds of comment
type: principle
level: architecture
---

# Four kinds of comment

Source carries exactly four kinds of comment:

- **Package documentation:** a package or module comment, and a doc comment on each exported
  identifier. A script's or a module's header comment counts as its package comment.
- **A suppression's reason:** the reason a lint suppression requires, written on the
  suppression.
- **A pin hold's reason:** the reason a version held back from the latest release requires,
  written beside the pin, as [rolling currency](rolling-currency.md) asks of any hold.
- **Provenance:** a line naming the source repository and commit of code taken from elsewhere,
  such as `From <repo> (<commit>)` or `Adapted from <repo> (<commit>)`.

Any other comment is removed, or the code changes so that it needs none.

A comment is where the justification for not doing the right thing gets written, and nothing
keeps it true once the code beside it changes. The code itself, its names, its tests, and its
checks carry everything else, and each of them fails visibly when it goes stale. The four kinds
remain because each says what the code cannot: what an API promises its consumer, why a rule
or a version is set aside, and where code came from. The reasoning follows Lauren Tan, "All
Code Is Slop (Except Mine)", AI Engineer Code 2026.

## How the principle is enforced

A suppression's reason is enforced by each ecosystem's stock lint rule:

- Go: golangci-lint's `nolintlint`, with `require-explanation` and `require-specific`.
- TypeScript: typescript-eslint's `ban-ts-comment`, set to `allow-with-description`.
- ESLint directives: `@eslint-community/eslint-comments`' `require-description`.
- Rust: clippy's `allow_attributes_without_reason`.

Every other comment is judged by the standards-reviewer. No custom tool enforces the principle.

## Where the principle stands

The page arrives before any repository's code follows it, a one-time exception to the rule
that a page arrives only from validated code. Nothing enforces it in a code repository yet:
repositories adopt it, and the lint rules above, in the planned goal `harness.adoption`.
