# goal · quality

- **State:** building
- **Task:** architecture-diet
- **Branch:** architecture-diet

## Tasks

1. [x] checks
2. [x] honest-tests
3. [ ] architecture-diet
4. [ ] standards

## Task brief · architecture-diet

```
Problem       The architecture layer is what each STANDARDS.md will point
              the standards-reviewer at, yet it prescribes more than the
              code does: pages contradict the code (who owns the signal
              context, a lint step that doesn't exist, doc comments, the
              guard's home, CI shape), describe speculation (events,
              derived standards, worker SDKs, unbuilt libraries), hold a
              harness level written for marathon 0.15, and leave validated
              cross-repo rules (adjacency, sourcing, harness rules, doc.go
              inventories, timeouts) stranded in notes. The repository
              also lacks marathon 0.16's check, merge and briefs
              conventions. The standards task points into this layer
              next, so it must be trimmed first.
Repos         claude-plugins, architecture
Behaviors     1. Every page, kept or new, states only what merged code in
                 the nine code repositories expresses or a check
                 enforces; the end-of-task review can name the code
                 behind each claim.
              2. The architecture repository's check fails when any
                 relative link in its markdown doesn't resolve, or when a
                 page's front matter lacks the keys the root README's
                 schema requires for its type. It passes on the finished
                 tree.
              3. The architecture repository's marathon configuration
                 names that check and the merge command
                 `gh pr merge --merge --delete-branch`, with no ci key;
                 session briefs are git-ignored and the retired report
                 file isn't listed.
              4. The harness level is gone from the architecture
                 repository: no harness pages, no harness row or section
                 in the root README, no harness mention in the
                 context-architecture principle, CLAUDE.md or the context
                 orientation. Tool-based skills lives on as a planning
                 note in claude-plugins' context, framed as planned work
                 for v1.harness.tooling, listed in its orientation map;
                 claude-plugins' marathon-extraction note cites it there;
                 claude-plugins' check passes.
              5. The architecture says, as practised, that an
                 application's entrypoint derives the signal context,
                 loads configuration and owns the exit code, and that its
                 composition root beneath it only declares the
                 composition. The Application element, the
                 composition-root principle and Go Elemental's
                 lifecycle-and-context agree; "entrypoint" is prose in
                 Application, and the element list stays at five; the
                 entrypoint/composition-root split note is gone.
              6. No page describes event emission, derived or
                 re-expressed standards, the external catalog, or a
                 derives front-matter field; no page names a worker SDK,
                 a reference-architecture variant, or go-auth,
                 go-messaging or go-ai. The command-line SDK tier stays;
                 the Reactor element stays.
              7. Repository topology names an adjacent position for
                 standalone libraries outside the five tiers; the Go
                 Elemental catalog lists blobfs beside sqlate as
                 adjacent; topology-and-naming exempts adjacent libraries
                 from the go- prefix. No shipped-schema exception is
                 stated.
              8. Service tiers names only standards with built code and
                 calls the import boundary a reviewed discipline, not a
                 lint step.
              9. Rolling currency covers container images and leaves
                 indirect dependencies to the ecosystem's resolver, as
                 each repository's currency command does.
              10. Go Elemental's dependencies principle states the line
                  as "bottom-up, no provider in a base, kept light",
                  held by discipline, and gains the sourcing rule: when
                  to write a capability in-house and when to source one,
                  the markers of a standard library, and how sourced
                  weight is isolated.
              11. Baseline-standard ownership's worked case is sqlate's
                  optimistic-concurrency guard; no unbuilt library is
                  named.
              12. Tests and documentation states, as practised: the
                  black-box rule with the export_test clock-or-probe
                  allowance, enforced by check through testpackage; the
                  integration and acceptance suites and where each runs;
                  provider tests that may drive a loopback port-0
                  server; a link to marathon's standards-reviewer
                  definition of a lying test; the integration harness
                  rules the template's and service's suites follow; and
                  doc.go as the authoritative API description with an
                  inventory of every export, each contract stated once
                  on its symbol. "Written without doc comments" and
                  "provider tests assert construction" are gone.
              13. Releases and CI states, as practised: one check per
                  repository, with currency and upgrade beside it;
                  release preparation through a pull request; a tag
                  whose release failed may be deleted and re-pushed at
                  the same version, while a released tag is never
                  re-cut. No per-module CI matrix is described.
              14. A Go Elemental principle "Timeouts and deadlines" (key
                  timeouts), listed after lifecycle-and-context, states
                  the four validated rules: tight server timeouts with
                  size-derived per-route deadlines, a per-try deadline
                  with an idle read bound, a retry budget inside the
                  write timeout, and the upload read deadline as the
                  client's.
              15. The Go Elemental README points to the dependencies
                  principle instead of restating the line; the root
                  README says a page arrives only from validated code;
                  CLAUDE.md holds navigation pointers only.
              16. Only goal records remain in the architecture
                  repository's context; every note this task consumes or
                  cuts is gone (standards audit, promote on fit, testing
                  harness, adjacent position, dependency sourcing, SQL
                  meta language, entrypoint split), and the orientation's
                  map matches.
Test seams    Each repository's check (architecture's new script;
              claude-plugins' scripts/check.sh); the end-of-task
              standards-reviewer, reading each changed page against the
              code it cites.
Slices        No upgrade slice (claude-plugins current; architecture has
              no currency command). Each slice leaves the checks passing.
              1 Conventions: the check, marathon configuration, ignore
                file (B2, B3); passes on today's tree
              2 Harness level out; tool-based skills note in
                claude-plugins; CLAUDE.md to pointers; root README
                validated-code rule (B4, B15 in part)
              3 Entrypoint and composition root (B5)
              4 Speculation cut and topology: events, derived standards
                and catalog, worker SDK and variants, adjacency, service
                tiers, rolling currency (B6-B9)
              5 Go Elemental dependencies, baseline standards,
                topology-and-naming, README pointer (B10, B11, B15)
              6 Tests and documentation; releases and CI (B12, B13)
              7 Timeouts page (B14)
              8 Notes culled; orientation updated (B16)
Out of scope  Any code repository; STANDARDS.md files and their pointers
              (standards task); claude-plugins beyond the tool-based
              skills note, its orientation entry and the
              marathon-extraction citation; coordinator edits (pending);
              CI for architecture; a currency command; releases or tags;
              the shipped-schema exception; new pages beyond timeouts.
Door          two-way: prose and configuration on branches, revertable;
              deleted pages stay in git history; no tags.
```

