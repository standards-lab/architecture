---
key: model-cards
name: Reading a model card
type: principle
level: architecture
---

# Reading a model card

A model card is the publisher's statement of how a model was trained and evaluated: its prompt
format, its sampling, its reasoning controls, its context. A served checkpoint runs at the card's
values, because those are the settings its quality and its tool calls were measured at. The card
is the source of every value it states. A conversion's copy of those values and an engine's
defaults are not: a value the card doesn't state is chosen on purpose, not inherited.

## What each value means

| Value | What it controls | Where a card states it |
|---|---|---|
| Temperature | Scales the logits before sampling: below 1 sharpens the distribution toward the likeliest token, above 1 flattens it. 0 is greedy. | A recommended-sampling section; the checkpoint's `generation_config.json` often repeats it. |
| Top-p | Nucleus truncation: keeps the smallest set of tokens whose probabilities sum to p. 1.0 keeps all. | The same section. |
| Top-k | Keeps the k likeliest tokens. | The same section; often absent. |
| Min-p | Drops tokens below min-p times the likeliest token's probability. 0 turns it off. | Rarely stated, though engines may default it on. |
| Reasoning control | How long a reasoning model thinks before answering: a level the chat template writes into the system message, or thinking switched on or off by a token the template places. | A reasoning-levels or thinking-mode section; the template sets the default. |
| Chat template | The template that renders messages, tool definitions, and tool results into the token sequence the model was trained on, and the format its output is parsed from. | Shipped with the weights, as `chat_template.jinja` or in the tokenizer's configuration; the card names the format. |
| Context ceiling | The longest sequence the model was trained to attend over: a ceiling, not a target. A row's context is set at or below it. | The card's architecture table, or `max_position_embeddings` in `config.json`. Where the card states a smaller window than the configuration, the card's window binds. |

A reader meets more on the same card:

- **A recommended system prompt.** Some cards prescribe one or a required preamble; others only
  show an example, which is not a requirement. A control written into the system prompt, such as
  a reasoning level or a thinking token, belongs to the template, not to the client's prompt
  text.
- **Stop and special tokens.** The tokens that end a turn or mark a tool call, listed as end
  tokens in `generation_config.json` and named in the card's format guide. An engine that parses
  the model's native format handles them; a hand-built prompt has to.
- **Multi-turn rules.** What the history carries back, such as earlier thinking dropped except on
  tool-call turns. The history is the client's to keep, as
  [Tool-call reliability](tool-call-reliability.md#the-client-sends-reasoning-back-on-turns-that-called-tools)
  says for the reasoning of a turn that called tools.
- **Prompt forms.** A request whose content the model was trained to see in a set form: an
  embedding model's task prefixes for a query and for a document, a transcription instruction,
  or the order of image or audio inputs against the text. Omitting a prefix usually still works
  but costs precision. The client adds these; the server can't. An embedding model doesn't
  sample, so it has no sampling values.

## Why a model runs at its card's values

The card's values are the ones the publisher trained and evaluated at. Its benchmark numbers and
its tool-call behavior hold only there. A client built against a model is built against that
configuration, and a deviation is a new configuration nobody has measured.

- **A conversion is a copy.** A converted or quantized checkpoint can carry the card's sampling,
  template, and context, or not, per conversion. The card stays the source; where a copy differs
  from it, the card's value is the one that runs.
- **An engine's defaults are a deviation.** A model whose checkpoint carries no sampling runs at
  whatever the engine defaults to unless its row states the card's values. A truncation the card
  doesn't name is turned off rather than left to the engine.
- **A workaround in the template is a deviation too.** A patched template or a forced reasoning
  level is a per-model workaround carried across every build and conversion. A shape the model
  sometimes misses is constrained per request instead, as
  [Tool-call reliability](tool-call-reliability.md#the-server-constrains-a-shape-needed-every-time)
  says, and the model keeps its card's template and settings.

## A checkpoint derived from another publisher's model

A checkpoint published by the model's own publisher is described by its own card and carries
its own generation config. A checkpoint another publisher derived from that model, by
quantization or fine-tuning, is described by the base model's card. Only such a derived
checkpoint takes its sampling from the base card, and only when its own `generation_config.json`
lacks the base card's values; when the derived checkpoint's generation config carries them, it
runs on that, as any checkpoint does.
[ai-hosting's class-profile schema at `bd34b83`](https://github.com/standards-lab/ai-hosting/blob/bd34b83629d4935d1b1a7c2a633bd162ccbbc0dd/classes/README.md#sampling)
is an example.

## A card's evals rank candidates

A card's evals are the publisher's measurements, on the publisher's hardware, at the publisher's
precision. They only rank which candidates to measure first; they never admit or refuse one.
Any quantization of a model is eligible, though the card measures none but its own. A candidate
is judged by measurement on the host that would serve it, against the model it would replace:
accuracy and capability first, then throughput.
