---
layout: page
title: Examples
subtitle: Two presentations that ship with the template
---

The template includes two example decks under `_presentations/`. Each one
demonstrates a different authoring style and a different mix of reveal.js
plugins, so you can pick the closest starting point and copy it.

## HTML-Section Example

<a class="btn btn-primary btn-sm" href="{{ '/presentations/standardization-prototype/' | relative_url }}">
  Open deck →
</a>
&nbsp;
<a class="btn btn-default btn-sm" href="https://github.com/alorozco53/slides/blob/main/_presentations/standardization-prototype.html" target="_blank" rel="noopener noreferrer">
  View source
</a>

The canonical example. Each slide is an `<section>` block — verbose but
gives you the most control over per-slide attributes (backgrounds,
transitions, fragments, speaker notes). Wired up with:

- **Chalkboard** plugin for live annotation
- **Menu** plugin for slide navigation
- **Highlight.js** for code blocks
- **Math** (MathJax) for equations
- A reusable navigation chrome — "Back to home" + custom quick links
  configured in front matter

Use this when your deck has heavy visual structure, embedded media, or
needs per-slide fine-tuning.

## Markdown Example

<a class="btn btn-primary btn-sm" href="{{ '/presentations/example-markdown-deck/' | relative_url }}">
  Open deck →
</a>
&nbsp;
<a class="btn btn-default btn-sm" href="https://github.com/alorozco53/slides/blob/main/_presentations/example-markdown-deck.html" target="_blank" rel="noopener noreferrer">
  View source
</a>

A minimal counterpart that authors slides as `<section data-markdown>`
blocks. The same engine handles it — the difference is purely how you
write content. Use this when you want to focus on prose and let
reveal.js's markdown parser handle layout.

## Authoring your own

Both examples share the same `layout: reveal` front matter. To start a
new deck, copy either file into `_presentations/`, rename it, edit the
front matter, and replace the body. See the [README]({{ '/' | relative_url }})
for the full plugin/feature list.
