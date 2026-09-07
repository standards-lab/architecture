# The DSL docs pass — inventory

Captured at the 2026-08-31 workspace retrospective; `v1.alignment.docs` in the coordinator's
roadmap cites this note as the session's work list. The strategy it documents is the
coordinator's `standards-lab/context/design/dsl-driven-services.md`. The note is deleted at
the pass's close.

> Amended (2026-09-03): the `v1.data.sql.prototype` experiment split the mechanism out of
> go-database into `sqlate`, a standalone library. The inventory gains the sqlate pages and the
> grammar's page, recorded as the standard's own artifact with sqlate its first host; the
> go-database pages below are rewritten around the infrastructure service and the `admin`
> package rather than `query` and `migrate` inside it; a content-patterns reference (status
> filters, search, hierarchy CTEs as the domain's, never the library's) joins the principle's
> section; and the architecture definition is amended so a Domain Service anchors a domain, a
> composition of one or more Entities. The experiment's review
> (`standards-lab/experiments/sql-dsl/REVIEW.md`) is the source.

## New pages

- **The DSL-driven-services principle** (go-elemental principles): the protocol-driven versus
  DSL-driven distinction, the five things the host layer exists for, sufficiency-not-only-
  capability, structural injection safety, portability by discipline with the trade stated —
  the strategy's §2.1–2.5, in page form.
- **The context-architecture principle** (org principles): the single-source-of-truth rule
  for written context, from the coordinator's `design/context-architecture.md`, stated for
  human contributors.
- **The go-web-service pages**: the service is listed as "(planned)" in `index.md` and
  `standards/go-elemental/index.md` despite six merged PRs, a migrated schema, and being the
  subject of the whole v1 goal tree; no `standards/go-elemental/go-web-service/` directory
  exists, and `tier: reference` — declared as a valid front-matter value in `README.md` — is
  used by zero pages. Settle the **service page type** here: the v1 criteria require "a
  `docs/` page names each capability the service consumes, its class, and the port list" — a
  per-capability page shape the current IA (principle pages + per-library design pages) has
  no slot for.

## go-database pages (the bounded invalidation)

- `standards/go-elemental/go-database/layers.md` — total loss: all 69 lines are the four-layer
  ontology. Replaced by the v0.4 shape.
- `standards/go-elemental/go-database/index.md` — "built as four layers", the `ast`, `operation`,
  `exec`, and `seed` bullets, and a dependency line that omits sqlate; rewrite around
  `database`/`admin`/`postgres` over sqlate.
- `standards/go-elemental/go-database/dialect.md` — the "Render capabilities" half
  (`PagingRenderer` override, `ReturningRenderer` declared-native) presupposes Go-side
  rendering; rewrite around what survives (`Placeholder`, `MapError`, the divergence ledger's
  by-discipline form).
- `standards/go-elemental/go-database/providers.md` — states that a provider supplies the
  engine's `Dialect`; since v0.4.0 the dialect is `sqlate/postgres`'s and the provider
  constructs the pool alone. `tiers.md` — verify wording.
- `standards/go-elemental/go-web-sdk/reads.md:28` — "deliberately parallel to go-database's
  read vocabulary" and "go-database answers with its typed unknown-field error" (that error
  lived in `operation`; it survives into `query` — re-anchor, don't delete).
- `standards/go-elemental/go-web-sdk/middleware.md` — carries the incorrect claim that seeding
  the recorded status "removes any need to intercept the body write" (the shared writer must
  intercept `Write`); corrected by the `v1.web.adapter` session, verified here.

## Concept reframe

- `context/concepts/sql-meta-language.md` (this repo) — annotated at the retrospective,
  rewritten here: the `ast` package it treated as its permanent runtime half and lowering
  target retires; authored SQL files become the authoring surface it sits above, its
  schema-typing premise aligns with the `migrate` mechanism, and build-time fragment
  composition is its recognizable phase one. The "permanent split of labor" boundary is
  restated in those terms.

## Catalog and harness adjacents (verified here, owned elsewhere)

- `standards-lab/references.md` states each repository's purpose and points at its README
  since `v1.alignment.review`; this pass verifies the go-database entry against the new pages.
- The harness tier has no page describing the marathon code-project loop's staged form after
  v0.9.0 — the marathon session's closeout updates it; this pass verifies consistency with
  the project-kinds paragraph.
- The validation-first layering principle page, in this task's summary, lost its worked
  exhibit (the ast render layer) with go-database v0.4; the page names a current one.

## Drift inventory (`v1.alignment.review`, 2026-09-07)

Pages the code moved out from under, found by the review and left for this pass:

- `standards/go-elemental/go-core/index.md` — four packages; `process/processtest` (v0.4.0)
  is undocumented.
- `standards/go-elemental/go-web-sdk/index.md` — "`middleware` is currently the only
  sub-package" (`webtest` shipped at v0.7.0); the design list has no page for the
  error-returning handler adapter, the request helpers (`IfMatch`, `DecodeJSON`), or `webtest`.
- `standards/go-elemental/go-web-sdk/problems.md` — "the SDK maps only its own vocabulary — a
  `QueryError` is a 400" and "detail only on a 400" predate v0.6.0's built-in mappings
  (`PreconditionError`, `BodyError`) and `ErrorWriter.Detail`.
- `standards/go-elemental/go-web-sdk/reads.md` — "every remaining parameter as the filter set"
  predates the ordered filter list and the `field[op]=value` operator grammar.
- `standards/go-elemental/go-web-sdk-template/baseline.md` and `elements.md` — four packages
  (`internal/infrastructure`, `internal/domain`, `internal/reactors`, `internal/app`), five
  build points, one `/api` group, no `reads` block; template v0.6.0 collapsed the root into
  `internal/app` as one file per layer with the admin layer and its `/admin` mount. No page
  for the template's integration tier (v0.7.0).
- `architecture.md` — "a Domain Service anchors exactly one Entity" predates the 2026-09-03
  amendment.
- `standards/go-elemental/principles/tests-and-docs.md` — "CI needs no database container";
  `release-and-ci.md` — no integration job and no green-integration-licenses-release rule.
- `index.md` and `standards/go-elemental/index.md` — go-web-service "(planned)"; go-database
  listed as the only infrastructure library, sqlate absent.
- `standards/go-elemental/index.md` — the anticipated .NET standard is named `dotnet-minimal`;
  the naming rule makes it `dotnet-elemental`.
- Principle pages absent: DSL-driven services, context architecture, validation-first
  layering, rolling currency.