## Progress

slices 8/8 committed · standards — · spec — · editor —

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
- checks: rejected Renovate in local mode as the currency tool, despite covering every surface in one config: it adds a Node dependency to the stack; the per-repo `scripts/currency.sh` over standard tools stays.
- checks: in go-web-service and the template, check runs go vet, go fix, and golangci-lint with `-tags integration`, so the integration code is compiled and linted but never run.
- checks: sqlint keeps each repository's established invocation: sqlate and blobfs run it with the workspace on, go-web-service as `go tool sqlint`.
- checks: image currency considers only dotted semver tags, because grafana also publishes bare build numbers, and it reports a new major.
- checks: the template's currency scans the workflows of both `template/` and the git top level, so it covers the template repository's root workflows while a generated app's script stays generic.
- checks: the integration and acceptance CI jobs install Go through jdx/mise-action, so `mise.toml` is the only Go pin.
- checks: `upgrade` sets each go directive to the current Go minor with `-toolchain=none`.
- checks: go-observability's `NewEnv` drops its empty-prefix guard after go-core v0.5.0 changed `EnvName`; a whitespace-only prefix now gives the zero `Env`, and a test covers it.
- checks: go-storage's azureblob `List` converts `ModifiedAt` to UTC, as Put, Get, and Stat do, because azcore v1.23.2 parses listing times in a fixed GMT zone.
- checks: the template groups its own imports last, so an app generated by gonew passes gofmt.
- checks: white-box test files flagged by testpackage are renamed to `*_internal_test.go` with unchanged contents (go-storage 2, blobfs 2, template 2, go-web-service 17); honest-tests judges them.

