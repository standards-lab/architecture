---
key: requests
name: Request helpers
type: page
repo: go-web-sdk
---

# Request helpers

The SDK supplies two request parses every web service otherwise hand-writes: the version
precondition a guarded command takes, and the strict decode of a JSON body. Each is syntax and
shape only. Whether a version matches a row and whether a body's values are valid are the
data layer's and the command's own checks.

## The version precondition

`IfMatch` reads a request's version precondition from the `If-Match` header, as RFC 9110
§13.1.1 defines it: exactly one strong entity-tag whose opaque value is an integer version,
written `If-Match: "3"`. A missing header, a weak tag, the `*` form, a list, or a non-integer
tag is a `PreconditionError`, which the [error mapping](problems.md) answers with a 428 when
the header is missing and a 400 otherwise. A version that does not match the row is the data
layer's finding, and the consumer maps it to a 412.

The parse pairs with the optimistic-concurrency guard of the standard's
[authored SQL](../sql/statements.md): the version the client read travels in the header, the
guard runs the command against it, and a mismatch is the guard's typed error.

## The strict body decode

`DecodeJSON` reads a request body as exactly one JSON value. The read is bounded at the
caller's limit, unknown fields are rejected so a misspelled field cannot silently change a
command's meaning, and nothing may follow the first value. A body that fails any of these, or
is empty, is a `BodyError`, answered with a 413 when the body is over its limit and a 400
otherwise. The values' validity is the command's own check, run after the decode.
