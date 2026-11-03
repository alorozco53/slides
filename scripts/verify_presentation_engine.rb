# Run with: bundle exec ruby scripts/verify_presentation_engine.rb [engine-root]
require 'rbconfig'
require 'tmpdir'
require 'fileutils'

engine = File.expand_path(ARGV.fetch(0, '..'), __dir__)
Dir.mktmpdir('reveal-parity-') do |root|
  source = File.join(root, 'source')
  destination = File.join(root, 'output')
  FileUtils.mkdir_p(File.join(source, '_presentations'))
  %w[_layouts _includes _plugins].each do |directory|
    FileUtils.cp_r(File.join(engine, directory), source)
  end
  File.write(File.join(source, '_config.yml'), <<~YAML)
    url: ''
    baseurl: ''
    author:
      name: Engine verification
    collections:
      presentations:
        output: true
        permalink: /presentations/:path/
  YAML
  File.write(File.join(source, '_presentations', 'check.html'), <<~HTML)
    ---
    layout: reveal
    title: Engine verification
    reveal:
      math: true
      notes: true
      zero_indexed_slide_number: true
    ---
    <section>
      <section data-menu-title="Ch. 1 &mdash; Intro">
        <h2>Intro</h2><aside class="notes">REPLACED INLINE NOTE</aside>
      </section>
      <section data-menu-title="Second">
        <h2>Second</h2><aside class="notes">PRESERVED INLINE NOTE</aside>
      </section>
    </section>
  HTML
  File.write(File.join(source, '_presentations', 'check.notes.md'), <<~MARKDOWN)
    ---
    published: false
    ---
    ## CH. 1 -- Intro
    Sidecar **speaker note** with $x$.
  MARKDOWN
  command = [RbConfig.ruby, Gem.bin_path('jekyll', 'jekyll'), 'build', '--trace',
             '--source', source, '--destination', destination,
             '--config', File.join(source, '_config.yml')]
  raise 'Jekyll fixture build failed' unless system(*command, chdir: source)
  output = File.read(File.join(destination, 'presentations', 'check', 'index.html'))
  checks = {
    'sidecar notes and Markdown' => output.include?('Sidecar <strong>speaker note</strong>'),
    'sidecar override' => !output.match?(/<aside\b[^>]*>REPLACED INLINE NOTE<\/aside>/),
    'unmatched inline note retained' => output.include?('PRESERVED INLINE NOTE'),
    'zero-indexed numbering' => output.include?('/js/slide-number-zero-indexed.js'),
    'speaker plugin' => output.include?('/plugin/notes/notes.js'),
    'math plugin' => output.include?('/plugin/math/math.js'),
    'print stylesheet integration' => output.include?('/css/print/pdf.css'),
    'export menu' => output.include?("title: 'Export'"),
    'sidecar not independently served' => Dir.glob(File.join(destination, '**', '*notes*')).empty?
  }
  failures = checks.select { |_name, passed| !passed }.keys
  raise "Engine verification failed: #{failures.join(', ')}" unless failures.empty?
  puts "Verified #{checks.size} presentation engine checks."
end