- honest-tests: one slice per repository in workspace order; go-web-service's collector upgrade slice first, then its three scopes (service, integration suite, tools/slab).
- honest-tests: one task, not split; each slice is committed and stands alone.
- honest-tests: a lying test is rewritten at the exported seam when the package's doc.go or README states its behavior, and deleted only when another test proves it; no documented behavior loses its last test.
- honest-tests: black-box only; every test lives in `<pkg>_test` and drives the exported API; the one allowance is an export_test hook injecting a clock or probe the API can't reach deterministically. Reverses the checks Decision allowing `_internal_test`.
- honest-tests: check enforces the black-box rule: testpackage's skip regexp narrows to export_test in all nine repos.
- honest-tests: the only guard kept is blobfs's sha256 pin on released migrations, read through the exported migration set; stage order via observable startup order, entity NULL handling via a scan on sqlate's scripted driver, or deleted where covered.
- honest-tests: integration and acceptance suites are judged by the same rules and run under Docker in each slice; check stays unit-only.
- honest-tests: no coverage measure of any kind; the strategy is truthful tests of the exported API.
- honest-tests: tests-and-docs contradictions go to architecture-diet as pending edits; the architecture repository changes only by this record.
- honest-tests: release-and-ci folds into architecture-diet; record Tasks unchanged; the roadmap entry is removed by a pending edit.
- honest-tests: go-web-service's collector image moves to 0.162.0; no breaking change touches a component its config uses.

- honest-tests: deleted go-core processtest's reaped-before-Exited Stop test (escalation 1): an undocumented edge of a test-helper package; a sync hook in Stop is neither a clock nor a probe. Stop's os.ErrProcessDone handling is now untested.
- honest-tests: deleted the template's white-box panic-recovery test (escalation 2): go-web-sdk proves Recoverer and its ordering; the template's inclusion of Recoverer has no test of its own. The export_test allowance stays clock-or-probe only.
- honest-tests: the template keeps its documented stageInfrastructure placeholder with a `//nolint:unused` directive (escalation 3), a lint-only production line.
- honest-tests: go-web-service verifies every registered store at startup by construction (escalation 4): data.Database.Register and data.NewStorage record each store's verifier and Seeder.Verify checks all of them, replacing the hand-kept list and its white-box test; the one production change beyond the brief's test-only scope.
- honest-tests: removed slab's duplicate-scenario panic, its doc sentence, and its white-box test (escalation 5); TestScenarios_ListsEachOnceInPresentationOrder pins the fixed list's distinct names, and Commands builds from Scenarios() directly.
- honest-tests: go-web-service's integration tier keeps its seed-count assertions, because the counts are the reference data a named state promises, not an inventory size.
- honest-tests: slab's fakes repeat values the service owns (the organization code pattern, the absent id, the 64 KiB command-body limit) as black-box knowledge of the service's contract rather than importing them through new exports.
- honest-tests: go-database's TestNew_UnixSocketHost keeps its socket under os.MkdirTemp, accepting that a TMPDIR long enough to push the path past the ~104-byte Unix-socket limit fails the test.
- honest-tests: go-storage's tests re-run the test binary as a child process to drive the testing.T-taking storagetest suites over broken clients and to observe the SDK's default endpoint through a proxy.
- honest-tests: tests that assert the SQL text or operation sequence on sqlate's scripted driver stay where the composed SQL or the transaction protocol is the package's documented output.

- architecture-diet: harness/ leaves the architecture layer; tool-based-skills moves to claude-plugins' context as a planning note in this task (claude-plugins joins the task, architect's call); the other seven pages are deleted, since marathon 0.18's own files express what still holds.
- architecture-diet: the composition root is restated as practised (a minimal entrypoint owns signals, config load and exit; the composition root declares), absorbing backlog goal entrypoint-composition-split.
- architecture-diet: "entrypoint" is prose inside the Application element, not a sixth element.
- architecture-diet: Events cut until v1.messaging builds emission; Reactor stays (the sweeper expresses it).
- architecture-diet: derived standards, the external catalog, re-expression and the `derives` field cut; dotnet-mirror and graduation keep that intent.
- architecture-diet: adjacency lands for sqlate and blobfs; the shipped-schema amendment is culled until a second shipper exists.
- architecture-diet: dependency sourcing lands as a section of Go Elemental dependencies.
- architecture-diet: integration harness rules land in tests-and-docs.
- architecture-diet: promote-on-fit culled; architecture.md's sinking rule already says fit.
- architecture-diet: domain-architecture candidates stay out of the layer; only go-web-service expresses them, so they become its STANDARDS.md lines.
- architecture-diet: doc.go inventory and one-contract-one-home land in tests-and-docs, replacing "written without doc comments".
- architecture-diet: timeouts land as Go Elemental page `timeouts`, "Timeouts and deadlines", after lifecycle-and-context.
- architecture-diet: sql-meta-language.md cut; the backlog entry carries the idea.
- architecture-diet: standards-audit.md culled at task end, making its update pending edit moot.
- architecture-diet: the check is a bash script for links and front matter; rejected lychee (a pinned tool and currency surface for two checks bash covers).
- architecture-diet: merge is plain `gh pr merge --merge --delete-branch` with no CI, since `gh pr checks` exits 1 with no checks; rejected a CI workflow (action pins, a currency surface).

