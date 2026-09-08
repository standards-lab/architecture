---
key: reads
name: Paginated reads
type: page
repo: go-web-sdk
---

# Paginated reads

The design of the HTTP read contract: a request's query string parsed into paging and filters,
and the success envelope a paginated handler returns. The code and `doc.go` are authoritative
for the API; this page records the reasoning.

## One parse, both halves

`ParseQuery` parses a read request's query string in full into a `Query`: the `page`, `size`,
and `sort` parameters, and every remaining parameter as the filter set. The reserved parameter
names are private to the parse, and one call yields both halves, so a handler cannot parse the
paging parameters and forget to strip them from the filters — the split cannot be done wrong or
half-done. The result is flat: page, size, sort, and filters as direct members, with no
sub-struct to name a partial concept.

## The contract carries no storage detail

`Query` and `Sort` are the SDK's own types — deliberately parallel to go-database's read
vocabulary without importing it. Sort and filter names are lexical: text from the wire, and
whether one names a readable field is the data layer's check (go-database answers with its
typed unknown-field error). Nothing an engine does — offset arithmetic, dialect paging forms —
reaches the HTTP side, so either half of the read path can change without moving the other.

## The sort grammar

`sort=name,-code`: comma-separated field names, `-` prefixing a descending key, every
occurrence of the parameter honored in order — `?sort=name&sort=-code` and `?sort=name,-code`
parse the same. An empty parameter value reads as omitted; an empty key inside a non-empty
value (`sort=name,`, a bare `-`) is malformed input and rejected.

## Policy belongs to the consumer

The parse takes a `Limits` value — the default size when a request omits one, and the largest
size a request may ask for. The SDK ships no numbers: a default page size is service policy,
and the SDK claiming one would put policy where no consumer can answer for it. The expected
wiring is a service-owned configuration section that applies the service's defaults at
finalize and hands `Limits` to each handler constructor at the composition root — per-resource
variation is just different values at different construction sites. Invalid limits panic with
the fix named: they are a wiring mistake, the same class as an unfinalized `Config` at server
construction, not request input.

## Rejections are typed

A malformed or out-of-bounds parameter returns a `QueryError` — the parameter, the offending
input, and the reason. It is the one error class the SDK maps itself: the
[error-to-problem mapping](problems.md) writes it as a 400 with the error text as the detail,
since a rejected query parameter is request-shaped and client-actionable by definition.

## The envelope

`Page[T]` is the whole success body of a paginated read: `items`, `page`, `size`, `total`.
`items` is the conventional member name for a page's rows (the Kubernetes and Google style;
`data` and `value` are the JSON:API and OData counterparts) and leaves `data` unclaimed should
a uniform envelope ever be wanted. `NewPage` assembles it from the query the read honored
and normalizes nil items to an empty slice, so an empty page marshals `"items": []` rather
than `null` — a client iterating the member never branches on its absence. The envelope is
written with the SDK's plain JSON writer; it needs no writer of its own.
