# Promote on fit

A pattern proven in the reference service promotes outward, into the SDKs, the infrastructure
libraries, the template, and the standard, so the generated baseline never drifts from the
reference. The note landed from the coordinator for a page here.

The criterion is fit, not a count of consumers. A piece promotes when it is expressed in the
lower layer's terms and depends on nothing above it. A second consumer confirms the shape but
does not license the promotion. go-core's `processtest.Forwarder`, the integration
harness's network relay, is the example: it sits in go-core because it fits there, with no second
consumer.

Because the layers evolve together, a library change and the service change that proves it
release as one coordinated snapshot.

The page's likely home is `principles/`, beside the independent-releases principle.
