---
layout: page
title: Catalog
subtitle: Albert Orozco's public reveal.js decks
---

A curated library of presentations Albert has authored or co-authored
over the years. Three are wired through the template's Jekyll
collection (uniform layout, themable, plugin-rich). Two more under
`/talks/` are raw reveal.js HTML — kept active because they may be
re-presented. The remaining three under `/archive/YEAR/track/`
preserve older decks in their original markup.

For the bundled how-to-author examples, see
[Examples]({{ '/examples' | relative_url }}).

## Unified decks

These live in `_presentations/` as Jekyll collection entries. Each is
configured entirely through YAML front matter and rendered with the
shared `reveal` layout.

### The Hanabi Challenge: A New Frontier for AI Research

<a class="btn btn-primary btn-sm" href="{{ '/presentations/hanabi-challenge/' | relative_url }}">
  Open deck →
</a>
&nbsp;
<a class="btn btn-default btn-sm" href="https://github.com/alorozco53/slides/blob/main/_presentations/hanabi-challenge.html" target="_blank" rel="noopener noreferrer">
  View source
</a>

A reading-group presentation on Bard, Foerster, Chandar et al.'s Hanabi
paper, covering cooperative multi-agent RL, imperfect information, and
the open-source environment introduced by the authors.

### Implementando ojos a tu chatbot

<a class="btn btn-primary btn-sm" href="{{ '/presentations/eyes-on-bot/' | relative_url }}">
  Open deck →
</a>
&nbsp;
<a class="btn btn-default btn-sm" href="https://github.com/alorozco53/slides/blob/main/_presentations/eyes-on-bot.html" target="_blank" rel="noopener noreferrer">
  View source
</a>

A divulgative talk (in Spanish) given at the Bots LATAM meetup. Walks
through neural networks, the perceptron, convolutional networks, and a
human-vision analogy.

### GraftLLM: Knowledge Fusion via Modular SkillPacks

<a class="btn btn-primary btn-sm" href="{{ '/presentations/graftllm-knowledge-grafting/' | relative_url }}">
  Open deck →
</a>
&nbsp;
<a class="btn btn-default btn-sm" href="https://github.com/alorozco53/slides/blob/main/_presentations/graftllm-knowledge-grafting.html" target="_blank" rel="noopener noreferrer">
  View source
</a>

A walkthrough of Du et al., 2026 (ICLR) — modular cross-capability
transfer across heterogeneous LLMs via compressed SkillPacks.

## Talks (raw reveal.js)

Active decks kept in their original reveal.js form under
`/talks/`. Image and script paths are absolute, so they resolve
cleanly from any URL.

- [Representation Learning on Graphs with Jumping Knowledge Networks]({{ '/talks/jumping_networks.html' | relative_url }})
  — class project for COMP 766: Graph Representation Learning.
- [Adversarial Opinion Dynamics]({{ '/talks/adversarial_opinion_dynamics.html' | relative_url }})
  — minimax formulations and mixed-graph problems for opinion-dynamics models.

## Archive

Legacy decks preserved in their original form under
`/archive/YEAR/track/`. Paths have been normalized so the decks
still render from the slides site.

- 2017 / meetup: [Implementando ojos a tu chatbot (original)]({{ '/archive/2017/meetup/eyes_on_bot.html' | relative_url }})
  — raw 2017 deck used at the Bots LATAM meetup; the unified version
  above is its refreshed Jekyll counterpart.
- 2019 / research: [Linearized Belief Propagation]({{ '/archive/2019/research/lin-sp-bp.html' | relative_url }})
  — semantic walkthrough of Gatterbauer et al.
- 2021 / research: [On the Challenges of Predicting Microscopic Dynamics of Online Conversations]({{ '/archive/2021/research/micro-dynamics/microdynamics.html' | relative_url }})
  — nbconvert-generated reveal deck from a 2021 research talk.
