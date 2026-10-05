# architecture context

The architecture layer of the Standards Lab workspace: one repository holding the Elemental
Architecture, its principles, each standard's definition and principles, and a catalog of the
repositories that implement them, published as plain markdown a person reads on GitHub and a
site serves without rewriting. The root `README.md` states what belongs here and how a page
arrives.

## Capabilities

- The Elemental Architecture (`architecture.md`) and its principles (`principles/`).
- Each standard's definition, principles, and member catalog (`standards/<key>/`).
- The front-matter schema and the conventions, in the root `README.md`.

## Site hosting

Site hosting is planned; `backlog.docs-site` in the workspace roadmap carries it.

## Notes in this directory

- `adjacent-position.md`, `dependency-sourcing.md`, `promote-on-fit.md`, and `testing-harness.md`
  have landed here for a session to turn into pages.
- `sql-meta-language.md` holds an idea.
- `standards-audit.md` holds where the pages and the code disagree, what is premature or
  duplicated, and the waiting promotion candidates: the input for `quality.architecture-diet`.
