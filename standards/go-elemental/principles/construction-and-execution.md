---
key: construction-and-execution
name: Construction and execution
type: principle
level: go-elemental
---

# Construction and execution

A Go Elemental function or constructor takes at most four required positional inputs, plus at
most one trailing options struct whose zero value is the default. An API that needs more inputs,
or that runs something its caller configures, is an exported struct whose fields hold the inputs
and whose method does the work.

## The rule

- **Four required inputs, then one options struct.** A function takes at most four required
  positional inputs. Optional inputs go in one options struct, passed last, whose zero value
  selects every default, so a caller who wants the defaults passes the zero value.
- **No functional options.** An API does not take variadic option functions, such as
  `WithTimeout(d)`. Its optional inputs are fields of its options struct.
- **A struct with a method beyond that.** An API that needs more than four required inputs, or
  that runs a configured thing, is an exported struct with a method. The caller names each input
  as a field and calls the method on the value. go-web-sdk's
  [`web.Service`](https://github.com/standards-lab/go-web-sdk/blob/main/service.go) runs a web
  service as `web.Service{Graph, LifecycleConfig, Logger, Server, Roots}.Run(ctx, stderr)`, and
  go-cli-sdk's [`cli.Program`](https://github.com/standards-lab/go-cli-sdk/blob/main/run.go) runs
  a command tree as `cli.Program{Root, Graph, LifecycleConfig}.Run(ctx, args, streams)`.
- **A missing required field panics by name.** When a required field is nil, the method panics
  with a message that starts with the package name and names the field, such as
  `web: Service.Run requires a Graph` or `cli: Program.Root is nil`. A nil field is a wiring
  mistake in the caller's code, so the method reports it before it starts anything.

## The exception: Define's options

go-core's [`graph.After` and `graph.In`](https://github.com/standards-lab/go-core/blob/main/graph/option.go)
are variadic options to `Define`, `Value`, and `Fresh`, and the rule names them as its one
exception. They declare a node's place on its Define line: `graph.After` orders the node after
other nodes, and `graph.In` adds it to a group.

## Scope

The rule covers every new API, the API of a test-support package, such as go-core's `graphtest`,
included. An existing test-support helper that breaks the rule converts at its package's next
breaking release.
