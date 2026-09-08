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
and `sort` parameters, and every remaining parameter as a filter. The reserved parameter names
are private to the parse, and one call yields both halves, so a handler cannot parse the
paging parameters and forget to strip them from the filters. The result is flat: page, size,
sort, and the filter list as direct members, with no sub-struct to name a partial concept.

## The filter grammar

A filter is a field name with an optional operator in brackets. `status=active` names no
operator, and `created[gte]=2026-01-01` names one. A repeated parameter carries several values
under one filter, so `code=a&code=b` is one filter with two values. The parse returns the
filters as an ordered list, sorted by field and then by operator, so a consumer composes a
deterministic predicate from the same request every time. An operator on a reserved name, or
a malformed key, is rejected as a `QueryError`. The operators pass through as text: the SDK
enumerates none, and whether an operator is supported is the data layer's check.

## The contract carries no storage detail

`Query`, `Sort`, and `Filter` are the SDK's own types, and the SDK imports no data library.
Sort and filter names and the operators are lexical, text from the wire. Whether a name is a
readable field or an operator is supported is the data layer's check: in the standard's
authored SQL, the [statement's projection base](../sql/statements.md) declares the readable
fields, and the SQL library rejects an unknown field or operator with its typed directives
error before any SQL is composed. The translation from the parsed query to the data layer's
directives is the application's, by the downward-dependency rule. Nothing an engine does
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

A malformed or out-of-bounds parameter returns a `QueryError` carrying the parameter, the
offending input, and the reason. The [error-to-problem mapping](problems.md) writes it as a
400 with the error text as the detail, since a rejected query parameter is request-shaped and
client-actionable by definition.

## The envelope

`Page[T]` is the whole success body of a paginated read: `items`, `page`, `size`, `total`.
`items` is the conventional member name for a page's rows (the Kubernetes and Google style;
`data` and `value` are the JSON:API and OData counterparts) and leaves `data` unclaimed should
a uniform envelope ever be wanted. `NewPage` assembles it from the query the read honored
and normalizes nil items to an empty slice, so an empty page marshals `"items": []` rather
than `null` — a client iterating the member never branches on its absence. The envelope is
written with the SDK's plain JSON writer; it needs no writer of its own.
