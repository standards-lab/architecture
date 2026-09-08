---
key: lifecycle-and-context
name: Lifecycle and context ownership
type: principle
level: go-elemental
---

# Lifecycle and context ownership

Every Go Elemental application follows one process lifecycle, hosted by go-core's `lifecycle`
package, and one context-ownership convention. The lifecycle realizes the Elemental
Architecture's infrastructure-service contract in Go: staged startup, reverse-stage drain, and
named readiness reported to the probes.

## The composition root owns the signal context

The composition root traps signals and derives the root context; it passes that context to the
lifecycle coordinator's blocking run call, the one call that owns the sequence. go-core's
`process` package holds this pre-infrastructure sequence — the signal-derived root context,
failure and usage reporting before a logger exists, and the exit-code convention the reporters
return — so it cannot drift between a program's binaries. A subsystem
with a place in the process's dependency order is declared as a staged service — its name, its
stage, its startup, shutdown, and readiness check in one declaration — while process-level
callbacks register as hooks and monitors. Nothing executes before the run begins, and the
coordinator installs no signal handlers of its own.

Not every composition-root layer registers a staged service. A layer with no resource and
nothing that runs, such as the Elemental Architecture's Domain Service composition, declares
none and imports no part of this package: there is nothing in it to stage.

## The wiring rule

A defect the composition root wires panics at construction, with the fix named: an
unfinalized configuration, a missing pool, a malformed route prefix, a duplicate pattern, a
registration after the router is sealed or after the coordinator has run. No runtime
condition produces such a defect and no caller can recover from it sensibly, and the
composition root is written once and runs at boot, so a loud failure there beats a silent one
in production. A defect in configuration content, a reserved connection option or an invalid
value, returns an error from the constructor that reads it, because configuration is input.

## Cold start, hot start, drain

Cold start constructs every object from configuration with no I/O, so a construction mistake
fails before anything runs. Hot start brings the services up stage by stage — services within
a stage concurrently, the request edge's root stage last, so nothing serves before the
infrastructure beneath it is up. A startup failure drains what did start, and readiness never
reports a partially started process. The drain is coordinator-driven and reverses the stages:
the run context is cancelled, the root stage drains first, and every stage and shutdown hook
runs against a fresh timeout-bounded context, so cleanup is not pre-cancelled and needs no
cancellation guard of its own.

A subsystem declares runtime failure through a monitored channel: the first non-nil error ends
the run.

## Readiness reflects the live state of the process

The coordinator is ready once startup completes, and not ready again the moment draining
begins, so a readiness probe reports a draining process as unavailable before its teardown
runs. A subsystem exposes its own readiness through its service's named check, and that state
is live: a subsystem that degrades fails the probe under its own name until it restores, and a
process that begins draining stays not ready until it exits. Leaf components take a plain
`context.Context`, keeping them usable without the coordinator.
