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
  positional inputs. A leading `context.Context` does not count toward the four, since it is the
  call's scope rather than an input. Optional inputs go in one options struct, passed last, whose
  zero value selects every default, so a caller who wants the defaults passes the zero value.
- **No functional options.** An API does not take variadic option functions, such as
  `WithTimeout(d)`. Its optional inputs are fields of its options struct.
- **A struct with a method beyond that.** An API that needs more than four required inputs, or
  that runs a configured thing, is an exported struct with a method. The caller names each input
  as a field and calls the method on the value, such as a `Service{...}.Run(ctx)`.
- **A missing required field panics by name.** When a required field is nil, the method panics
  with a message that starts with the package name and names the field, such as
  `web: Service.Run requires a Graph`. A nil field is a wiring
  mistake in the caller's code, so the method reports it before it starts anything.

## The exception: a graph's Define-line options

A graph's Define-line options are variadic, and the rule names them as its one exception. They
declare a node's place on the line that defines it: one orders the node after other nodes, and
another adds it to a group.

## Scope

The rule covers every new API, the API of a test-support package, such as a graph's test
support, included. An existing test-support helper that breaks the rule converts at its package's
next breaking release.
