---
key: system-tools
name: System tools
type: principle
level: go-elemental
---

# System tools

[Sourcing](dependencies.md#sourcing) gives a capability two homes: written in-house, or a sourced
library pinned in `go.mod`. A Go Elemental system has a third choice: where a mature system tool
already does specialized work, such as rendering a PDF's pages or converting an image, the system
runs that tool through an adapter, and neither reimplements it nor binds to its library. The
[minimal, deliberate dependency footprint](../../../principles/minimal-footprint.md) decides which
tools qualify, as it does for any dependency.

## The adapter is the boundary

The system's own interface says what it needs, and each adapter says how one tool provides it, so
the tool's effect on the design stops at the adapter and a tool can be swapped for another.
[herald's `internal/format`](https://github.com/JaimeStill/herald/tree/6fc22b3/internal/format)
is an example.

## A tool is a process

A tool runs as a process of its own, never linked into the system. It runs directly, or inside a
container whose image is pinned by digest, and an adapter is written once against either.
[spike-ai-pipeline-processing's `tool` package](https://github.com/JaimeStill/spike-ai-pipeline-processing/tree/v0.9.0/tool)
is an example.

## An adapter checks its tool at startup and runs it under the caller's context

An adapter finds its tool and checks its version when it is built, so a missing or outdated tool
fails the system at startup, and it runs the tool under the caller's context, so cancelling the
caller stops the tool.

## A run's memory bound is set before exec

A bound on a tool's memory is in place before the tool's program executes, never applied to a
process that has already started, since a runtime reserves its address space and sizes its stacks
at startup, under the bound in place then. docproc's exec
runner, which sets the bound through util-linux's `prlimit` before the tool's program runs
([`tool/exec.go`](https://github.com/standards-lab/docproc/blob/v0.4.2/tool/exec.go)), is an
example.

## A message's alternative parts are one content

The parts of a `multipart/alternative` message are each an alternative version of the same
information (RFC 2046 §5.1.4), so a tool that converts a message to Markdown makes it from one of
them and appends nothing from the others.
[docproc-mail](https://github.com/standards-lab/docproc/blob/tools/mail/v0.1.4/tools/mail/README.md#output)
is an example.

## A tool's license stays with the tool

Running a tool links nothing into the system, so the tool's license stays with the tool and does
not pass to the code that runs it.
