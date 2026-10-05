# goal · quality

- **State:** idle
- **Task:** none
- **Branch:** none

## Tasks

1. [x] checks
2. [x] honest-tests
3. [ ] architecture-diet
4. [ ] standards

## Task brief · honest-tests

```
Problem       The nine code repos' suites pass, but a green check proves
              less than it claims: tests restate constants, read
              unexported fields, struct shapes and SDK option structs, or
              only construct; 29 white-box *_internal_test files bypass
              the exported API. A suite that can't fail can't guard the
              API it documents.
Behaviors     1. Every test in the nine repos lives in its package's
                 external test package and drives only the exported API.
                 No *_internal_test file remains. The one white-box file
                 is export_test, and only to export a hook that injects a
                 clock or probe the API can't reach deterministically;
                 the tests that use the hook stay black-box.
              2. check fails on any white-box test file other than
                 export_test: testpackage's skip regexp narrows to
                 export_test in all nine repos, reversing the checks
                 Decision that allowed the _internal_test suffix.
              3. No test lies. A whole-suite review finds no test that is
                 tautological (restates a constant or the implementation),
                 structure-sensitive (reflects on struct shape or tags,
                 reads unexported or SDK fields, asserts concrete types,
                 counts implementation calls, hard-codes inventory sizes),
                 or unable to fail (only constructs, or mocks away the
                 failure that matters).
              4. A lying test whose behavior the package's doc.go or
                 README states is rewritten at the exported seam; it is
                 deleted only when another test already proves that
                 behavior. No documented behavior loses its last test.
              5. The only guard test kept is blobfs's sha256 pin on
                 released migrations, now read through the exported
                 migration set. Startup stage order (template,
                 go-web-service) is proved through observable startup
                 order, and blobfs entity NULL handling through a scan on
                 sqlate's scripted driver, or each is deleted where
                 another test already covers it.
              6. Each repo's integration and acceptance suites are judged
                 with the same rules and pass under Docker through the
                 repo's own integration or acceptance task. check stays
                 unit-only.
              7. go-web-service runs the collector image 0.162.0, and its
                 currency exits 0.
Test seams    `mise run check` per repo (testpackage enforces the
              black-box rule; the unit suites prove the API), and each
              repo's integration / acceptance task under Docker
Slices        Workspace order. In each slice the standards-reviewer
              profile runs over that scope's whole suite, every test file
              and not the branch diff, with Behaviors 1-6 as its rules. It
              rewrites or deletes, commits, and the slice is done when the
              scope has no white-box file beyond allowed export_test
              hooks, check passes, and the scope's integration or
              acceptance task passes where it has one. The end-of-task
              diff review then runs as usual.
              1 go-web-service collector upgrade (compose image 0.162.0;
                currency and check pass)
              2 go-core   3 sqlate   4 go-database   5 go-web-sdk
              6 go-observability   7 go-storage (Azurite acceptance)
              8 blobfs (acceptance)   9 go-web-sdk-template (integration)
              Slices 2-9 each narrow that repo's testpackage regexp.
              10 go-web-service: the service
              11 go-web-service: its integration suite (run isolated)
              12 go-web-service: tools/slab, then narrow testpackage for
                 the whole repo
Out of scope  Coverage of any kind (no threshold, no before/after
              figures); mutation testing; production-code changes beyond
              a clock or probe hook an export_test reaches (any other
              need escalates); the architecture repo beyond this record
              (tests-and-docs changes go to architecture-diet);
              STANDARDS.md, CLAUDE.md and the marathon.toml currency key
              (standards); releases and tags; integration tests in check
              or CI changes.
Door          two-way: every change is a revertable test or lint-config
              file on a branch, plus one compose image tag; no tags
              pushed.
```



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

## Pending edits

- architecture-diet: restate `dependencies.md`'s line as "bottom-up, no provider in a base, kept light", held by discipline; drop `service-tiers.md`'s claim that a lint step checks the boundary; update `context/standards-audit.md`'s split-check suggestion and drop its claim that go-web-service has no `.golangci*` file (it has `.golangci.yml`, enabling testpackage, with no depguard rule).
- standards: each STANDARDS.md points the reviewer to the hierarchy, provider, and doc.go discipline.
- v1.deployment: Dockerfile base images join each repository's currency.
- architecture-diet: `standards/go-elemental/principles/release-and-ci.md` still prescribes a per-module CI matrix and omits check, currency, and upgrade; restate it from the practice checks established.
- architecture-diet: `tests-and-docs.md` states the black-box rule as practiced, with the export_test clock/probe allowance; check enforces it through testpackage.
- architecture-diet: `tests-and-docs.md` states the integration tier as practiced (sqlate/blobfs postgres suites, go-storage Azurite acceptance beside the application tier); drop "not re-proven in CI" or restate where each runs.
- architecture-diet: `tests-and-docs.md` drops "provider tests assert construction", states that a provider test may drive a loopback port-0 test server (go-database's postgres provider tests complete a startup exchange with an in-test pgproto3 server), and links to marathon's standards-reviewer definition of a lying test.
- architecture-diet: absorb the `release-and-ci` task into the existing `release-and-ci.md` restatement (release prep via PR; a failed-release tag may be re-pushed at the same version; a released tag is never re-cut).
- coordinator · roadmap: remove `[goals.quality.tasks.release-and-ci]` from the roadmap.
- coordinator · roadmap: add backlog goal `slab-json-partial-color`: go-web-service tools/slab `style.JSON` returns partly colored output when the input breaks after the first token, though its comment says any tokenizer error returns the input unchanged; fix the code or the comment.
