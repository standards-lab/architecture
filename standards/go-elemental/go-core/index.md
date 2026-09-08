---
key: go-core
name: go-core
type: module
tier: core-sdk
repo: https://github.com/standards-lab/go-core
standard: go-elemental
---

# go-core

The Core SDK of [Go Elemental](../index.md): the common primitives useful across all Go Elemental
application types, and the first place the standard becomes code. A package is admitted only
when every application type in the standard uses it. Functionality specific to a single
application type belongs in that type's application SDK, and functionality specific to an
external technology belongs in that technology's infrastructure library; both depend on go-core.

The repository is a single Go module, `github.com/standards-lab/go-core`, with each primitive a
package inside it. It enhances the standard's [dependency line](../principles/dependencies.md)
to the standard library alone.

## Packages

The README lists the packages, and each package's `doc.go` states its API. Their places in the
standard:

- The `config` package loads layered configuration: a base file, environment overlays, and
  secrets, resolved through a merge and finalize contract each subsystem's configuration
  implements. See [configuration](config.md).
- The `lifecycle` package is the process lifecycle for long-running programs: services
  started in stages with a barrier between them, readiness tracked as each service's status
  changes, and a reverse-stage drain within a timeout. The conventions it fixes for every
  application are the standard's
  [lifecycle and context ownership](../principles/lifecycle-and-context.md) principle.
- The `logging` package constructs the `*slog.Logger` a process writes through, from a
  configuration that takes part in the layered load. See [logging](logging.md).
- The `process` package holds the parts of a binary's main sequence that run before the
  program's own infrastructure exists, and its `processtest` package is the integration
  toolkit that runs a program as the binary. See [the process sequence and its toolkit](process.md).
