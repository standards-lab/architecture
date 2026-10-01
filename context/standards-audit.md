# Standards audit

The input for the `quality.architecture-diet` task in the workspace roadmap. This repository is
turning reviewer-facing and pragmatic: a principle stays only if the code expresses it or a check
enforces it. A repository's `STANDARDS.md` names the pages that apply to it, and only the
standards reviewer reads them (`claude-plugins/context/marathon-factory.md`). This note records
where the pages and the code disagree today, what is premature or duplicated, and what waits to
land.

## Contradicted by the code

- **The composition root owns process entry and exit**: `principles/composition-root.md`, "It
  owns process entry and exit". In go-web-service, `cmd/server/main.go` derives the signal
  context (`process.SignalContext`), loads the configuration (`config.Load`), and owns the exit
  code (`os.Exit(run(...))`). `internal/app` receives the result. `entrypoint-composition-split.md`
  already concedes the point. Fix the page so it states the split as practiced.
- **The import-boundary lint step**: `principles/service-tiers.md` says the boundary "is declared
  … and checked" by a lint step. go-web-service has no `.golangci*` file and no depguard rule.
  Its `lint` task in `mise.toml` is plain `golangci-lint run`, followed by sqlint. The boundary
  holds in practice: provider imports appear only in `internal/app/{infrastructure,telemetry}.go`,
  `integration/harness.go`, and `tools/slab/demo/compile.go`. **Make it a check.**
- **An infrastructure base module depends on the standard library and go-core**:
  `standards/go-elemental/principles/dependencies.md`, "Infrastructure libraries". Two modules
  break the line:
  - go-observability's base `go.mod` requires the OpenTelemetry SDK (`otel/sdk`,
    `otel/sdk/metric`), and its README justifies that as an exception.
  - go-database's base requires sqlate v0.4.1, which only the unlanded `adjacent-position.md`
    covers.

  Both exceptions loosen the line, and the narrowing rule says a lower level only tightens. The
  page should either name the exceptions or state the line as practiced.
- **Rolling currency**: `principles/rolling-currency.md` requires every version to be the latest
  release. These pins are stale:
  - go-observability → go-core v0.4.1 (latest v0.5.0)
  - go-web-sdk `middleware/rate-limit` → go-web-sdk v0.13.0 (latest v0.14.0)
  - sqlate `postgres` and `sqlint` → sqlate v0.4.0 (latest v0.4.1)
  - blobfs `example` → go-storage v0.3.0 (latest v0.4.0)

  Prose can't hold this rule. **Make it a check**, and keep the page as the reason the check
  exists.

## Premature or speculative

- `principles/service-tiers.md` names OAuth 2.0, OpenID Connect, JWT, and messaging as standards,
  but there is no auth or messaging code yet. The examples should be trimmed to what is built
  (SQL, object storage, telemetry) until those layers land.
- `principles/repository-topology.md` describes a command-line SDK, a worker SDK, and focused
  reference architectures. None exists, and the CLI SDK question belongs to `goals.cli`'s
  `sdk-decision`. Keep only the tiers that have members.
- `context/sql-meta-language.md` (140 lines) is unscheduled R&D. Reduce it to its backlog entry,
  `backlog.sql-meta-language`.
- `harness/` (eight pages) is prescriptive, and only claude-plugins prose expresses it; no tooling
  code does. Move what still holds into claude-plugins, beside the plugins it governs, and delete
  the rest.

## Duplicated

- `CLAUDE.md`, "What belongs here" and "Structure", restates the root `README.md`'s "What belongs
  here" and hierarchy. That breaks this repository's own `principles/context-architecture.md`.
  `CLAUDE.md` should hold navigation pointers only.
- `standards/go-elemental/README.md`, "The dependency line", restates
  `principles/dependencies.md`. The README should point to the page.
- `standards/go-elemental/README.md`, "Member repositories", doesn't list blobfs. Its position
  waits on `adjacent-position.md`, which should land with this task.

## Promotion candidates from the v1-storage goal

These are carried from the v1-storage lane record's "Pending at the fold" (architecture layer),
which the record's sync on 2026-10-01 deleted from standards-lab (its git history keeps it).
Each was validated in code. The task decides where each one lands, or whether it becomes a
`STANDARDS.md` line instead.

- **Domain architecture**, from go-web-service `context/domain-architecture.md`, "Promotion
  candidates", proven by a second domain layer:
  - The domain layer is a compositional grouping.
  - Each domain has a capability-named translation file.
  - Cross-domain coupling runs two ways. Downward, it is an SQL check in the consumer's
    transaction. Upward, it is an interface the consumer declares and the root injects.
- **Package documentation**, as an addition to `standards/go-elemental/principles/tests-and-docs.md`:
  - Each `doc.go` stays the authoritative API description and carries an inventory that names
    every exported identifier with a one-clause role.
  - Each contract is stated once, on its symbol ("one contract, one home").
- **Timeouts**, validated across go-web-sdk, go-storage, and go-web-service:
  - The server's read and write timeouts stay tight. A route that moves a large body sets its
    own deadlines from the body's size, capped at the route's limit, with a minimum client rate
    (go-web-sdk `Transfer`).
  - A store's per-try deadline bounds one operation, never a transfer. A download resumes past
    it, and an idle bound on each read cuts off a stalled store, not a slow client (go-storage
    `ReadIdleTimeout`).
  - A stalled store's whole retry budget fits inside the write timeout, so its 503 is written,
    and a configuration test holds that budget.
  - An upload body's read deadline belongs to the client (408). The store buffers far enough
    ahead that a stalled store is never charged to the client.

## Mechanical rules that belong in `check`

- **Import boundaries**: depguard rules in each repository's golangci configuration, or a
  `split-check` task as the spikes use, enforcing the declared provider packages and the
  dependency line per tier.
- **Version currency**: a script that compares each `go.mod` pin of a `standards-lab` module with
  that module's latest tag and fails on drift.
- **Package documentation**: every package has a `doc.go`. The inventory's completeness is a
  judgement call left to the reviewer.
- **Tidy and build without the workspace**: `go mod tidy` and a `GOWORK=off` build for every
  module, which the release-and-ci page already asks for. Confirm each repository's `check`
  runs them.
