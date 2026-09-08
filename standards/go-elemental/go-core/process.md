---
key: process
name: The process sequence and its toolkit
type: page
repo: go-core
---

# The process sequence and its toolkit

The `process` package holds the parts of a binary's main sequence that run before the
program's own infrastructure exists: the signal-derived root context, the reporting of a
failure or a usage error when no logger exists yet, and the exit-code convention the reporters
return. A composition root composes its run function from these parts, so the convention
cannot drift between a program's binaries. The package fixes the conventions the standard's
[lifecycle and context ownership](../principles/lifecycle-and-context.md) principle states:
the entrypoint traps the signal and derives the context, and the composition root receives
the context and never creates one.

## What the toolkit runs

The `process/processtest` package is the integration toolkit for a program built on the
`process` package. It runs the program as the binary and drives it only through the seams a
terminal or an orchestrator uses, so nothing in the runtime exists for the tests' sake:

- A suite's test main builds one main package once per run, with the race detector.
- A launch runs that binary as a subprocess with the environment the test composes and
  captures its output.
- An await waits on an observable condition and fails with the captured output if the process
  exits first or the failsafe elapses.
- A stop interrupts the process with the signal the process package answers and returns the
  exit code.
- A forwarder is a loopback relay between the process and one of its backing services, the
  seam a test severs and restores to inject an outage.

The toolkit is hermetic. It needs no service beyond the binary it builds, so a consumer's
harness type-checks and proves itself on the unit tier against loopback stand-ins, and only
the suite that needs a running stack carries the integration build tag. It is the process half
of the standard's integration toolkit ([tests and documentation](../principles/tests-and-docs.md));
the web SDK's [`webtest`](../go-web-sdk/webtest.md) package is the HTTP half.

## Which rules the toolkit is built to

A harness over the toolkit follows ten rules, each of which removes a class of stall from an
integration suite:

1. A stall is a finding, never a sleep. Every wait is a bounded poll on an observable
   condition, and an unexplained second is traced to its cause and removed.
2. A race-instrumented process drops the race runtime's exit sleep, so races are reported
   during the run and exit is prompt.
3. One client per process and one connection per client, mirroring the runtime's
   single-instance shape. A transport that can dial a second connection leaves the server's
   graceful shutdown a request-less connection to wait on.
4. Cleanup drains before it kills. The harness interrupts first and kills only a process that
   does not exit, so backing services see every connection close.
5. Readiness is observed through the API, on a port the harness chose. The log is diagnostic
   output and is never parsed.
6. State control goes through the operator's surface, and a case starts from a state it made.
7. Fault injection is at the network. The relay severs and restores deterministically, and the
   process cannot tell the injection from an outage.
8. Diagnostics ride with the failure. Every process's output is captured and attached to the
   failing assertion.
9. The harness proves itself hermetically on the unit tier, against loopback stand-ins.
10. Timing is a first-class diagnostic. Per-call timing is what finds each cause above.
