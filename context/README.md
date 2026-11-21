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
  with marathon's tools pinned in [mise.toml](../mise.toml).
- **Site hosting** (planned): architecture published as a project site (the workspace roadmap's
  `sites` goal, task `architecture-site`).
- **Web Elemental standard** (planned): a draft web standard beside Go Elemental, with Lit as its
  one runtime dependency (goal v1.client.stack, task `standard`).
- **Development-time secrets** (planned): the principle for the workspace's development-time
  secret convention, a private `secrets` repository read through fnox (goal v1.ai.hosting, task
  `secrets`).

## Goal records

`goals/` holds one record per active goal rooted here; the workspace roadmap at the coordinator
lists the goals.
