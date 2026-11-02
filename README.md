# slides

A Reveal.js + Jekyll template.

A minimalistic, locally-launchable Jekyll project for authoring
[reveal.js](https://revealjs.com/) presentations. Each deck is a file in the
`_presentations/` collection, configured via YAML front matter; the shared
`reveal` layout wires up the full Reveal.js plugin stack.

## What this is

A starter template, not a finished site. It strips the personal content out of
[`alorozco53.github.io`](https://github.com/alorozco53/alorozco53.github.io)
and keeps only the engine: layouts, includes, the reveal.js distribution, the
config skeleton, and three structural starter templates (`template-horizontal`,
`template-vertical`, `template-grid`) alongside a small set of migrated
example decks.

## Features

- Jekyll collection-backed presentations with a single shared `reveal` layout
- Full reveal.js plugin set bundled (no CDN required):
  `chalkboard`, `menu`, `math`, `highlight`, `zoom`, `notes`, `markdown`,
  `search`, `multiplex`, `title-footer`, `print-pdf`
- Per-deck front-matter config for theme, transitions, plugins, navigation chrome
- Theme switching across all eleven Reveal.js themes (black, white, league,
  sky, beige, simple, serif, blood, night, moon, solarized)
- Drawing/whiteboard tools (chalkboard plugin) keyboard-bound by default
- A non-deck Jekyll homepage you can edit freely

## Quickstart

```bash
git clone <your-fork-or-this-repo>.git
cd slides
make install        # bundle install
make run            # bundle exec jekyll serve ...
```

Then open <http://localhost:4000>.

## Authoring a new presentation

Drop a new file into `_presentations/` — the file becomes a slide deck served
at `/presentations/<filename>/`.

### Start from a structural template

Three starter templates ship under `_presentations/`. Each wires up the full
chrome (back-to-home, menu, chalkboard, math, code highlighting) and shows
off a different deck shape — pick the closest match and copy the file:

| Template | Shape | Use it for |
|----------|-------|------------|
| [`template-horizontal.html`](_presentations/template-horizontal.html) | flat row, no nesting | short, sequential, single-topic talks |
| [`template-vertical.html`](_presentations/template-vertical.html) | stacked subslides within one topic | optional drilldowns / Q&A backup |
| [`template-grid.html`](_presentations/template-grid.html) | chapters × subslides, color-scaled section titles | the canonical paper-talk arc (Intro → Method → Evidence → Conclusions) |

Each template is self-contained — the per-deck `<style>` block at the bottom
is fully customizable per deck. The homepage ([`index.html`](index.html))
links to all three with live previews. For raw authoring patterns, the two
examples below are still the minimal references.

### HTML-section style

```html
---
title: My Deck
reveal:
  theme: black
  transition: fade
  menu: true
---

<section>
  <h1>Hello</h1>
  <p>First slide.</p>
</section>

<section>
  <h2>Second slide</h2>
  <ul>
    <li class="fragment">Bullet one</li>
    <li class="fragment">Bullet two</li>
  </ul>
</section>
```

See `_presentations/standardization-prototype.html` for a richer example
with nested sections, code highlighting, and chalkboard configuration.

### Markdown style

```html
---
title: My Markdown Deck
reveal:
  theme: night
  markdown: true
---

<section data-markdown>
  <textarea data-template>
## Slide One

- Markdown bullets work
- So does **emphasis** and `code`
  </textarea>
</section>
```

See `_presentations/example-markdown-deck.html`.

### Per-deck config

All keys under `reveal:` in front matter are passed through to
`Reveal.initialize()`. Common ones:

| key                  | effect                                      |
|----------------------|---------------------------------------------|
| `theme`              | one of the eleven Reveal.js themes          |
| `transition`         | `slide`, `fade`, `convex`, `concave`, ...   |
| `menu`               | enable the slide-menu plugin                |
| `chalkboard`         | enable draw-on-slides + whiteboard          |
| `math`               | enable MathJax rendering                    |
| `highlight`          | enable code syntax highlighting             |
| `home_link` + `home_url` | top-left "Back to Home" navigation chrome |
| `links`              | extra top-right quick links                 |

The defaults live in `_config.yml` under
`defaults > scope.type: presentations`.

## Speaker notes, numbering, and PDF export

Speaker view (`S`) supports inline notes and optional sidecar notes. Put
sidecar notes in `_presentations/<deck>.notes.md` with this format:

```markdown
---
published: false
---

## Title
Opening speaker notes, including **Markdown** and math.
```

Each `##` title matches a slide's `data-menu-title`. The local Jekyll plugin
`_plugins/inject_notes.rb` inserts notes during the build; matching sidecar
entries replace inline notes on that slide. Unmatched keys produce a warning.
Leave `##` headings for slide delimiters; use `###` for headings inside notes.
When only notes change during local serving, touch the deck to force a rebuild.

Enable URL-matching, zero-indexed slide numbers with:

```yaml
reveal:
  zero_indexed_slide_number: true
```

The slide number is `h.v` for vertical stacks, `h` for horizontal slides, and
`v` for a single-column deck. The shared script loads automatically.

Use the menu's **Export** tab to open `?print-pdf`, then the browser's print
dialog to save a PDF. The shared head selects the print stylesheet and hides
presentation chrome. Set `reveal.print_button: false` to omit the Export tab.

Build with plain Jekyll (`bundle exec jekyll build`), keeping local plugins
enabled. GitHub Pages safe builds do not execute the custom notes injector;
deploy the generated static output when these notes are needed.

Run `bundle exec ruby scripts/verify_presentation_engine.rb` to check note
injection/override, numbering, speaker/math plugins, and print/export wiring
against a temporary two-slide fixture.

MathJax and Google Fonts are already integrated. Their engines/styles may be
downloaded externally; local Reveal plugins and several font families are
bundled. Private deployments should select only the requested deck and assets.

## Repo layout

```
_config.yml             # main Jekyll config (generic)
_config.dev.yml         # local-dev overlay (url: localhost:4000)
_layouts/
  base.html             # shared <html>/<body> skeleton
  default.html          # generic page layout
  page.html             # standard Jekyll page
  minimal.html          # chrome-less layout
  reveal.html           # the presentation layout
_includes/
  head.html, header.html, footer.html, footer-scripts.html, nav.html, ...
  presentation/         # head/navbar/scripts specific to reveal decks
_presentations/
  template-horizontal.html        # starter: flat row of slides
  template-vertical.html          # starter: stacked subslides within one topic
  template-grid.html              # starter: chapters × subslides (paper-talk)
  standardization-prototype.html  # HTML-section authoring example
  example-markdown-deck.html      # Markdown authoring example
  # ... plus migrated example decks listed in catalog.md
css/                    # main.css, reveal.css, theme/ (all 11 themes)
js/                     # reveal.js + jquery + bootstrap
lib/                    # reveal.js helpers (head.min.js, classList.js, fonts)
plugin/                 # reveal.js plugins: chalkboard, menu, math, ...
_data/                  # SocialNetworks.yml, ui-text.yml
index.html              # repo landing page
Gemfile, Gemfile.lock
Makefile                # install / run / clean / update
```

## License

MIT. See [LICENSE](LICENSE).

The Jekyll layouts in this repo are derived from
[Beautiful Jekyll](https://deanattali.com/beautiful-jekyll/) by Dean Attali,
also MIT-licensed.
