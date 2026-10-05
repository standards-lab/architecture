# goal · quality

- **State:** building
- **Task:** checks
- **Branch:** checks

## Tasks

1. [ ] checks
2. [ ] architecture-diet
3. [ ] standards

## Task brief · checks

```
Problem       The nine code repos lack one runnable check built from the
              Go ecosystem's own tooling, and CI duplicates it step by step.
              Nothing detects drift in direct dependencies, toolchain,
              actions or images.
Behaviors     1. In each code repo, `mise run check` exits 0 on main,
                 non-zero on any failing step, and leaves the tree clean.
              2. Check composes only established tooling, on every module:
                 GOWORK=off go build, go vet, gofmt -l, go fix -diff,
                 go mod tidy -diff, go test -race (unit tier), golangci-lint
                 (standard set + testpackage), and sqlint where SQL lives.
                 No hand-written rule scripts: blobfs's split-check is
                 removed entirely (mise task, CI job, README and CLAUDE.md
                 mentions). Integration and acceptance stay out (Docker).
              3. testpackage lint: a white-box test file without the
                 _internal_test/export_test suffix fails check.
              4. `mise run currency` exits non-zero when a direct go.mod
                 requirement, mise tool (Go patch included), go directive
                 minor, GitHub Action, or Compose/CI service image tag (same
                 variant suffix, via crane) trails its latest.
                 `mise run upgrade` bumps the Go and mise surfaces and
                 `go mod tidy` settles indirect. After this task, currency
                 and check pass in all 9 repos.
              5. CI runs `mise run check` (jdx/mise-action) plus the existing
                 integration / Azurite jobs, never currency. Dependabot
                 alerts and security-update PRs are on; no version-update PRs.
              6. Every pin is exact: actions (full semver), images (exact
                 tag, no digest), Go patch, tools. marathon.toml names check,
                 merge and [remote] ci. .gitignore swaps .claude/report.md
                 for .claude/briefs/.
Test seams    `mise run check` and `mise run currency` per repo
Slices        Workspace order, one per repo, each: upgrade everything stale
              first (fix breaks in-slice: watch pgx 5.11, go-observability →
              go-core v0.5.0), then check, testpackage renames, go fix
              findings, currency, CI, config, gitignore.
              1 go-core   2 sqlate   3 go-database   4 go-web-sdk
              5 go-observability   6 go-storage   7 blobfs
              8 go-web-sdk-template   9 go-web-service
Out of scope  The full lying-test evaluation (honest-tests); currency in
              marathon core and the `currency` marathon.toml key
              (factory.currency); dependency-direction, provider-leakage,
              import-boundary and doc.go gates (discipline in planning and
              review instead); Dockerfile base images (none exist yet);
              the architecture repo beyond this record; STANDARDS.md and
              CLAUDE.md; releases and tags; integration tests in check.
Door          two-way: no tags pushed; every repo change is a revertable file
              on a branch. The Dependabot security setting can be switched
              off.
```

## Progress

slices 0/9 committed · standards — · spec — · editor —

## Decisions

- checks: one read-only `mise run check` per repo; the template's marathon.toml runs `mise -C template run check`.
- checks: currency is a development-time session step, not CI; CI tests functionality; Dependabot covers security only.
- checks: currency covers direct dependencies; `go mod tidy` settles indirect ones. The toolchain counts: the mise Go pin is exact to the patch, and the go directive tracks the latest minor.
- checks: image currency uses crane, taking the highest semver within the pinned tag's suffix; tags are exact, never digests.
- checks: the check composes only the technologies' established tooling (the Go SDK including go fix, golangci-lint, crane, tests). Layer hierarchy, provider leakage, circular dependencies, and doc.go are held by discipline in planning and review, not by hand-written gates.
- checks: go-database → sqlate (downward, engine-free) and go-observability → otel/sdk (in-process; exporters in otlp) comply with the dependency line as practiced.
- checks: every stale pin is bumped in this task; no releases.
- checks: the architecture repository changes only by this record; `.claude/briefs/` stays out of git through `.git/info/exclude` until architecture-diet.
- checks: rejected depguard confinement, a transitive direction/leakage split-check, and a doc.go presence script: hand-written rules are brittle (blobfs's static split-check list is the example), so blobfs's split-check is removed.
- checks: rejected currency as a marathon extension: it is core to marathon, a language-agnostic PLAN step.
- checks: rejected CI-gated currency and Dependabot version-update PRs.

## Pending edits

- coordinator · roadmap: add `factory.currency` before `factory.evals`: marathon core gains `[project] currency`, a PLAN-time currency pass (run before round 1, release notes read, adapt and adopt questions, the upgrade as the brief's first slice), and a migration recipe naming the key per repository. Needed before quality syncs: the architect runs `marathon plan factory` to add it.
- coordinator · roadmap: add `quality.tasks.honest-tests` between checks and architecture-diet: a full evaluation of every repository's tests, a standards-reviewer over each whole suite, go-web-service in three scopes (service, integration, tools/slab).
- coordinator · roadmap: narrow `v1.data.evaluation` to code built after honest-tests, and drop its depguard re-ask.
- coordinator · roadmap: drop `backlog.library-pins`, which checks absorbs.
- coordinator · roadmap: restate the v1 criterion "The import-boundary lint is in place" as a reviewed discipline.
- architecture-diet: restate `dependencies.md`'s line as "bottom-up, no provider in a base, kept light", held by discipline; drop `service-tiers.md`'s claim that a lint step checks the boundary; update `context/standards-audit.md`'s split-check suggestion.
- standards: each STANDARDS.md points the reviewer to the hierarchy, provider, and doc.go discipline.
- v1.deployment: Dockerfile base images join each repository's currency.
