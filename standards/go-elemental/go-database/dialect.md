---
key: dialect
name: The dialect interface
type: page
repo: go-database
---

# The dialect interface

`Dialect` is the interface a provider implements so the base module can generate SQL and
classify errors without knowing the engine: the engine's name, the bind placeholder for the nth
parameter, and the classification of a driver error. It is deliberately small; engine
divergence in rendering lives in per-feature capabilities the statement layer defines, not in
the interface itself.

## It grows by engine difference

The interface — and the capability set beside it — gains a member when the base needs to emit
or interpret something engines do differently, and not before. The bind placeholder is the
first such difference: Postgres writes `$1`, SQL Server `@p1`, SQLite `?`. Further differences
each earn their seam when a provider is built for an engine that needs it, never in
anticipation.

## Render capabilities

Where rendering diverges, the statement layer defines an optional interface a dialect
implements, checked at the divergent render site. The two directions differ in their default:

- **Override** — the feature has a standard form the base emits by default, and a dialect
  replaces the rendering. Paging is the worked case: the base emits SQL:2008
  `OFFSET n ROWS FETCH NEXT m ROWS ONLY`, which Postgres, SQL Server, Oracle, and DB2 accept;
  an engine that lacks it (SQLite, MySQL) opts in with its own clause.
- **Declared native** — the feature has no standard form at all, so there is nothing to fall
  back to: rendering goes only through the capability, and a statement using the feature on a
  dialect without it fails with a typed unsupported-feature error. The write statements'
  returning clause is the worked case — engines return written rows in incompatible shapes
  (`RETURNING`, `OUTPUT`, out-binds, or not at all) — and the postgres provider implements it.

Either way a statement renders portably or fails typed; it never silently emits one-engine
SQL. A provider declares its native reach in its package documentation.

## Error mapping

Error classification is where a provider translates its driver's errors into the base
sentinels, in the dual-wrapped form ([service tiers in SQL](tiers.md)). The sentinels are
declared in the base so a consumer matches them with `errors.Is` without importing a provider,
and an error no sentinel covers still reaches the caller through the wrap. Constraint
violations — unique, foreign-key, check, not-null — arrive as a `ConstraintError` wrapping the
class sentinel and the driver error while carrying the violated constraint's name; the
execution layer routes every driver error through the mapping, and the transaction's commit
routes its own error through it too, so violations an engine defers to COMMIT are classified
at the one place they surface.
