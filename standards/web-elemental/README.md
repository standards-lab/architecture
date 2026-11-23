---
key: web-elemental
name: Web Elemental
type: standard
architecture: elemental-architecture
status: draft
---

# Web Elemental

The web implementation of the [Elemental Architecture](../../architecture.md), a draft beside
[Go Elemental](../go-elemental/README.md). Web Elemental implements the architecture on the
browser platform, and its goal is to demonstrate what the platform provides by itself: native
modules, sheets, and elements, with the smallest deliberate dependency surface.

## The dependency line

Every Web Elemental package follows one dependency line, enhancing the [minimal, deliberate
dependency footprint](../../principles/minimal-footprint.md):

- **The platform first.** A package takes what the browser provides before any library.
- **Lit, the one runtime dependency.** Beyond the platform, the runtime dependency a package
  declares is Lit.
- **marked, for Markdown alone.** The one exception: marked is allowed for rendering Markdown,
  and only a Markdown module imports it.

## Principles

The conventions every Web Elemental repository shares, enhancing the
[architecture principles](../../principles/README.md). A member repository may enhance one
further, stating the enhancement beside its link to the principle.

- [Packages and releases](principles/packages-and-releases.md) states that each repository is
  one package, how a release is tagged, cut, and published, where the build output lives, how a
  layer resolves another, and how pins are kept.

## Member repositories

By tier: the layers of the stack bottom-up, with the tooling beside them and the template on
top. Each repository documents itself: its README states its place in the standard and the
principles it enhances, and its package documentation states its API.

| Tier | Repository | Purpose |
|------|------------|---------|
| Tooling | [web-tooling](https://github.com/standards-lab/web-tooling) | The browser-test and screenshot tooling, taken as a devDependency. |
| Foundation | [web-foundation](https://github.com/standards-lab/web-foundation) | The bottom layer: native sheets, profiles, keys, and preferences. |
| Icons | [web-icons](https://github.com/standards-lab/web-icons) | The icon modules and a Vite plugin that fills icon markers. |
| Components | [web-components](https://github.com/standards-lab/web-components) | The Lit components, each with a shadow root. |
| SDK | [web-app-sdk](https://github.com/standards-lab/web-app-sdk) | The application SDK beside the components: router, API client, and events. |
| Templates | [webappgen](https://github.com/standards-lab/webappgen) | A Go CLI that writes a client project on the layers. |
