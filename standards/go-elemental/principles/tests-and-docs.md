---
key: tests-and-docs
name: Tests and documentation
type: principle
level: go-elemental
---

# Tests and documentation

Testing runs in two tiers. The unit tier is what each repository's check runs: hermetic,
black-box, on every pull request. The integration and acceptance suites run a real process or
a real engine, each behind its own task or CI job. A test proves a behavior only if it can
fail: a green test that is tautological, structure-sensitive, or unable to fail lies, and review
rewrites or deletes it.

## The unit tier: black-box and hermetic

Every test lives in an external test package (`package <pkg>_test`), co-located with the
source it covers, and drives only the package's exported API; unexported code is covered
through the exported entry points that use it. The one white-box file allowed is
`export_test.go`, and it exists only to export a hook for what the API cannot reach: a clock or a
probe it cannot reach deterministically. A fixture node needs no hook: a test defines it on the
graph the App publishes. The tests that use a hook stay in the external package. A repository's
golangci-lint configuration enables the `testpackage` linter with its skip regexp narrowed to
`export_test\.go`, so the check enforces the rule.

The tier is hermetic: `go test -race ./...` passes with no service running. A package proves
its behavior with fakes, scripted drivers, and loopback listeners:

- **SQL libraries** run over a scripted `database/sql` driver that supports prepare and fails
  where a real driver would, so prepare-based verification is provable on this tier.
- **Providers** may drive a loopback test server on port 0, asserting what the provider sends
  over the wire.
- **Handlers** run through recorded requests with no listener; a test that must listen binds
  port 0 and reads the assigned port back, never a fixed port.

A test that reads data outside its module's zip, such as a nested system tool's committed goldens
read in place, skips when that tree is absent, as it is in the module zip, naming what is missing.
A file missing within the repository, where the tree is present, fails the test.
[docproc's `internal/tooltest`](https://github.com/standards-lab/docproc/tree/v0.4.2/internal/tooltest)
is an example.

A shared test helper stays in its test package until more than one test package needs it; then
it is hoisted into a `<pkg>test` package, following the standard library's `httptest` and `fstest`
naming, under `internal/` unless another module's tests consume it.

A composition root's test fixtures live in an internal `<app>test` package even when only one test
package consumes them. The fixtures are built over the composition the root publishes, its graph
and its nodes: a fixture replaces a node's constructor with a substitute or observes which nodes a
build reaches, and wraps no production constructor. The composition root's tests then need no
`export_test.go` beyond the clock or probe hook above.

## Integration and acceptance suites, and where each runs

Each suite that needs a real process or engine sits behind a build tag, such as
`-tags integration`, or an environment variable that names the service it runs against, so the
unit tier never reaches it. Each suite has a mise task that starts the containers it needs, runs
it, and stops them whatever the result; a suite runs either in a CI job of its own or on a
developer's machine, and the repository's README says which. An integration tier that runs the
built program sits in a root-level `integration` package and runs the program as a subprocess,
black-box: a service through its API, and a CLI through its arguments, its two output streams,
and its exit code. The check vets, fixes, and lints a tagged suite with its tag, so it always
compiles, but runs only the unit tier.

An integration tier over system tools nested in the repository builds the tools from the same
checkout and puts them first on PATH, so no installed release stands in for them.
[docproc's `test:integration`](https://github.com/standards-lab/docproc/blob/v0.4.2/docs/development.md)
is an example.

A PostgreSQL suite makes a throwaway database for each test through
[sqlate's `postgres/pgtest`](https://github.com/standards-lab/sqlate/tree/postgres/v0.8.0/postgres/pgtest).
[go-messaging's `postgres`](https://github.com/standards-lab/go-messaging/tree/postgres/v0.4.0/postgres),
[blobfs's `postgres`](https://github.com/standards-lab/blobfs/tree/postgres/v0.6.1/postgres),
and [docproc's `postgres`](https://github.com/standards-lab/docproc/tree/postgres/v0.1.1/postgres)
suites are examples.

The integration tier drives a service only through production surfaces: configuration by
environment variable, the API and the admin mount for state, the network for faults, and
signals and the exit code for lifecycle. It observes through the same surfaces, plus the log
for what only the log records and the backing services the configuration points at, such as an
object store read beneath the API or an OTLP receiver the test runs. It drives a CLI through
configuration by environment variable and its arguments, and observes it through its standard
output, its standard error, and its exit code. Nothing in the runtime exists for the tests'
sake.

### Integration toolkits and harness rules

A library whose infrastructure an integration suite exercises ships the toolkit beside it: a
runner that launches a program as its binary and drives it through its output, its signals, and
its exit code, and a client a suite drives a running service through. A suite builds its harness
on them, and the harnesses follow these rules:

- **A stall is a finding, never a sleep.** Every wait is a poll on an observable condition,
  bounded by the toolkit's failsafe or a multiple of it, and a wait that runs out fails the test.
- **Readiness through the API.** A harness waits for a process to be ready by polling its
  probe, never by reading its output.
- **One connection per client.** The client holds one connection per host, so the service's
  graceful shutdown never waits on an idle second connection.
- **Interrupt before kill.** Stopping a process sends an interrupt and kills only a process
  that has not exited within the bound.
- **Faults at the network.** A forwarder relays a backing service over loopback, and an outage
  case severs it, so a fault is indistinguishable from an outage.
- **Output captured on failure.** Every process's output is captured and included in each
  failure the harness reports.
- **The harness proves itself on the unit tier.** A toolkit carries unit tests against a
  stand-in program or an `httptest` server, and a harness kept untagged is type-checked by the
  unit tier on every pull request.

Toolkit mechanics, such as dropping the race runtime's exit sleep from a launched binary, stay
with the toolkit's own code and documentation.

## Performance work removes waste, with no time target

Performance work sets no time target. It removes a slowdown's waste stage by stage, so each stage
does its work and nothing more, keeps the output byte-identical, and states the reasoning in the
repository's docs.
[docproc's mail performance page](https://github.com/standards-lab/docproc/blob/v0.4.2/docs/mail-performance.md)
is an example.

## doc.go and godoc

Each API package has one `doc.go` holding only the package comment, and that comment is the
authoritative description of the package's API. It inventories every exported identifier with
a one-clause role and points to the symbols for the rest; each contract is stated once, on its
symbol's own doc comment. Exported identifiers carry doc comments. A short method that exists
only to satisfy a standard library interface, `Error() string` on a type whose comment already
says what the error means or `String() string` on a `Stringer`, needs no comment of its own.
[Five kinds of comment](../../../principles/comments.md) sets which other comments the source may
carry. Whether an inventory is complete, and whether each exported identifier carries its doc
comment, is the reviewer's judgement; no check enforces either.
