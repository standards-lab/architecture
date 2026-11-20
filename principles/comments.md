---
key: comments
name: Five kinds of comment
type: principle
level: architecture
---

# Five kinds of comment

Source carries exactly five kinds of comment:

- **Package documentation:** a package or module comment, and a doc comment on each exported
  identifier. A script's or a module's header comment counts as its package comment.
- **A suppression's reason:** the reason a lint suppression requires, written on the
  suppression.
- **A pin hold's reason:** the reason a version is held back from the latest release that
  [rolling currency](rolling-currency.md) tracks, written beside the pin.
- **Provenance:** a line naming the source repository and commit of code taken from elsewhere,
  such as `From <repo> (<commit>)` or `Adapted from <repo> (<commit>)`.
- **Reference:** one line pointing a code or configuration file at the document or principle
  that governs it, in place of restating it, such as
  `See architecture/principles/rolling-currency.md`.

Any other comment is removed, or the code changes so that it needs none.

A comment is where the justification for not doing the right thing gets written, and nothing
keeps it true once the code beside it changes. The code itself, its names, its tests, and its
checks carry everything else, and each of them fails visibly when it goes stale. The five kinds
remain because each says what the code cannot: what an API promises its consumer, why a rule
or a version is set aside, where code came from, and which document governs it. A reference
stays true because its target is the single source of truth, and the repository's check
resolves each reference, so a stale one fails visibly. The reasoning follows Lauren Tan, "All
Code Is Slop (Except Mine)", AI Engineer Code 2026.

## How the principle is enforced

Each ecosystem's stock lint rule requires a suppression's reason:

- Go: golangci-lint's `nolintlint`, with `require-explanation` and `require-specific`.
- TypeScript: typescript-eslint's `ban-ts-comment`, set to `allow-with-description`.
- ESLint directives: `@eslint-community/eslint-comments`' `require-description`.
- Rust: clippy's `allow_attributes_without_reason`.

Each repository's check resolves every reference; the architecture layer's own check does.
The standards-reviewer judges every other comment.

## Which code follows the principle

The architecture layer's own [check script](../scripts/check.sh) follows the principle and
resolves the references in the layer's scripts. No code repository follows it yet: the page,
and the reference kind with it, is a one-time exception to the rule that a page arrives only
from validated code.
