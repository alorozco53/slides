# Agent Onboarding Guide — `slides`

Welcome, fellow agent! This repository is a **public** Reveal.js + Jekyll
starter template — a stripped-down sibling of
[`alorozco53.github.io`](https://github.com/alorozco53/alorozco53.github.io)
that keeps only the presentation engine plus a small set of example and
migrated decks.

## Start Here

- Read [`README.md`](README.md) for the full feature list, quickstart, and how
  to author a new deck (HTML-section and Markdown styles, per-deck config).
- Open [`index.html`](index.html) for the homepage tour of the three
  structural starter templates (horizontal / vertical / grid).
- Open [`catalog.md`](catalog.md) for the list of decks migrated out of the
  parent website.
- Skim [`index.html`](index.html) to see how the landing page links
  everything together.

## Key Components

- Configuration: [`_config.yml`](_config.yml) (primary) and
  [`_config.dev.yml`](_config.dev.yml) (local-dev overlay, sets
  `url: http://localhost:4001`).
- Templates: [`_layouts/`](_layouts/) — `base.html`, `default.html`,
  `page.html`, `minimal.html`, and the all-important
  [`_layouts/reveal.html`](_layouts/reveal.html) used by every deck.
- Reusable partials: [`_includes/`](_includes/), including
  [`_includes/presentation/`](_includes/presentation/) which carries the
  navbar (back-to-home, menu, theme switcher, chalkboard toggle), head, and
  scripts for reveal decks.
- Decks: [`_presentations/`](_presentations/) (the Jekyll collection;
  permalink `/presentations/:path/`) and [`talks/`](talks/) +
  [`archive/`](archive/) (migrated decks that already had their own paths).
- Reveal.js distribution: [`js/`](js/), [`lib/`](lib/), and
  [`plugin/`](plugin/) — full plugin stack bundled, no CDN required.
- Styles: [`css/`](css/) (global) and [`css/theme/`](css/theme/) (all 11
  reveal themes). Per-deck CSS lives at `css/decks/<slug>.css`.

## Local Development

```bash
make install   # bundle install
make run       # serves on http://localhost:4001
make clean     # rm -rf _site/
make update    # rebuild Gemfile.lock + bundle update
```

The server picks up most changes via hot-reload; restart after editing
`_config.yml`.

## Authoring Conventions

- **Always use `layout: reveal`** in deck front matter — the layout wires up
  the navbar (back-to-home, menu, chalkboard, theme switcher), the full plugin
  stack, and the per-deck `reveal:` config passthrough to
  `Reveal.initialize()`.
- **Reference assets with site-root-relative paths** (`/css/...`, `/js/...`,
  `/img/...`, `/talks/material/...`). Never use `../` relatives — they break
  the moment a file is moved between depth levels.
- Per-deck `reveal:` keys (theme, transition, menu, chalkboard, math,
  highlight, home_link, home_url, links) override the defaults in
  `_config.yml > defaults > scope.type: presentations`.
- Decks at `_presentations/X.html` render at `/presentations/X/` (Jekyll
  folder-indexes any HTML file with front matter). Decks at
  `talks/X.html` similarly render at `/talks/X/`, NOT `/talks/X.html`.
- **Start from a structural template** when authoring a new deck. Three live
  in `_presentations/`, each with the full chrome wired up and a different
  deck shape:
  - [`template-horizontal.html`](_presentations/template-horizontal.html) —
    flat row, no nesting. Short single-topic talks.
  - [`template-vertical.html`](_presentations/template-vertical.html) —
    stacked subslides within one topic (`data-auto-animate`,
    `data-menu-title`, drilldown asides).
  - [`template-grid.html`](_presentations/template-grid.html) — chapters ×
    subslides with color-scaled section titles (teal → blue → gold →
    purple). The workhorse paper-talk shape.
- For raw authoring style examples (HTML-section vs Markdown), see
  [`_presentations/standardization-prototype.html`](_presentations/standardization-prototype.html)
  and
  [`_presentations/example-markdown-deck.html`](_presentations/example-markdown-deck.html).

## Branching

This repo currently uses a flat `main` branch — **no dash-depth hierarchy**
(unlike the parent website). Land work directly on `main` or in a topic
branch off `main`.

## Working Effectively

- Prefer editing existing layouts/includes to spinning up new ones.
- New per-deck CSS goes in [`css/decks/<slug>.css`](css/decks/) and is loaded
  via the `extra_css` front-matter key.
- Store new media in [`img/`](img/) and reference with absolute paths.
- If you add a deck to [`_presentations/`](_presentations/), also link it from
  [`catalog.md`](catalog.md) or [`index.html`](index.html) so it is
  discoverable from the homepage.

## Before You Ship

- Preview locally — open every deck you touched in a browser, click through
  the back-to-home button and the menu plugin, and verify the chrome renders.
- `bundle exec jekyll build` success is necessary but **not sufficient**: a
  build can succeed while every asset 404s. `curl` your deck's URL and grep
  for `reveal-chrome` / `/css/reveal.css` / `/js/reveal.js` to confirm.
- **Never push to the remote.** Hand off with a suggested
  `git push origin main` command for the maintainer to run.

Need more context? Check the [Reveal.js docs](https://revealjs.com/) or the
upstream [Beautiful Jekyll](https://github.com/daattali/beautiful-jekyll)
theme this template derives from.
