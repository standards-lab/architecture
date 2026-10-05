# goal · quality

- **State:** building
- **Task:** standards
- **Branch:** standards

## Tasks

1. [x] checks
2. [x] honest-tests
3. [x] architecture-diet
4. [ ] standards

## Task brief · standards

```
Problem       The standards-reviewer reviews every task against a
              repository's STANDARDS.md and the architecture pages it
              points to, yet no repository has one, so it falls back
              to the language's general practice. The judgement calls
              it should apply sit in CLAUDE.md files, which every
              agent loads, mixed with prose that restates READMEs and
              the context-architecture principle. architecture-diet
              trimmed the layer so the pointers can land now. Each
              code repository also has a currency task its marathon
              configuration doesn't name, so PLAN can't run it, and
              the goal's pending edits leave doc.go inventories,
              doc and README wording, changelogs and tool-directive
              currency behind the architecture as practised.
Repos         go-core, sqlate, go-database, go-web-sdk,
              go-observability, go-storage, blobfs,
              go-web-sdk-template, go-web-service, architecture
Behaviors     1. Each of the ten repositories has a STANDARDS.md
                 holding judgement calls only, one line each. None
                 restates what its check enforces or what its README,
                 package documentation or guide states. Each pointer
                 is a workspace-relative path written as code, not a
                 link, and resolves to a page in the architecture
                 repository. It names the narrowest page whose rule
                 the repository's merged code follows: a Go Elemental
                 page over the architecture principle it enhances,
                 and no page the code doesn't follow. A pointer may
                 narrow its page with a convention of the
                 repository's own, never restate it. The end-of-task
                 review can name the code behind each pointer.
              2. Each code repository's STANDARDS.md points the
                 reviewer to the dependency line's bottom-up
                 hierarchy and its no-provider-in-a-base rule, and to
                 the doc.go inventory rule, all held by review rather
                 than a check.
              3. go-web-sdk's, go-storage's and go-web-service's
                 STANDARDS.md point to the timeouts page.
              4. go-web-service's STANDARDS.md carries three domain
                 judgement lines: the domain layer as a compositional
                 grouping (one package, one Domain Service, one
                 handler); a capability-named translation file per
                 domain; cross-domain coupling as an SQL check
                 downward and an injected interface upward. Its
                 domain-architecture note has no promotion-candidates
                 section.
              5. Every judgement line that only a CLAUDE.md held is a
                 STANDARDS.md line, among them the template's
                 dual-copy rule for its two CI workflows and
                 go-web-service's documented layer as the unit of
                 change. Every other CLAUDE.md line is gone because
                 the README, package documentation, guide, a check or
                 an architecture page already states it.
              6. Each of the ten CLAUDE.md files holds navigation
                 pointers only: the working context's index,
                 STANDARDS.md and the check; architecture keeps its
                 root README pointer.
              7. go-web-sdk-template keeps STANDARDS.md and CLAUDE.md
                 at its repository root only; the module gonew
                 generates gains no file.
              8. The architecture repository's STANDARDS.md says that
                 each claim on a page names the merged code or check
                 that expresses it, and that a page never restates a
                 repository's implementation. It points to the root
                 README's what-belongs-here section and the
                 context-architecture principle. Its check exempts
                 STANDARDS.md from front matter as it does CLAUDE.md.
              9. The marathon configuration of each code repository
                 names its currency command: `mise run currency` in
                 the eight with tasks at the root,
                 `mise -C template run currency` in
                 go-web-sdk-template. architecture names none. Each
                 command exits 0 with no output on the finished tree.
              10. go-web-service's and blobfs's currency commands
                  report a tool directive's module that trails its
                  latest release, as `<where>: <module> <pin> ->
                  <latest>`. They find tools through Go's own tool
                  listing (`go list tool`), not by parsing go.mod.
                  With sqlint at its latest they report nothing.
              11. go-core's process and lifecycle package
                  documentation name the entrypoint, not the
                  composition root, as what composes the run function
                  and builds the signal context, as the
                  composition-root page states.
              12. go-web-sdk's README links to the sourcing section of
                  the Go Elemental dependencies page for the markers
                  of a standard library instead of stating them.
              13. go-web-service's README calls the sweeper a Reactor,
                  not an exception to one. The template's generated
                  README describes a reactor as any process-lifetime
                  entry point driven by an occurrence, which often
                  dispatches to a domain service but need not.
              14. sqlate's postgres and sqlint changelogs each open
                  with an empty [Unreleased] section and carry link
                  definitions for [Unreleased] and each latest
                  heading, comparing from their latest released tag,
                  per Keep a Changelog.
              15. The package documentation of sqlate's query,
                  migrate, header, sqlint and sqltest packages,
                  go-observability's otlp, and each library package
                  of go-web-service's slab tool lists every export,
                  each contract stated once on its symbol. blobfs's
                  data conformance-suite package gains package
                  documentation with its inventory.
              16. Every repository's check passes on the finished
                  tree.
Test seams    Each repository's check; each code repository's
              currency command; the end-of-task standards-reviewer,
              reading each STANDARDS.md pointer and line against the
              code it cites.
Slices        No upgrade slice (every currency command reports
              current). One slice per repository, in workspace order;
              each leaves its check passing.
              1  go-core (B1, B2, B5, B6, B9, B11)
              2  sqlate (B1, B2, B5, B6, B9, B14, B15)
              3  go-database (B1, B2, B5, B6, B9)
              4  go-web-sdk (B1-B3, B5, B6, B9, B12)
              5  go-observability (B1, B2, B5, B6, B9, B15)
              6  go-storage (B1-B3, B5, B6, B9)
              7  blobfs (B1, B2, B5, B6, B9, B10, B15)
              8  go-web-sdk-template (B1, B2, B5-B7, B9, B13)
              9  go-web-service (B1-B6, B9, B10, B13, B15)
              10 architecture (B1, B6, B8, B16)
Out of scope  Releases and tags: otlp keeps its indirect go-core
              v0.4.1. A gate key in any repository. STANDARDS.md or
              CLAUDE.md inside the generated template module.
              STANDARDS.md for claude-plugins, standards-lab or any
              spike. Architecture page content. Currency changes in
              repositories with no tool directive. A check that
              resolves STANDARDS.md pointers (retro's drift pass does
              it; hand-written gates were rejected). Coordinator and
              claude-plugins edits (the sync).
Door          two-way: prose, configuration and scripts on branches,
              revertable; no tags.
```

