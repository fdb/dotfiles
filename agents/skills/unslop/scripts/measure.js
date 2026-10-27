// Unslop measurement. Paste into any browser tool that evaluates a function
// (Playwright evaluate, Chrome DevTools, claude-in-chrome javascript_tool):
//   (<contents of this file>)({ root: 'main', scale: [0,2,4,8,12,16,24,32,40,48,64] })
// Returns a JSON report. Every count is a number that should go down as a screen improves.
(opts = {}) => {
  const SCALE = new Set(opts.scale || [0, 2, 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64, 80, 96]);
  const root = typeof opts.root === 'string' ? document.querySelector(opts.root) : (opts.root || document.body);
  if (!root) return { error: `root not found: ${opts.root}` };
  const MAX_EXAMPLES = opts.examples ?? 6;
  // A CSS transform on the root or an ancestor scales screen pixels; report CSS pixels.
  const S = (root.getBoundingClientRect().width / root.offsetWidth) || 1;

  const all = [root, ...root.querySelectorAll('*')].filter(el => {
    if (el.closest('svg') && el.tagName.toLowerCase() !== 'svg') return false;
    const r = el.getBoundingClientRect();
    if (r.width === 0 && r.height === 0) return false;
    const cs = getComputedStyle(el);
    return cs.visibility !== 'hidden' && cs.display !== 'none' && parseFloat(cs.opacity) > 0.05;
  });

  const path = el => {
    const parts = [];
    for (let n = el; n && n !== root.parentElement && parts.length < 4; n = n.parentElement) {
      let s = n.tagName.toLowerCase();
      if (n.id) { s += '#' + n.id; parts.unshift(s); break; }
      const cls = [...n.classList].slice(0, 2).join('.');
      if (cls) s += '.' + cls;
      parts.unshift(s);
    }
    return parts.join(' > ');
  };
  const ownText = el => [...el.childNodes].filter(n => n.nodeType === 3).map(n => n.textContent).join('').trim();
  const push = (arr, v) => { if (arr.length < MAX_EXAMPLES) arr.push(v); };

  // ---------- color parsing ----------
  const parseRGB = s => {
    const m = s && s.match(/rgba?\(\s*([\d.]+)[ ,]+([\d.]+)[ ,]+([\d.]+)(?:[ ,/]+([\d.]+%?))?/);
    if (!m) return null;
    let a = m[4] === undefined ? 1 : (m[4].endsWith('%') ? parseFloat(m[4]) / 100 : parseFloat(m[4]));
    return { r: +m[1], g: +m[2], b: +m[3], a };
  };
  const hsl = ({ r, g, b }) => {
    r /= 255; g /= 255; b /= 255;
    const mx = Math.max(r, g, b), mn = Math.min(r, g, b), l = (mx + mn) / 2, d = mx - mn;
    if (!d) return { h: 0, s: 0, l };
    const s = d / (1 - Math.abs(2 * l - 1));
    let h = mx === r ? ((g - b) / d) % 6 : mx === g ? (b - r) / d + 2 : (r - g) / d + 4;
    return { h: (h * 60 + 360) % 360, s, l };
  };
  const lum = ({ r, g, b }) => {
    const f = c => { c /= 255; return c <= 0.03928 ? c / 12.92 : ((c + 0.055) / 1.055) ** 2.4; };
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
  };
  const ratio = (a, b) => { const x = lum(a), y = lum(b); return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05); };
  const blend = (fg, bg) => ({ r: fg.r * fg.a + bg.r * (1 - fg.a), g: fg.g * fg.a + bg.g * (1 - fg.a), b: fg.b * fg.a + bg.b * (1 - fg.a), a: 1 });

  // ---------- 1. spacing ----------
  const gapVals = new Map(); const offScale = [];
  all.forEach(el => {
    const cs = getComputedStyle(el);
    const vertical = cs.display.includes('flex') ? cs.flexDirection.startsWith('column') : (cs.display === 'block' || cs.display === 'flow-root' || cs.display.includes('grid'));
    if (!vertical) return;
    const kids = [...el.children].filter(k => all.includes(k) && !['absolute', 'fixed'].includes(getComputedStyle(k).position))
      .map(k => ({ k, r: k.getBoundingClientRect() })).sort((a, b) => a.r.top - b.r.top);
    for (let i = 1; i < kids.length; i++) {
      const a = kids[i - 1], b = kids[i];
      if (b.r.top < a.r.bottom - 1) continue; // same row
      const g = Math.round((b.r.top - a.r.bottom) / S);
      if (g <= 0) continue;
      gapVals.set(g, (gapVals.get(g) || 0) + 1);
      if (!SCALE.has(g)) push(offScale, { gap: g, between: [path(a.k), path(b.k)] });
    }
  });
  const gapTotal = [...gapVals.values()].reduce((a, b) => a + b, 0);
  const gapOff = [...gapVals].filter(([g]) => !SCALE.has(g)).reduce((a, [, n]) => a + n, 0);

  // ---------- 4. edges ----------
  const xs = new Map();
  all.forEach(el => {
    if (!ownText(el) && !el.matches('input,select,textarea,button,img,svg')) return;
    const cs = getComputedStyle(el), r = el.getBoundingClientRect();
    const x = Math.round(r.left / S + parseFloat(cs.paddingLeft) + parseFloat(cs.borderLeftWidth));
    if (!xs.has(x)) xs.set(x, []);
    xs.get(x).push(el);
  });
  const edges = [...xs].map(([x, els]) => ({ x, n: els.length, els })).sort((a, b) => b.n - a.n);
  const nearMiss = [];
  edges.forEach(e => {
    const anchor = edges.find(o => o.n >= 3 && o.n > e.n && Math.abs(o.x - e.x) >= 2 && Math.abs(o.x - e.x) <= 8);
    if (anchor) push(nearMiss, { x: e.x, offBy: e.x - anchor.x, anchorX: anchor.x, elements: e.els.slice(0, 3).map(path) });
  });
  const nearMissCount = edges.filter(e => edges.some(o => o.n >= 3 && o.n > e.n && Math.abs(o.x - e.x) >= 2 && Math.abs(o.x - e.x) <= 8)).length;

  // ---------- 2/6. color ----------
  const hues = []; let gradients = 0, gradientText = 0, glows = 0; const gradEx = [], glowEx = [];
  const addHue = (c, el, prop) => {
    if (!c || c.a < 0.15) return;
    const h = hsl(c); if (h.s < 0.18 || h.l < 0.08 || h.l > 0.96) return;
    let g = hues.find(x => Math.abs(((x.h - h.h + 540) % 360) - 180) < 14);
    if (!g) { g = { h: Math.round(h.h), n: 0, props: new Set(), examples: [] }; hues.push(g); }
    g.n++; g.props.add(prop); push(g.examples, path(el));
  };
  all.forEach(el => {
    const cs = getComputedStyle(el);
    if (ownText(el)) addHue(parseRGB(cs.color), el, 'text');
    addHue(parseRGB(cs.backgroundColor), el, 'background');
    if (parseFloat(cs.borderTopWidth) > 0) addHue(parseRGB(cs.borderTopColor), el, 'border');
    if (el.tagName.toLowerCase() === 'svg') el.querySelectorAll('[fill],[stroke]').forEach(s => {
      const sc = getComputedStyle(s); addHue(parseRGB(sc.fill), el, 'svg'); addHue(parseRGB(sc.stroke), el, 'svg');
    });
    if (/gradient\(/.test(cs.backgroundImage)) {
      gradients++; push(gradEx, path(el));
      (cs.backgroundImage.match(/rgba?\([^)]*\)/g) || []).forEach(c => addHue(parseRGB(c), el, 'gradient'));
      if ((cs.webkitBackgroundClip || cs.backgroundClip) === 'text') gradientText++;
    }
    const sh = cs.boxShadow;
    if (sh && sh !== 'none') sh.split(/,(?![^(]*\))/).forEach(s => {
      const c = parseRGB(s), nums = s.replace(/rgba?\([^)]*\)/, '').match(/-?[\d.]+px/g) || [];
      const blur = parseFloat(nums[2] || 0);
      if (c && blur >= 10 && hsl(c).s > 0.25 && c.a > 0.15) { glows++; push(glowEx, path(el)); }
    });
    if (cs.filter.includes('drop-shadow') || cs.textShadow !== 'none' && /\d+px\s*\)?$/.test(cs.textShadow) && parseFloat((cs.textShadow.match(/([\d.]+)px(?!.*px)/) || [])[1]) >= 8) { glows++; push(glowEx, path(el)); }
  });

  // ---------- 3/5. emoji and copy ----------
  const EMOJI = /\p{Extended_Pictographic}/gu;
  let emoji = 0, bangs = 0, multiBang = 0, shouty = 0; const emojiEx = [], copyEx = [];
  const walker = document.createTreeWalker(root, NodeFilter.SHOW_TEXT);
  for (let n; (n = walker.nextNode());) {
    const t = n.textContent; if (!t.trim() || !n.parentElement || !all.includes(n.parentElement)) continue;
    const m = t.match(EMOJI); if (m) { emoji += m.length; push(emojiEx, t.trim().slice(0, 50)); }
    const b = (t.match(/!/g) || []).length; bangs += b;
    if (/!{2,}|\?!/.test(t)) { multiBang++; push(copyEx, t.trim().slice(0, 50)); }
    if (/^(hey|hi|welcome( back)?|oops|let's|yay|woohoo|awesome)\b/i.test(t.trim())) push(copyEx, t.trim().slice(0, 50));
    const cs = getComputedStyle(n.parentElement);
    if (cs.textTransform === 'uppercase' && t.trim().length > 3) shouty++;
  }

  // ---------- 7/8. type, radii, nesting ----------
  const fams = new Map(), sizes = new Map(), weights = new Map(), radii = new Map();
  all.forEach(el => {
    const cs = getComputedStyle(el);
    if (ownText(el)) {
      const f = cs.fontFamily.split(',')[0].replace(/["']/g, '').trim();
      fams.set(f, (fams.get(f) || 0) + 1);
      sizes.set(cs.fontSize, (sizes.get(cs.fontSize) || 0) + 1);
      weights.set(cs.fontWeight, (weights.get(cs.fontWeight) || 0) + 1);
    }
    const rad = cs.borderTopLeftRadius;
    if (rad && rad !== '0px' && !rad.includes('%') && parseFloat(rad) < 999) radii.set(rad, (radii.get(rad) || 0) + 1);
  });
  const hasShadow = el => { const s = getComputedStyle(el).boxShadow; return s && s !== 'none' && !/inset/.test(s); };
  const nested = [];
  all.forEach(el => {
    if (!hasShadow(el)) return;
    for (let p = el.parentElement; p && p !== root.parentElement; p = p.parentElement) if (hasShadow(p)) { push(nested, path(el)); break; }
  });
  const nestedCount = all.filter(el => { if (!hasShadow(el)) return false; for (let p = el.parentElement; p && p !== root.parentElement; p = p.parentElement) if (hasShadow(p)) return true; return false; }).length;

  // ---------- 9. numbers ----------
  const numCells = []; let numBad = 0;
  root.querySelectorAll('td').forEach(td => {
    const t = td.textContent.trim();
    if (!/^[-+−]?[€$£]?\s?[\d.,]+\s?[%a-z€$£/]*$/i.test(t) || !/\d/.test(t)) return;
    const cs = getComputedStyle(td);
    const right = cs.textAlign === 'right' || cs.textAlign === 'end';
    const tab = cs.fontVariantNumeric.includes('tabular') || /mono/i.test(cs.fontFamily);
    if (!right || !tab) { numBad++; push(numCells, { text: t, align: cs.textAlign, tabular: tab }); }
  });

  // ---------- 11. contrast ----------
  const bgOf = el => {
    let c = { r: 255, g: 255, b: 255, a: 1 }; const stack = [];
    for (let p = el; p; p = p.parentElement) {
      const cs = getComputedStyle(p);
      if (/gradient\(|url\(/.test(cs.backgroundImage)) return null;
      const b = parseRGB(cs.backgroundColor); if (b && b.a > 0) { stack.push(b); if (b.a >= 1) break; }
    }
    if (!stack.length) return c;
    for (let i = stack.length - 1; i >= 0; i--) c = blend(stack[i], c);
    return c;
  };
  const lowContrast = []; let lowCount = 0, unknownBg = 0;
  all.forEach(el => {
    if (!ownText(el)) return;
    const cs = getComputedStyle(el); const fg = parseRGB(cs.color);
    if (!fg || cs.webkitBackgroundClip === 'text' || cs.backgroundClip === 'text') return;
    const bg = bgOf(el); if (!bg) { unknownBg++; return; }
    const size = parseFloat(cs.fontSize), bold = parseInt(cs.fontWeight) >= 700;
    const need = size >= 24 || (bold && size >= 18.66) ? 3 : 4.5;
    const r = ratio(blend(fg, bg), bg);
    if (r < need) { lowCount++; push(lowContrast, { text: ownText(el).slice(0, 40), ratio: +r.toFixed(2), need, el: path(el) }); }
  });

  const top = m => [...m].sort((a, b) => b[1] - a[1]).map(([k, n]) => `${k}×${n}`);
  return {
    root: path(root),
    summary: {
      gapsOffScale: gapOff, gapsTotal: gapTotal, gapDistinct: gapVals.size,
      edgeNearMisses: nearMissCount, textEdges: edges.length,
      hues: hues.length, gradients, gradientText, glows,
      emoji, multiExclamation: multiBang, uppercaseLabels: shouty,
      fontFamilies: fams.size, fontSizes: sizes.size, fontWeights: weights.size, radii: radii.size,
      nestedShadows: nestedCount, numericCellsMisaligned: numBad,
      lowContrastText: lowCount, contrastUnknownOnGradient: unknownBg
    },
    detail: {
      gapHistogram: top(gapVals), offScale,
      edges: edges.slice(0, 12).map(e => `${e.x}px×${e.n}`), nearMiss,
      hues: hues.sort((a, b) => b.n - a.n).map(h => ({ hue: h.h, uses: h.n, as: [...h.props], examples: h.examples })),
      gradients: gradEx, glows: glowEx,
      emoji: emojiEx, copy: copyEx,
      fontFamilies: top(fams), fontSizes: top(sizes), fontWeights: top(weights), radii: top(radii),
      nestedShadows: nested, numericCells: numCells, lowContrast
    }
  };
}
