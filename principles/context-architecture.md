---
key: context-architecture
name: Context architecture
type: principle
level: architecture
---

# Context architecture

Every contextual detail has exactly one authoritative home. Any other layer that needs the
detail links to that home and never restates or redefines it. A restatement is a second source
of truth from the moment it is written, and it drifts from the moment the original changes.

The principle governs every layer that carries written context: the principle pages and the
documentation landing zone, each repository's README and `CLAUDE.md` file, each project's
working context, and the harness instructions the organization builds with. It applies the
[downward-dependency principle](downward-dependencies.md) to prose: a detail is defined once,
at the layer whose authority it is, and every other layer refers to that definition by link.

## Where each kind of detail is defined

- API behavior is defined in the code and its API documentation, the `doc.go` file of a Go
  package.
- A repository's place in the architecture and its design reasoning are defined in its
  landing-zone page.
- An organizational principle is defined in the landing zone's principle pages.
- A workflow's mechanics are defined in the one file of the workflow skill that owns them.
- Direction that is in flight and not yet settled is defined in the working context of the
  repository that owns it.

## How another layer refers to a detail

A layer that needs a detail defined elsewhere cites the home. A repository README links the
landing-zone page that describes the repository. A landing-zone page links the API
documentation for a package inventory. A profile links the landing zone. A summary that adds no
information beyond the link is a restatement and is removed.

A narrowing is not a restatement. A profile that states less than the design supports, or a
repository that declares a tighter dependency line than its standard, asserts something the
home does not. The narrowing rule of the hierarchy permits that assertion, and the layer states
it beside the link to the principle it tightens.

## What each layer answers for a reader

The organization carries a large amount of technically dense information, and the layering is
how a reader digests it. Each layer answers one question and links to the layer that answers
the next one.

| Layer | The question the layer answers |
|-------|--------------------------------|
| The principle pages | What does the organization believe? |
| A landing-zone page | What is this repository, and where does it sit in the architecture? |
| A repository's `CLAUDE.md` file | How does a contributor work in this repository? |
| A repository's working context | What is in flight? |
| The code and its API documentation | What does the software do? |

## How a restatement is handled

A contributor who finds a restatement collapses it to a link in the same change, the way a
contributor already fixes a stale claim. The organization adopted the principle after finding
the same defect in three unrelated places. A role boundary restated in six repositories took a
seven-file change to update. A rule restated without its protective qualifier authorized what
the authoritative copy forbade. Package inventories restated in three places were two releases
stale in two of them while the code was current.
