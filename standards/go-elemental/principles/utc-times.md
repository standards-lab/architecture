---
key: utc-times
name: Times in UTC
type: principle
level: go-elemental
---

# Times in UTC

Every `time.Time` a Go Elemental library returns is in `time.UTC`, whatever `time.Local` or the
database session's `TimeZone` is. JSON encoding, cursors, logs, and `==` then give the same result
on every host.

## PostgreSQL columns store instants

A PostgreSQL column that holds a point in time is `timestamp with time zone`, which stores an
instant.

## The read path converts to UTC

A driver may decode a `timestamp with time zone` into `time.Local`, whatever the session's
`TimeZone` setting, so the provider and the scan layer both convert on read: the provider sets
the driver to decode into `time.UTC` on every connection it opens, and the scan layer converts
every `time.Time` it scans to `time.UTC`, whatever driver produced it.

A library that parses a time from another source, such as an HTTP date or an event header,
converts it before returning it.

## Log record times are UTC

The core SDK's logger writes each record's own time in `time.UTC`. A time the caller logs as an
attribute keeps the Location the caller gave it.

## Tests prove UTC under a non-UTC zone

A test of a returned time runs with `time.Local` set to a zone other than UTC. A package's tests
set it to Europe/London in the package's `TestMain`, in `main_test.go`, which imports
`time/tzdata` so the zone loads without the host's zoneinfo. They use an instant in London's
summer, since London's winter offset is zero and an unconverted time prints as a UTC one does,
and they compare whole values with `==`, which compares the Location as well as the instant.

A test whose times are stamped at run time cannot choose the season, so it uses a zone whose
offset is never zero, Asia/Kolkata; an integration tier that runs the service process with `TZ`
set is such a test.

## Callers convert where a time leaves their code

The standard has no clock abstraction. Code that takes a time from `time.Now` or another source
and hands it out, in a response body, a cursor, or a returned value, converts it with `.UTC()` at
that point.
