---
key: go-web-sdk-template
name: go-web-sdk-template
type: module
tier: template
repo: https://github.com/standards-lab/go-web-sdk-template
standard: go-elemental
---

# go-web-sdk-template

The web service template of [Go Elemental](../index.md): scaffolds an initial Go Elemental web
service application, and the first code expression of the
[Elemental Architecture](../../../architecture.md)'s application
layout. A generated service starts as a minimal runnable web service on go-core and go-web-sdk
at pinned releases: layered configuration, the cold and hot start lifecycle, the liveness and
readiness probes, the composition root as one file per layer of the architecture, and the
integration tier that runs the composed service as the binary.

New services are generated with `gonew`, which copies the template module and rewrites its
path; the copy is a running service from the first build:

```sh
gonew github.com/standards-lab/go-web-sdk-template/template@latest example.com/newsvc
```

The template is engine-free: no data engine is declared and no provider is imported. A
generated service selects its providers in its own composition root, and the database
infrastructure a service adds, the pool, the admin service, and the authored SQL layout, is a
reference-architecture pattern the [reference service](../go-web-service/index.md) documents
rather than template scaffolding. The template stays minimal and stable; development
concentrates in the SDKs, and a generated service keeps pace by updating its go-core and
go-web-sdk pins.

## Design

- [The baseline](baseline.md) states the architecture the template scaffolds: the entrypoint,
  the composition root as one file per layer, and the configuration root.
- [The elements in the template](elements.md) states how the baseline realizes the Elemental
  Architecture's elements.
- [The integration tier](integration.md) states the harness and the suite a generated service
  starts with.
- [The template subtree](template-subtree.md) states why the module is rooted at `template/`,
  and the duties the layout creates.