## Progress

slices 10/10 committed (go-core cad3135, sqlate 4479c45, go-database ab1f494, go-web-sdk 5bc1921, go-observability 6a3838f, go-storage ace7f74, blobfs 7418039, go-web-sdk-template a7694e2, go-web-service 34df494, architecture e8d25fc) · standards — · spec — · editor —

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
- architecture-diet: Events cut until v1.messaging builds emission; Reactor stays.
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

- architecture-diet: escalation 1: the entrypoint-loads-configuration rule is scoped to services; slab's composition root builds its config from flags. slab will implement the CLI architecture, which leans toward startup rooted at the command level, so each command takes only its own startup dependencies.
- architecture-diet: escalation 2: Reactor is broadened (architect, per messaging.md's source-agnostic reactor contract): any process-lifetime entry point the coordinator runs, driven by an occurrence (subscription, interval, demand); it often dispatches to a Domain Service, and go-web-service's sweeper is one.
- architecture-diet: escalation 3: doc.go inventories stay a rule; the standards task brings the partial packages to it.
- architecture-diet: escalation 4: go-storage and blobfs got the `main` ruleset the other seven repositories carry (PR required, no deletion, no force push); blobfs now merges by merge commit only and deletes merged branches. release-and-ci names no exceptions.
- architecture-diet: escalation 5: cut "libraries reach their first stable major together"; no code expresses it, and graduation holds the intent.
- architecture-diet: the check reads every markdown file git tracks or would track, so ignored files such as `.claude/briefs/` are skipped; every file outside `context/` other than `CLAUDE.md` carries front matter; it resolves inline links and reference definitions, skipping fenced code, inline code spans and links with a scheme, and strips a `#fragment` without checking the anchor.
- architecture-diet: the configuration-loading rule says "web service", not "service", in the Application element, composition-root and lifecycle-and-context.
- architecture-diet: architecture.md's Principles list mirrors `principles/README.md`, with the same entries in the same order.

- standards: the architecture repository gets its own STANDARDS.md: each claim on a page names the merged code or check that expresses it, a page never restates a repository's implementation; it points to the root README's "What belongs here" and the context-architecture principle.
- standards: go-web-sdk-template keeps STANDARDS.md and CLAUDE.md at its repository root only; gonew's output gains no file, since workspace-relative pointers don't resolve in a generated service outside the workspace.
- standards: held go-core at v0.4.1 in go-observability's otlp: otlp imports no go-core package and takes it indirectly through its pin on go-observability v0.1.0, so the line moves at go-observability's next release; declined v0.5.0, the pending edit is dropped and nothing is released.
- standards: the architecture repository's check exempts STANDARDS.md from page front matter beside CLAUDE.md; it is reviewer instructions, not a page, and a new page type would grow the schema for one file.

## Pending edits

- standards: each STANDARDS.md points the reviewer to the hierarchy, provider, and doc.go discipline.
- v1.deployment: Dockerfile base images join each repository's currency.
- coordinator · `context/roadmap.toml`: remove `[goals.quality.tasks.release-and-ci]`; `[goals.quality]` and `[goals.quality.tasks.architecture-diet]` add claude-plugins to their repos and drop their `architecture/context/standards-audit.md` context key; add backlog goal `slab-json-partial-color` (go-web-service tools/slab `style.JSON` returns partly colored output when the input breaks after the first token, though its comment says any tokenizer error returns the input unchanged; fix the code or the comment); v1.harness.tasks.sitrep and .tooling context keys point to `claude-plugins/context/tool-based-skills.md`; v1.harness.tasks.local-models drops "architecture" from its repos; remove backlog goal `entrypoint-composition-split` (entry and table); backlog `sql-meta-language` drops its context key; v1.middleware's context replaces `architecture/context/dependency-sourcing.md` with `architecture/standards/go-elemental/principles/dependencies.md`, and its summary drops "(dependency-sourcing.md)"; goal cli's context or summary records that slab implements the CLI architecture, leaning toward startup rooted at the command level.
- coordinator · `context/ai-strategy.md`: cite claude-plugins' tool-based-skills note, not `architecture/harness/`.
- coordinator · `context/ai-hosting.md`: cite claude-plugins' tool-based-skills note, not `architecture/harness/`.
- coordinator · `context/service-organization.md`: cite `architecture.md`'s sinking rule and `principles/independent-releases.md` instead of the culled `architecture/context/promote-on-fit.md`.
- coordinator · `context/auth-strategy.md`: cite the sourcing section of `architecture/standards/go-elemental/principles/dependencies.md` instead of `dependency-sourcing.md`.
- coordinator · `context/cli-applications.md`: cite the sourcing section of `architecture/standards/go-elemental/principles/dependencies.md` instead of `dependency-sourcing.md`.
- coordinator · `references.md` and `references.toml`: drop the derived-standard mechanics (`derives = "<key>"`, and dotnet-elemental as go-elemental's derived standard), since architecture-diet cut derived standards; drop claude-plugins' "The harness level of the reference architecture"; stop attributing cross-standard adoption to the downward-dependencies principle, whose "Across standards" section architecture-diet cut.
- standards: go-web-service's STANDARDS.md carries the three domain-architecture judgement lines (domain layer as compositional grouping; a capability-named translation file per domain; cross-domain coupling as SQL downward and an injected interface upward) and resolves `context/domain-architecture.md`'s "Promotion candidates".
- standards: go-web-sdk, go-storage and go-web-service STANDARDS.md point to the timeouts page; go-web-sdk's README "organization's markers" points to the dependencies sourcing section.
- claude-plugins · CLAUDE.md and context/README.md: stop calling the repository "the harness level of the organization's reference architecture"; architecture-diet removed that level.
- standards: go-core `process/doc.go` says "a composition root composes its run function from it"; restate it as the entrypoint, per architecture-diet's composition-root page; likewise `lifecycle/doc.go`'s "a composition root builds" the signal context.
- standards: go-web-service's and blobfs/postgres's currency scripts report `tool` directives (sqlint), which their indirect-requirement filter hides today, as rolling-currency's developer-tools coverage states.
- standards: sqlate's `postgres/CHANGELOG.md` and `sqlint/CHANGELOG.md` gain an `[Unreleased]` section and link definitions for their latest headings (Keep a Changelog, per release-and-ci).
- standards: go-observability's `otlp` sub-module requires go-core v0.4.1 while its base is on v0.5.0; bring it current.
- standards: complete the doc.go inventories in sqlate's query, migrate, header, sqlint and sqltest packages, go-observability's otlp, and go-web-service's tools/slab; give blobfs's data/datatest a doc.go.
- standards: go-web-service's README stops calling the sweeper an exception to the Reactor ("calls a Domain Service ... so it is not one"), and the template's README stops requiring a reactor to dispatch to a domain service, per the broadened Reactor.
