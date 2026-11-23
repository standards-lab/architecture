# architecture context

The architecture layer of the Standards Lab workspace: one repository holding the Elemental
Architecture, its principles, each standard's definition and principles, and a catalog of the
repositories that implement them, published as plain markdown a person reads on GitHub and a
site serves without rewriting. The root `README.md` states what belongs here and how a page
arrives.

## Capability map

- **Elemental Architecture** (built): the architecture and its principles
  ([architecture.md](../architecture.md), [principles/](../principles/)).
- **Standards** (built): each standard's definition, principles, and member catalog
  ([standards/](../standards/), one `standards/<key>/` directory per standard).
- **Page conventions** (built): the page front-matter schema and the conventions
  ([README.md](../README.md)).
- **Check** (built): every relative link resolves, every page carries the front matter its type
  requires, and `lint-context` and `lint-references` pass ([scripts/check.sh](../scripts/check.sh)),
  with marathon's tools pinned in [mise.toml](../mise.toml). No CI runs it; the merge waits on no
  checks.
- **Development-time secrets** (built): the one home for the development-time secret
  convention, each repository's own age-encrypted `fnox.toml`, and every procedure for it
  ([principles/development-secrets.md](../principles/development-secrets.md)).
- **Site hosting** (planned): architecture published as a project site
  (`standards-lab/roadmap/index.toml`, goal `sites`, task `architecture-site`).
- **Web Elemental standard** (built): a draft web standard beside Go Elemental, with Lit as its
  one runtime dependency, its member catalog, and its packages-and-releases principle
  ([standards/web-elemental/](../standards/web-elemental/)).

## Goal records

`goals/`, when present, holds one record per active goal rooted here;
`standards-lab/roadmap/index.toml` lists the goals.
