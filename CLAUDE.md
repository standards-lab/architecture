# architecture

The Standards Lab workspace's architecture: the canonical home for the Elemental Architecture,
its principles, each standard's definition and principles, the harness principles, and a
catalog of the repositories that implement them. A `context` project managed with the marathon
workflow, run by `start` and `plan`; start from `context/README.md`.

## What belongs here

This repository holds what has generalized past one repository: a principle, a definition, a
convention. Anything a reader can infer from a repository's source does not belong here.
Anything that serves as a general guideline or development principle does.

A repository documents its own implementation, in its README, its package documentation, its
source, and an optional `docs/` directory its README indexes. A page here that restates a
repository's implementation is a defect, reduced to the principle it states or removed. The
catalog names each repository with a description and a link and goes no deeper.

A page arrives by promotion and only by promotion: a note in the repository that owns the
knowledge, proven by validated work, becomes a page here once it has generalized past that one
repository. A member's `close` or `review` lands the note in this repository's flat `context/`,
and a session here authors the page.

A repository that tightens a principle states that enhancement beside its link to the principle,
in its README's Standard section. A lower level enhances the principle it derives from and
never loosens it.

## Structure

A README is every directory's index, so the tree is its own navigation on GitHub. The hierarchy
runs from universal to specific, and each directory documents one level of it:

- `README.md` is the entry page: the blueprint, the vocabulary, the map of everything here, the
  what-belongs-here rule, and the front-matter schema.
- `architecture.md` is the Elemental Architecture, the one definitive architecture the
  blueprint builds out.
- `principles/` holds the architecture's principles, the highest level of resolution.
- `standards/<key>/` holds each standard's definition, its principles, and its catalog of
  member repositories.
- `harness/` holds the principles for the agentic infrastructure the organization builds with,
  outside the software hierarchy.

Every page opens with YAML front matter; the schema is in the root `README.md`. Code on a page
is illustrative only: it links to a direct example, or it encodes a generic representation of
the pattern that stands on its own; it never depends on the current source of a repository.
