---
key: tool-call-reliability
name: Tool-call reliability
type: principle
level: architecture
---

# Tool-call reliability

A served model drifts from the shape a consumer needs: a tool call the server can't parse, or a
text answer where a tool call was due. Reliability comes from layers, each owning one failure,
never from a patch to one model. The server constrains a shape the consumer needs every time, the
row that serves the model runs it as its publisher trained it, and the client keeps the
conversation the model reasons over whole.

| Layer | Owns | Rule |
|---|---|---|
| Server | The shape of the output | A shape the consumer needs every time is constrained, not prompted. |
| Row | The model's format and settings | The row runs the model's official chat template at its card's settings. |
| Client | The history the model sees | On a turn that called tools, the client sends the model's reasoning back. |

## The server constrains a shape needed every time

A request that must end in a tool call says so: `tool_choice` `required`, or a named tool. A
request that must end in structured data sends `response_format` with a strict JSON schema. A
server that constrains decoding compiles either into a grammar the model samples within, so the
output parses. The guarantee is a call that parses, not a good one: the model still chooses the
call and its arguments.

`auto` stays unconstrained. Under it the model may answer in text, or emit a call the server's
parser rejects, so a consumer that needs a call every time never relies on `auto` and a prompt
asking for one. A turn where a text answer is valid stays `auto`; a constraint belongs only where
every reply must take the shape.

A deployment that refuses `required` is a gap the client declares, so a request that needs it is
refused before it is sent rather than quietly answered under `auto`. go-ai at `c851963` is an
example, in
[`NoToolChoiceRequired`](https://github.com/standards-lab/go-ai/blob/c8519634000a2d3f278d1abca91078be674862dd/docs/concepts.md#profiles)
and
[`ToolChoiceRequired`](https://github.com/standards-lab/go-ai/blob/c8519634000a2d3f278d1abca91078be674862dd/protocol/tool.go#L39-L40).
For a server's side of the options, see vLLM's
[tool calling](https://docs.vllm.ai/en/latest/features/tool_calling/).

## The row runs the official template at the card's settings

A row serves the model's official chat template, at the sampling and reasoning settings its card
states. [Reading a model card](model-cards.md) says what the template and those settings are,
where a card states them, and why a model runs at them.

A template override is for a template that is broken, one that renders a conversation the card's
format doesn't describe. It is never for a shape the model sometimes strays from: that shape is
the server's to constrain, as above, and a template workaround is a deviation from the card
([Why a model runs at its card's values](model-cards.md#why-a-model-runs-at-its-cards-values)).
[ai-hosting's class-profile schema at `bd34b83`](https://github.com/standards-lab/ai-hosting/blob/bd34b83629d4935d1b1a7c2a633bd162ccbbc0dd/classes/README.md#a-rows-keys)
is an example.

## The client sends reasoning back on turns that called tools

A reasoning model reasons through its tool calls: on a turn that called tools, its reasoning
stays in its prompt until it gives a final answer. The server keeps nothing between requests and
sees only the history the client sends, so the client sends the model's reasoning back with each
call it made, as the wire format carries it, such as `reasoning_content` or a reasoning item.
Dropped, the model continues from a prompt unlike the one it was trained to continue, and its
next call is the one that drifts. What else the history carries back is the card's multi-turn
rule ([Reading a model card](model-cards.md#what-each-value-means)).

[go-ai's stateless conversations at `c851963`](https://github.com/standards-lab/go-ai/blob/c8519634000a2d3f278d1abca91078be674862dd/docs/concepts.md#stateless-conversations)
are an example.
