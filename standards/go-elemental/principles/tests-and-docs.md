---
key: tests-and-docs
name: Tests and documentation
type: principle
level: go-elemental
---

# Tests and documentation

Testing runs in two tiers. The unit tier runs on every pull request, for every layer, and
touches no service, network, or disk. The integration tier runs the composed service black-box
through its API against the service's own compose stack, on merge. Each tier has its own
contract, stated below.

## The unit tier: co-located, black-box, hermetic

Unit tests are `{file}_test.go` files co-located with the source they cover, in an external
test package (`package <pkg>_test`). They exercise only the public API; private infrastructure
is covered transitively through the public entry points that use it.

Unit tests are hermetic: `go test -race ./...` passes with no service running, and needing no
external service is the tier's contract rather than a limit under review. Fakes, scripted
drivers, and port-0 listeners are how a package proves its behavior here. The tier is also the
home of every cheap gate that needs no container: a per-module build with the workspace file
disabled, so a broken version pin fails CI, and the SQL conventions lint. Each tier of
repository reaches hermeticity its own way:

- **Infrastructure libraries** substitute the engine below the standard interface with a
  scripted `database/sql` driver that can prepare statements, so prepare-based verification
  is provable on this tier. Provider tests assert construction, which performs no I/O.
- **Application SDKs** exercise handlers through recorded requests with no listener; a test
  that must listen binds port 0 and reads the assigned port back, never a fixed port.
- **Templates and reference architectures** run their race suite against the composed baseline
  the same way, with the readiness probes as the observable surface, and prove their
  integration harness on this tier against loopback stand-ins.

A test helper stays in its test package until more than one test package needs it; then it is
hoisted into a module-private `internal/<pkg>test` package, following the standard library's
`httptest`/`fstest` naming. Nothing in it is API.

## The integration tier: the composed service, black-box, on merge

The integration suite is marked by one build tag, `//go:build integration`, and lives in the
application's root-level `integration` package. It runs the composed service as the binary
against the service's own compose stack, the same compose definition a developer runs, booted
as an isolated compose project on its own port and torn down with its volume when the run
ends. The suite exercises the service only through its API and drives it only through
production seams: configuration by environment variable, the API and the admin mount for state
control, the network for fault injection, and signals and the exit code for lifecycle. Nothing
in the runtime exists for the tests' sake.

The tier runs on push to `main` and on manual dispatch, below the per-pull-request rate by
design, and a release is cut only from a `main` whose integration run has passed
([releases and CI](release-and-ci.md)).

Integration testing is an application-layer concern. Layers below the application stay on the
unit tier, because the composed application is where a library's claim meets a real engine: a
black-box test that creates a duplicate record and receives a 409 proves the authored SQL, the
driver, the error classification, the matcher, and the handler at once. Two consequences
follow. A library claim the service's API can express moves up into the service's suite. A
library claim only a real engine proves and the API cannot express, such as a dirty migration
history, is a session-time acceptance proof: demonstrated against a real engine in the session
that lands the claim, recorded in that session's notes, and not re-proven in CI.

A capability enters the integration suite only when its API surface is complete enough to
exercise it end to end. A later backing service joins the compose stack when its service layer
is testable through the API, not when its library lands.

## Integration toolkits ship beside the libraries

A library whose infrastructure an integration suite exercises ships its integration toolkit
beside it, the way a scripted driver ships beside a SQL library for the unit tier. The core
SDK's [`process/processtest`](../go-core/process.md) package runs a program as the binary and
drives it through the seams a terminal or an orchestrator uses. The web SDK's
[`webtest`](../go-web-sdk/webtest.md) package is the client a black-box suite drives a running
service through. The template ships the wiring engine-free, its
[`integration` package](../go-web-sdk-template/integration.md), task, and CI job, and a
generated service adds its compose stack.

## doc.go and godoc

Production source is written without doc comments; the agent writes godoc. Each package has
exactly one `doc.go` containing only the package comment, and that comment is the authoritative
description of the package's API.
