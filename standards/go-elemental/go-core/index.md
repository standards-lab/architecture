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

- **config** — layered configuration: a base file, environment overlays, and secrets, resolved
  through a merge/finalize contract each subsystem's configuration implements. See
  [Configuration](config.md).
- **lifecycle** — the process lifecycle for long-running programs: staged services with
  ordered startup, reverse-stage drain, and named readiness checks; bracketing hooks and
  monitors for process-level callbacks; a readiness signal that tracks the process through
  startup and drain; and timeout-bounded graceful shutdown. The conventions it fixes for every
  application are documented in the standard's
  [lifecycle and context ownership](../principles/lifecycle-and-context.md) principle.
- **logging** — the `*slog.Logger` a process writes through, built from a configuration that
  takes part in the layered load. See [Logging](logging.md).
- **process** — the pre-infrastructure main sequence of a binary: the signal-derived root
  context, failure and usage reporting before a logger exists, and the exit-code convention
  the reporters return. The conventions it fixes are documented in the standard's
  [lifecycle and context ownership](../principles/lifecycle-and-context.md) principle.

The code and each package's `doc.go` are authoritative for the API; these pages document the
design.
