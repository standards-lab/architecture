---
key: layers
name: The layer ontology
type: page
repo: go-database
---

# The layer ontology

The base module's packages are four layers with one dependency direction:

    database  →  ast  →  operation  →  exec
    (service)    (statements)  (contracts)   (execution)

Each layer speaks its own domain language, and one verb connects them: `ast` composes
statements and renders them, `operation` holds CQRS contracts that lower to rendered SQL,
`exec` runs rendered SQL, and `database` is the service the others render and run against. The
rendered unit threading through all four is `ast.SQL` — the text and its bound arguments.

## database — the service layer

The pool wrapper with its lifecycle integration, the `Dialect` seam, the configuration block,
and the error taxonomy consumers match on. `Session` is the querying surface implemented by
both the pool and a transaction, so the dialect travels with the session and the same reads run
in either context; write runners take the transaction type concretely, so the compiler enforces
the consumer-owned transaction boundary. Committing routes the commit error through the
dialect, the one place a violation deferred to COMMIT can be classified.

## ast — the statement layer

Standard SQL as values: an abstract syntax tree whose grammar files define the vocabulary —
expressions, predicates, tables, the statements by their SQL keyword — over an internal
renderer. The sealed `Query` interface models SQL grammar's query expression (`Select`,
`Compound`), so every position grammar restricts to a query — a CTE, a derived table, a
subquery, `INSERT ... SELECT` — is enforced at compile time; the write statements render only
at the outermost position and take plain table names.

The portability promise is structural: a statement renders to SQL every engine accepts, or
fails with a typed error — never silently one-engine SQL. Where engines diverge, an optional
dialect capability is checked at the divergent render site, in one of two directions:

- **Override** — a standard feature with divergent renderings: standard emission is the
  default and a dialect replaces it. Paging is the worked case.
- **Declared native** — a feature with no standard emission: rendering goes only through the
  capability, and its absence is a typed unsupported-feature error. The write statements'
  returning clause is the worked case.

Validation runs at the earliest possible moment within each scope — statement, clause, loop
iteration — before that scope's first emission, so the outermost defect wins under the
first-failure rule.

## operation — the contract layer

Constructors shaped by what a consumer means to do, named by their CQRS side. The query side is
a projection — name-to-expression fields under a key — serving the list query (a count and page
pair over one shared WHERE) and the single-row query, with request directives referencing field
names, never SQL. The command side is the identity-returning insert and the guarded update and
delete: match by key and expected version, increment the version in the same statement, and on
a miss run a check that splits not-found from version-mismatch. The guard names the consumer's
version column; the library fixes the mechanism, never the schema
([baseline-standard ownership](../principles/baseline-standards.md)).

## exec — the execution layer

The only layer that touches `database/sql` at runtime. Query runners take a `Session`; command
runners take the transaction. Every runner renders the SQL its operation would be hand-written
as, routes every driver error through the dialect's classification, and maps guard outcomes to
the service layer's sentinels. The runner is the contract: the portable statement pair behind a
guarded command could be replaced by a provider-native fast path without a consumer noticing.
