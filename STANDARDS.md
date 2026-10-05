# architecture standards

The judgement calls the standards-reviewer applies to the architecture layer, beyond what `scripts/check.sh` enforces.

- Each claim on a page names the merged code or the check that expresses it.
- A page never restates a repository's implementation; it links the repository instead.
- `architecture/README.md` "What belongs here": what a page may hold and when it arrives; a principle that only one repository's merged code expresses stays a note in that repository.
- `architecture/README.md` "Conventions": held by review; the check enforces only that each relative link resolves.
- `architecture/principles/context-architecture.md`: each page is the one home of its detail; a page that repeats another page links it instead.
