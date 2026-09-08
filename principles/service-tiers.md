---
key: service-tiers
name: Service tiers
type: principle
level: architecture
---

# Service tiers

An infrastructure library presents its technology — a database engine, an identity provider, an
object store, a message broker — as a service in two tiers, and a consumer targets one tier or
the other per use. A consumer is either exercising a standard feature, usable across any
provider of the technology, or a feature native to one implementation. There is no third case
to reason about.

- **Standard** — the interface every provider of the technology implements, and it is exactly
  the technology's common standard: SQL in ISO/IEC 9075; authentication in OAuth 2.0, OpenID
  Connect, and JWT; HTTP in RFC 9110 and RFC 9457; observability in OpenTelemetry. The standard
  tier stays compliant with that standard and does not grow past it. Where no formal standard
  exists, as in object storage and messaging, the organization establishes the common interface
  for that technology itself: derived from the operations the target APIs share, kept minimal,
  and validated against more than one provider before it is called standard. The tier is never
  the a-priori intersection of providers, which neuters it, nor the union of their features,
  which bloats it.
- **Native** — the provider's own API, reached through the handle the library exposes: the pool
  behind a database wrapper, an identity provider's administrative API, an object store's vendor
  operations. A feature that several providers happen to share but no standard defines is still
  native. Native use is first-class; it is how an application reaches the features that make a
  technology worth choosing, and the standard tier never asks an application to forgo them.

## Native use is wrapped beneath standard use

What keeps native use from spreading a provider across a codebase is the [resolution
rule](resolution.md) applied to provider imports. An application's
[composition root](composition-root.md) is the package
where it assembles its dependencies: it constructs the providers, the pools, the loggers, and
the configuration, and passes them to the packages that use them. A package that
interfaces at the native tier wraps that use and presents the standard tier upward: the domain
package that owns engine-specific SQL exposes plain queries and commands to its callers. Only
the composition root, the binaries, and packages that declare native use import a provider;
every other package works against the standard tier and stays provider-free.

The boundary is declared in the application's design documentation and checked: an
import-boundary lint step allows the provider import only in the declared packages. The check
belongs to the consumer; a library never names the consumers it protects. The consequence is
that a port to another provider is a list of packages: the composition root, the migrations, and
the domain packages that declare native use. Nothing has to be discovered.

## Three classes of technology, by swap cost

How much work moving between providers of a technology requires is declared per service, never
assumed. Each service's documentation classes its technology and states, in one sentence, what
changes when the provider does.

- **Interchangeable** — moving providers is a configuration change. The application exercises
  the service only through the standard tier. Secrets, logging sinks, the common operations of
  object storage, token verification, caches, model chat APIs.
- **Interchangeable with review** — moving providers is a configuration change plus a review of
  the behavior the common API leaves unstated: message ordering and delivery guarantees in a
  queue, consistency in an object store, what a token's claims contain across identity
  providers.
- **Schema-bound** — moving providers is a port. The application owns provider-specific
  artifacts the library cannot abstract: a SQL schema and the domain SQL that reads and writes
  it, a search engine's mappings and query language, a graph or workflow engine's model.

Full interchangeability is a limit the classes approach; no technology fully reaches it, and the
declaration is what makes the difference legible.

## Providers are adapters behind one interface

The library reaches every provider of a technology through one interface per capability, and a
provider is an adapter beneath that interface. The interface is defined where it is consumed,
in the library, and a new provider is a new adapter, never a change to the interface. Adapters
isolate vendor churn: a provider's SDK changes without the interface changing.

The organization's SQL support is the reference pattern. The
[dialect interface](../standards/go-elemental/sql/dialect.md) is defined in the SQL templating
library and implemented by each engine sub-module. The
[database infrastructure library](../standards/go-elemental/go-database/index.md) constructs
the pool over the provider and supplies no dialect of its own.

Where tooling projects a model for downstream consumers, it emits one machine-readable
projection of that model, and a consumer reads the projection rather than the authoring
format. The authoring format then changes without breaking its consumers.

## Providers and platforms

A provider is one implementation of one target API, and the boundary between self-hosted and
managed lies inside it: a Postgres provider covers a local container and a managed PostgreSQL
service alike, through its connection string; an S3 provider covers minio and S3. Moving between
providers of the same technology costs what the service's class says it costs.

"Platform-agnostic" in this organization refers to the deployment platform: one artifact
deployable on any cloud with any CI system, differing only in parameters. It does not claim that
an application runs on any provider of a technology by configuration; that claim is made per
service, by class.
