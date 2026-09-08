---
key: integration
name: The integration tier
type: page
repo: go-web-sdk-template
---

# The integration tier

A generated service starts with the standard's integration tier in place
([tests and documentation](../principles/tests-and-docs.md)): the root-level `integration`
package, its task, and its CI job. The template ships the tier engine-free. A generated
service that adds a backing service runs the suite against its compose stack as an isolated
project, the pattern the [reference service](../go-web-service/index.md) proves.

## What the package holds

The package has two halves. The harness is untagged, so the unit tier type-checks it on every
pull request. It is the toolkit the SDKs ship beside what it exercises: go-core's
[`processtest`](../go-core/process.md) package builds `cmd/server` once per run, runs it as a
subprocess configured by the service's environment variables on a reserved port, and reads
its exit code; go-web-sdk's [`webtest`](../go-web-sdk/webtest.md) package drives it through its
HTTP surface and observes its liveness probe. A start runs the service and returns once it is
live, and a stop interrupts it and returns the exit code. Nothing in the runtime exists for
the tests' sake.

The suite files carry the `integration` build tag and run the built service. The template's
suite asserts the baseline: the boot, both probes, and the drain. As the layers fill in, each
capability adds its cases beside them.

## How the tier runs

The `integration` task runs the tagged suite with the race detector and no test cache, so
every run builds and exercises the current binary. The CI workflow runs the same task as a
second job on push to `main` and on manual dispatch, below the per-pull-request rate by
design, and a release is cut only from a `main` whose integration run has passed
([releases and CI](../principles/release-and-ci.md)).

The generated service's README lists the tasks, each wrapping a plain command so the
repository works without the task runner:

| Task | What it runs |
|------|--------------|
| `vet` | The compile check and vet, the integration suite included. |
| `serve` | The service locally. |
| `test` | The unit tier. |
| `integration` | The integration tier against the built service. |
| `fmt`, `tidy`, `lint` | The formatter, the module reconciliation, and the linter with the integration suite included. |
