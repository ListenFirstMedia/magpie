// magpie — run-level helpers for a Data Testing Dev-vs-Prod session (set 3, QA-21686).
// Load AFTER devprod-helpers.js and set-helpers.js. Set ctx._date = 'YYYY-MM-DD' first (results folder).
// Everything here is read-only on both environments (docs/PROMPT.md, Data Test read-only rule).
async (page) => {
  const ctx = page.context(); const m = ctx._m;
  if (!m) return { err: 'load devprod-helpers.js first' };
  const brandOf = (p) => p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());

  // Write a JSON file into results/<ctx._date>/ through a Blob download (run_code has no fs access).
  m.dump = async (name, obj) => {
    const p = m.pages().dev;
    const [dl] = await Promise.all([p.waitForEvent('download', { timeout: 30000 }), p.evaluate((s) => { const a = document.createElement('a'); a.href = URL.createObjectURL(new Blob([s], { type: 'application/json' })); a.download = 'dump.json'; document.body.appendChild(a); a.click(); a.remove(); }, JSON.stringify(obj, null, 1))]);
    await dl.saveAs('/Users/yashsharma/git/magpie/results/' + ctx._date + '/' + name); return name;
  };
  m.week = (p) => p.evaluate(() => (document.body.innerText.match(/Date Range:\s*([^\n]+)/) || [])[1]);
  m.brandOf = brandOf;

  // Switch account on both tabs, open Brand > Content and force the SAME brand on both
  // (the prod user's default brand differs from dev's).
  m.setup2 = async (account, brand) => {
    const { prod, dev } = m.pages(); const r = {};
    for (const [n, p] of [['dev', dev], ['prod', prod]]) {
      const o = r[n] = {};
      o.sw = await m.switchAccount(p, account);
      if (!o.sw.ok) { await p.keyboard.press('Escape').catch(() => null); await p.mouse.click(700, 500).catch(() => null); continue; }
      await m.gotoContent(p); await m.waitPosts(p, 60000);
      for (let i = 0; i < 2 && !(await p.locator('.brand-selector-name').count()); i++) { await p.reload({ waitUntil: 'commit' }).catch(() => null); await p.waitForTimeout(12000); if (!/content/.test(p.url())) await m.gotoContent(p); await m.waitPosts(p, 60000); }
      const cur = await brandOf(p);
      if (brand && cur !== brand) o.setBrand = await m.setBrand(p, brand);
      o.brand = await brandOf(p);
      o.posts = await m.waitPosts(p, 30000); o.week = await m.week(p);
      o.id = (p.url().match(/brand_id=\d+/) || [])[0];
    }
    return r;
  };

  // cases = [[id, compareOnce opts, note?], ...]; results go to ctx._res and results/<date>/_devprod-results.json.
  m.runList = async (account, cases, extra) => {
    const { prod, dev } = m.pages();
    const out = {}; const brand = await brandOf(dev); const pb = await brandOf(prod);
    if (brand !== pb) return { err: 'brand differs', brand, pb };
    for (const [id, o, note] of cases) {
      try { const r = await m.compareOnce(o); r.meta = Object.assign({ account, brand, week: await m.week(dev), weekProd: await m.week(prod), note }, extra || {}); ctx._res[id] = r; out[id] = m.compact(r); }
      catch (e) { out[id] = { err: String(e).slice(0, 300) }; }
      await m.dump('_devprod-results.json', ctx._res).catch(() => null);
    }
    return out;
  };

  // QA-3936: Facebook only + Sentiment toggle, then read the Topics cloud (font-size = weight).
  m.topics = async (p) => {
    const o = {};
    await m.waitPosts(p, 60000);
    const ch = await m.setChannels(p, ['facebook']); o.ch = [ch.enabled, ch.posts];
    if (!/sentiment_mode=true/.test(p.url())) { await p.locator('[data-ui-name=earned_sentiment_cta]').first().click(); await p.waitForTimeout(6000); }
    for (let i = 0; i < 15; i++) { const n2 = await p.evaluate(() => document.querySelectorAll('.cloud svg text').length); if (n2) break; await p.waitForTimeout(4000); }
    await p.waitForTimeout(5000);
    Object.assign(o, await p.evaluate(() => { const words = [...document.querySelectorAll('.cloud svg text')].map(t => ({ w: t.textContent.trim(), fs: parseFloat(t.style.fontSize || getComputedStyle(t).fontSize) })).sort((a, b) => b.fs - a.fs || a.w.localeCompare(b.w)); const body = document.body.innerText; const i = body.search(/Top \d+ Topics/); return { url: location.href.match(/sentiment_mode=\w+/)?.[0], posts: (body.match(/Posts \((\d+)\)/) || [])[1], week: (body.match(/Date Range:\s*([^\n]+)/) || [])[1], words, legend: i >= 0 ? body.slice(i, i + 300).split('\n').slice(0, 12) : null, tiles: [...document.querySelectorAll('.tile.sentiment-analysis')].filter(e => e.offsetParent !== null).map(t => t.innerText.trim().replace(/\n+/g, ' | ').slice(0, 200)).slice(0, 8) }; }));
    return o;
  };
  m.topicsCmp = (T) => {
    const key = (a) => a.words.map(x => x.w + '@' + x.fs.toFixed(1)).join('|');
    T.same = key(T.dev) === key(T.prod); T.nDev = T.dev.words.length; T.nProd = T.prod.words.length;
    T.onlyDev = T.dev.words.filter(x => !T.prod.words.some(y => y.w === x.w)).map(x => x.w); T.onlyProd = T.prod.words.filter(x => !T.dev.words.some(y => y.w === x.w)).map(x => x.w);
    T.weightDiff = T.dev.words.filter(x => { const y = T.prod.words.find(z => z.w === x.w); return y && Math.abs(y.fs - x.fs) > 0.05; }).map(x => x.w);
    T.legendSame = JSON.stringify(T.dev.legend) === JSON.stringify(T.prod.legend);
    return T;
  };

  // QA-144819: Settings > Brands rows on the current page (rows are the <tr> that hold .al-table__channels).
  m.brandRows = (p) => p.evaluate(() => { const rows = [...document.querySelectorAll('tr')].filter(tr => tr.querySelector('.al-table__channels')).map(tr => { const tds = [...tr.querySelectorAll('td')]; return { brand: (tds[0]?.innerText || '').trim().split('\n')[0], channels: [...tr.querySelectorAll('.al-table__channels a[title]')].map(a => a.getAttribute('title')).sort(), status: Object.fromEntries(['red', 'blue', 'yellow', 'green'].map(c => [c, (tr.querySelector('.status-badge.' + c)?.innerText || '').trim()]).filter(([, v]) => v)) }; }); const body = document.body.innerText; const pi = body.indexOf('Page:'); return { rows, pager: pi >= 0 ? body.slice(pi, pi + 80).replace(/\n+/g, ' ') : null, acct: (body.match(/ACCOUNT:\s*([^\n]+)/) || [])[1] }; });
  m.waitBrandRows = async (p) => { for (let i = 0; i < 30; i++) { if (await p.evaluate(() => document.querySelectorAll('.al-table__channels').length) > 0) break; await p.waitForTimeout(3000); } await p.waitForTimeout(3000); };
  m.brandsCmp = (d, q) => { const pm = new Map(q.map(r => [r.brand, r])); const diffs = []; let matched = 0; const onlyDev = []; for (const r of d) { const x = pm.get(r.brand); if (!x) { onlyDev.push(r.brand); continue; } matched++; pm.delete(r.brand); const df = {}; if (JSON.stringify(r.channels) !== JSON.stringify(x.channels)) df.channels = [r.channels, x.channels]; if (JSON.stringify(r.status) !== JSON.stringify(x.status)) df.status = [r.status, x.status]; if (Object.keys(df).length) diffs.push({ brand: r.brand, ...df }); } return { devRows: d.length, prodRows: q.length, matched, onlyDev, onlyProd: [...pm.keys()], diffs }; };

  return { ok: true, date: ctx._date, fns: ['dump', 'week', 'setup2', 'runList', 'topics', 'topicsCmp', 'brandRows', 'waitBrandRows', 'brandsCmp'] };
}
