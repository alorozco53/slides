// Display slide numbers as URL-fragment indices (0-indexed).
//
// Three rendering modes, picked per-slide:
//   1. Single-column ("flat") deck -- only one top-level <section> wraps every
//      slide. Show just "v" (e.g. URL #/0/3 -> "3"). h is always 0 so it adds
//      nothing.
//   2. Multi-column deck, slide inside a vertical stack -- show "h.v"
//      (e.g. URL #/5/2 -> "5.2").
//   3. Multi-column deck, flat top-level slide -- show just "h"
//      (e.g. URL #/3 -> "3").
//
// Why a MutationObserver rather than a plain 'slidechanged' listener?
// Inside reveal.js's slide() the call order is:
//   1. dispatchEvent('slidechanged')
//   2. updateSlideNumber()           <-- runs AFTER the event
// so a listener that writes to .slide-number gets immediately clobbered by
// reveal's own 1-indexed default. Observing the element and rewriting on
// every mutation sidesteps the ordering issue.
//
// Loaded by _includes/presentation/scripts.html when the deck sets
//   reveal:
//     zero_indexed_slide_number: true
// in its front matter. The same flag also forces slideNumber = 'h.v' in
// revealConfig so the .slide-number element actually exists.
(function() {
  var inUpdate = false;

  function topHorizontalSectionCount() {
    var slides = document.querySelector('.reveal .slides');
    if (!slides) return 0;
    var n = 0;
    for (var i = 0; i < slides.children.length; i++) {
      if (slides.children[i].tagName === 'SECTION') n++;
    }
    return n;
  }

  function wanted() {
    if (typeof Reveal === 'undefined' || !Reveal.getIndices) return null;
    var idx = Reveal.getIndices();

    // Mode 1: single-column deck -> show only v
    if (topHorizontalSectionCount() === 1) {
      return String(idx.v || 0);
    }

    // Mode 2 / 3: multi-column deck
    var cur = Reveal.getCurrentSlide && Reveal.getCurrentSlide();
    var inStack = cur && cur.parentNode && cur.parentNode.tagName === 'SECTION';
    return inStack ? (idx.h + '.' + (idx.v || 0)) : String(idx.h);
  }

  function rewrite(el) {
    if (inUpdate) return;
    var w = wanted();
    if (w === null) return;
    if (el.textContent !== w) {
      inUpdate = true;
      el.textContent = w;
      inUpdate = false;
    }
  }

  function attach() {
    var el = document.querySelector('.reveal .slide-number');
    if (!el || typeof Reveal === 'undefined' || !Reveal.getIndices) {
      setTimeout(attach, 50);
      return;
    }
    rewrite(el);
    var obs = new MutationObserver(function() { rewrite(el); });
    obs.observe(el, { childList: true, characterData: true, subtree: true });
  }

  attach();
})();
