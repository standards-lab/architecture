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
runs that tool through an adapter, and neither reimplements it nor binds to its library. Which
tools qualify is the [minimal, deliberate dependency footprint](../../../principles/minimal-footprint.md)'s
call, made as it is for any dependency.

## The adapter is the boundary

The system's own interface says what it needs, and each adapter says how one tool provides it, so
the tool's effect on the design stops at the adapter and a tool can be swapped for another.
[herald](https://github.com/JaimeStill/herald)'s `internal/format`, at commit 6fc22b3, is the
first case: its `Handler` interface says what extraction needs, its `Registry` keys handlers by
media type, and the PDF and image handlers each run ImageMagick to produce their pages.
[spike-ai-pipeline-processing](https://github.com/JaimeStill/spike-ai-pipeline-processing)'s
`document` package, at v0.9.0, is the second: its `Renderer` interface says what page rendering
needs, and `Ghostscript` provides it over a gs tool.

## A tool is a process

A tool runs as a process of its own, never linked into the system. It runs directly, or inside a
container whose image is pinned by digest, and an adapter is written once against either.
spike-ai-pipeline-processing's `tool` package, at v0.9.0, holds both runners behind one `Tool`:
`NewExec` runs a program directly, and `NewContainer` runs it inside an `Image` whose reference it
refuses without a digest, every run locked down to no network, no capabilities, and the caller's
user.

## Startup fails, not the first request

An adapter finds its tool and checks its version when it is built, so a missing or outdated tool
fails the system at startup, and it runs the tool under the caller's context, so cancelling the
caller stops the tool. In spike-ai-pipeline-processing's `tool` package, each runner's constructor
finds the program and refuses one older than its declared minimum, and `Tool.Run` runs under the
caller's context, stopping the program when that context ends. herald's `Render` runs ImageMagick
under the caller's context.

## A tool's license binds the image that ships it

Running a tool links nothing, so the tool's license binds the image that ships it, not the code
that runs it. spike-ai-pipeline-processing's `document` package runs Ghostscript, which is
AGPL-licensed, as a separate program and never links it.
