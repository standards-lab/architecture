---
key: database-extensions
name: Database extensions
type: principle
level: go-elemental
---

# Database extensions

How a Go Elemental application uses a database extension, a feature a database engine loads
beside its own, such as a vector type and its index methods. An extension is treated like a
provider: reusable infrastructure a consumer opts into, versioned by the image the engine runs
in, declared by the application, and isolated to the packages that may use it.

## An extension's features are native tier

Everything an extension adds, its types, operators, functions, and index methods, belongs to the
native tier of the [service tiers](../../../principles/service-tiers.md): no standard defines it,
and another engine expresses it differently or not at all. Only the packages that may import a
provider use an extension's features: the composition root, the migrations, and the packages the
application's design documentation declares. Every other package stays on the standard tier, so a
port to an engine without the extension remains a list of packages. The authored SQL marks its
native use the way the [DSL-driven services](dsl-driven-services.md#what-the-standards-authored-sql-declares)
principle states, naming the extension.

## The image is the version

An extension's version is the version the engine's image carries. Each extension is built from
source onto the engine's one baseline image, the same image a repository without extensions runs,
and its version is pinned once, as one build argument in the Dockerfile, which
[rolling currency](../../../principles/rolling-currency.md) keeps current beside the `FROM` line.
No code declares an extension's version.

The image is the single version source because it is the only one that can take effect: a built
image offers exactly the version it was built with, so a version declared anywhere else either
agrees with the image or loses to it. Building from source onto the one baseline keeps every
extension on the engine's own distribution and release, so adding an extension layers onto the
image every repository already runs, and the engine never waits on an extension's prebuilt
images to move. [sqlate's compose Dockerfile](https://github.com/standards-lab/sqlate/blob/postgres/pgvector/v0.1.0/compose/postgres/Dockerfile)
is an example.

## The application declares extensions by name

The application declares each extension it uses by name only, and the migrator reconciles each
declaration against the engine's catalog ahead of every migration set. It keeps no history table:
every run compares what the catalog reports installed with what the image offers, and acts only on
a difference. The catalog is the one record of what is installed, and an operator who installs or
updates an extension by hand changes it directly, so a separate history would drift from it with
no run able to notice. Because the reconciliation acts only on a difference, a database whose
extensions an operator has already brought to the image's versions migrates under a role that
cannot install them.

- The migrator fails before any set runs when a declared extension is unavailable in the image, or
  installed at a version with no update path to the image's. A schema never migrates partway onto
  an engine that lacks what the application needs, and a version the engine cannot reach is left
  to an operator rather than guessed at.
- The migrator drops an extension only when its declaration marks it removed, after the sets run,
  so one deploy can drop what depends on the extension and then the extension. Deleting a
  declaration only stops managing the extension, so losing a line of configuration never drops
  data.
- Readiness is false on any mismatch between a declaration and the catalog, as it is for a pending
  migration: a service reports itself ready only against the schema, extensions included, its code
  was written for.

[sqlate's migrator](https://github.com/standards-lab/sqlate/blob/v0.8.0/docs/features.md#migrate-schema-versioning)
is an example of the reconciliation, and
[go-database's admin service](https://github.com/standards-lab/go-database/blob/v0.13.0/admin/service.go)
of the readiness.

## An extension is its own module in each library

An extension's SQL layer is a sub-module of the SQL library, and its Go layer a sub-module of the
infrastructure library. Each extension module requires its engine's module; the engine module never
requires its extensions. A consumer that uses the engine alone takes none of an extension's code,
dependencies, or release cadence, and an extension is added or released without a release of the
engine, the way a provider stands beside the base it implements. Each extension module proves
itself in its own integration tier, against an image that carries the extension, so the engine's
suites need no extension and an extension's failure is reported as its own.
[go-database's `postgres/pgvector`](https://github.com/standards-lab/go-database/blob/postgres/pgvector/v0.1.0/postgres/pgvector/doc.go)
is an example.
