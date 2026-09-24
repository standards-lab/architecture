# The adjacent position

Two module repositories sit outside the five tiers without being harness or organization-context
repositories: `sqlate`, the SQL templating library, and `blobfs`, the virtual-directory and
file-metadata library over an object store. Each is a standalone library any Go project can adopt,
consumed by the standard's libraries or its services, and neither presents one external technology
as a service, which is what the infrastructure tier is. `repository-topology.md`'s "every module
repository of a standard belongs to exactly one" tier is then false for them, and the page names
adjacency as a position of its own.

An adjacent library:

- is adopted on its own, by any Go project, and keeps its guide in its own repository;
- takes no `go-` prefix, since it presents no one technology, and its catalog entry in the
  organization's references carries no `standard` key;
- follows the standard's engineering principles (topology and naming within the repository,
  releases and CI, tests and docs) without being one of its tiers;
- is consumed downward like any library: a tier may depend on it, and it depends on no tier above
  the core it shares.

The go-elemental catalog's paragraph on what is adjacent rather than a member names `blobfs` beside
`sqlate`: a tree of directories and file metadata in SQL over any object store, with the PostgreSQL
engine and its migration set as a sub-module.

A second amendment waits on its trigger. `blobfs` ships its own object namespace as a migration
set, the `blobfs_` tables and constraint names, which a consumer adopts beneath its own schema.
`baseline-standards.md` says nothing above the standard tier that is merely the organization's may
harden into a library's contract, and a shipped schema is exactly that, justified here because the
schema is the library's mechanism rather than the consumer's convention. The page states the
exception once a second shipper, `go-auth`, shows its shape.

Assumes an adjacent library stays standalone, with no dependency on an infrastructure library;
`blobfs` composes `go-storage` only in a module it never imports.
