---
key: standards
name: Standards
type: index
---

# Standards

A standard implements the [Elemental Architecture](../architecture.md) on a specific
technology: it declares its goals, the dependency line defining which dependencies its modules
may declare, and the principles its modules share. A module belongs to exactly one standard,
and a standard's principles enhance the architecture's without loosening them. Standards run
parallel by technology; a standard that re-expresses another on a different technology declares
that lineage in its definition. A standard whose posture does not satisfy the architecture's
principles is not a standard of this blueprint — it implements some other architecture, and is
referenced from the catalog rather than documented here.

- [Go Elemental](go-elemental/README.md) — the Go implementation of the Elemental Architecture:
  a complete reference architecture on the Go standard library.