## Pending edits

- architecture-diet: restate `dependencies.md`'s line as "bottom-up, no provider in a base, kept light", held by discipline; drop `service-tiers.md`'s claim that a lint step checks the boundary.
- standards: each STANDARDS.md points the reviewer to the hierarchy, provider, and doc.go discipline.
- v1.deployment: Dockerfile base images join each repository's currency.
- architecture-diet: `standards/go-elemental/principles/release-and-ci.md` still prescribes a per-module CI matrix and omits check, currency, and upgrade; restate it from the practice checks established.
- architecture-diet: `tests-and-docs.md` states the black-box rule as practiced, with the export_test clock/probe allowance; check enforces it through testpackage.
- architecture-diet: `tests-and-docs.md` states the integration tier as practiced (sqlate/blobfs postgres suites, go-storage Azurite acceptance beside the application tier); drop "not re-proven in CI" or restate where each runs.
- architecture-diet: `tests-and-docs.md` drops "provider tests assert construction", states that a provider test may drive a loopback port-0 test server (go-database's postgres provider tests complete a startup exchange with an in-test pgproto3 server), and links to marathon's standards-reviewer definition of a lying test.
- architecture-diet: absorb the `release-and-ci` task into the existing `release-and-ci.md` restatement (release prep via PR; a failed-release tag may be re-pushed at the same version; a released tag is never re-cut).
- coordinator · roadmap: remove `[goals.quality.tasks.release-and-ci]` from the roadmap.
- coordinator · roadmap: add backlog goal `slab-json-partial-color`: go-web-service tools/slab `style.JSON` returns partly colored output when the input breaks after the first token, though its comment says any tokenizer error returns the input unchanged; fix the code or the comment.
- coordinator · roadmap: `[goals.quality]` repos and `[goals.quality.tasks.architecture-diet]` repos add claude-plugins.
- coordinator · roadmap: v1.harness.tasks.sitrep and .tooling context keys point to `claude-plugins/context/tool-based-skills.md`; v1.harness.tasks.local-models drops "architecture" from its repos.
- coordinator · notes: `ai-strategy.md` and `ai-hosting.md` cite claude-plugins' tool-based-skills note, not `architecture/harness/`.
- coordinator · roadmap: remove backlog goal `entrypoint-composition-split` (entry and table); backlog `sql-meta-language` drops its context key; v1.middleware's context replaces `architecture/context/dependency-sourcing.md` with `architecture/standards/go-elemental/principles/dependencies.md`.
- standards: go-web-service's STANDARDS.md carries the three domain-architecture judgement lines (domain layer as compositional grouping; a capability-named translation file per domain; cross-domain coupling as SQL downward and an injected interface upward) and resolves `context/domain-architecture.md`'s "Promotion candidates".
- standards: go-web-sdk, go-storage and go-web-service STANDARDS.md point to the timeouts page; go-web-sdk's README "organization's markers" points to the dependencies sourcing section.
- claude-plugins · CLAUDE.md and context/README.md: stop calling the repository "the harness level of the organization's reference architecture"; architecture-diet removed that level.
- standards: go-core `process/doc.go` says "a composition root composes its run function from it"; restate it as the entrypoint, per architecture-diet's composition-root page.
- coordinator · notes: `service-organization.md` cites `architecture.md`'s sinking rule and `principles/independent-releases.md` instead of the culled `architecture/context/promote-on-fit.md`; `auth-strategy.md` and `cli-applications.md` cite the sourcing section of `architecture/standards/go-elemental/principles/dependencies.md` instead of `dependency-sourcing.md`; v1.middleware's summary prose drops "(dependency-sourcing.md)" for that page.
