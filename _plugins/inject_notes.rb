# _plugins/inject_notes.rb
#
# Sidecar speaker-notes injector.
#
# For each presentation `<deck>.html` in the `_presentations` collection,
# this plugin looks for `<deck>.notes.md` next to it. The notes file is a
# Markdown document with one H2 per slide, where the H2 text matches the
# slide's `data-menu-title`. Matching is case- and dash-insensitive and
# ignores HTML entities, trailing punctuation, and whitespace. The body
# under each H2 is rendered as Markdown and injected as
# `<aside class="notes">...</aside>` immediately before the slide's
# closing `</section>`.
#
# Rules:
#   - sidecar entry overrides any inline <aside class="notes"> on that slide
#   - slides without a sidecar entry keep any existing inline aside
#   - sidecar keys with no matching slide produce a build-time warning
#
# Authoring example (`thesis-proposal.notes.md`):
#
#     ---
#     deck: thesis-proposal
#     ---
#
#     ## Title
#     Open with the framing...
#
#     ## Outline
#     Walk the six columns quickly.

require 'cgi'
require 'kramdown'

module InjectNotes
  module_function

  # Named HTML entities that appear in slide titles in this deck.
  # CGI.unescapeHTML only handles the base 4 (&amp; &lt; &gt; &quot;) so
  # we extend it with the named ones we actually use.
  EXTRA_ENTITIES = {
    '&mdash;'  => '—',
    '&ndash;'  => '–',
    '&nbsp;'   => ' ',
    '&hellip;' => '…',
    '&compfn;' => '∘',
    '&middot;' => '·',
    '&rarr;'   => '→',
    '&larr;'   => '←',
    '&times;'  => '×',
  }.freeze

  def decode_entities(s)
    s = EXTRA_ENTITIES.inject(s) { |acc, (k, v)| acc.gsub(k, v) }
    CGI.unescapeHTML(s)
  end

  # Normalize an arbitrary title string into a canonical match key.
  # Lowercase, decode HTML entities, collapse whitespace, unify dashes,
  # drop trailing punctuation.
  def normalize(raw)
    return nil if raw.nil?
    s = decode_entities(raw.to_s)
    s = s.downcase
    s = s.gsub(/[—–−]/, '-')   # em/en/minus -> hyphen
    s = s.gsub(/-+/, '-')
    s = s.gsub(/\s+/, ' ').strip
    s = s.sub(/[[:punct:]]+\z/, '')
    s
  end

  def parse_notes_file(path)
    raw = File.read(path)
    raw = raw.sub(/\A---\s*\n.*?\n---\s*\n/m, '')

    notes = {}
    current_key = nil
    buffer = []

    raw.each_line do |line|
      if line =~ /\A##\s+(.+?)\s*\z/
        flush(notes, current_key, buffer) if current_key
        current_key = Regexp.last_match(1)
        buffer = []
      else
        buffer << line if current_key
      end
    end
    flush(notes, current_key, buffer) if current_key
    notes
  end

  def flush(notes, key, buffer)
    body = buffer.join.strip
    return if body.empty?
    notes[normalize(key)] = body
  end

  def render_markdown(text)
    Kramdown::Document.new(text, input: 'GFM').to_html.strip
  end

  # Match only leaf <section> elements (those that don't contain a nested
  # <section> tag). Reveal column wrappers are non-leaf sections and won't
  # carry a data-menu-title anyway.
  LEAF_SECTION = /
    <section\b([^>]*?)
    data-menu-title="([^"]+)"
    ([^>]*)>
    ((?:(?!<\/?section\b)[\s\S])*?)
    <\/section>
  /mx

  def inject(html, notes, deck_label)
    used = {}

    new_html = html.gsub(LEAF_SECTION) do
      pre, raw_title, post, inner = Regexp.last_match(1), Regexp.last_match(2), Regexp.last_match(3), Regexp.last_match(4)
      key = normalize(raw_title)

      if notes.key?(key)
        used[key] = true
        body = render_markdown(notes[key])
        aside = %(<aside class="notes">#{body}</aside>)

        new_inner = if inner =~ /<aside\b[^>]*\bclass="[^"]*\bnotes\b[^"]*"[^>]*>/
                      inner.sub(/<aside\b[^>]*\bclass="[^"]*\bnotes\b[^"]*"[^>]*>[\s\S]*?<\/aside>/, aside)
                    else
                      "#{inner}\n#{aside}\n"
                    end

        %(<section#{pre}data-menu-title="#{raw_title}"#{post}>#{new_inner}</section>)
      else
        Regexp.last_match(0)
      end
    end

    missing = notes.keys - used.keys
    if missing.any?
      Jekyll.logger.warn 'inject_notes:', "#{deck_label}: no slide matches for: #{missing.join(' | ')}"
    end

    new_html
  end
end

Jekyll::Hooks.register :documents, :post_render do |doc|
  next unless doc.collection && doc.collection.label == 'presentations'
  next unless doc.output

  basename = File.basename(doc.path, '.*')
  next if basename.end_with?('.notes')

  notes_path = File.join(File.dirname(doc.path), "#{basename}.notes.md")
  next unless File.exist?(notes_path)

  notes = InjectNotes.parse_notes_file(notes_path)
  next if notes.empty?

  Jekyll.logger.info 'inject_notes:', "#{basename}: injecting #{notes.size} note block(s)"
  doc.output = InjectNotes.inject(doc.output, notes, basename)
end
