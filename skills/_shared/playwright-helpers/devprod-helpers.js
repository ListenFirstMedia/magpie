// magpie — Playwright MCP helper library for the Data Testing sets (dev + prod in one browser context).
// Load with browser_run_code_unsafe { filename: "skills/_shared/playwright-helpers/devprod-helpers.js" }.
// Installs `page.context()._m` (helpers) and opens/logs in the prod tab (index 0) and dev tab (index 1).
// Credentials: read by the CALLER into ctx._creds = {email, password} before loading, or passed via
// ctx._creds; this file never contains a password.
async (page) => {
  const ctx = page.context();
  const m = ctx._m || {};
  ctx._m = m; ctx._res = ctx._res || {};
  const HOSTS = { prod: 'https://app.listenfirstmedia.com', dev: 'https://app.lfmdev.in' };

  m.pages = () => ({ prod: ctx.pages()[0], dev: ctx.pages()[1] });
  m.text = (p) => p.evaluate(() => document.body.innerText);
  m.toNum = (v) => { if (v == null) return null; v = String(v).trim(); if (!v || v === '–' || v === '-' || v === 'N/A' || v === '—') return null; const mm = v.replace(/,/g, '').match(/-?[\d.]+/); if (!mm) return null; let n = parseFloat(mm[0]); if (/K$/i.test(v)) n *= 1e3; if (/M$/i.test(v)) n *= 1e6; if (/B$/i.test(v)) n *= 1e9; return n; };

  m.login = async (p, host) => {
    const c = ctx._creds; if (!c) throw new Error('ctx._creds {email,password} not set');
    await p.goto(host); await p.waitForTimeout(4000);
    if (/auth\./.test(p.url())) {
      await p.locator('input[type=email], input[name=username]').last().fill(c.email);
      const pw = p.locator('input[type=password]').last(); await pw.fill(c.password); await pw.press('Enter');
      await p.waitForURL(u => !/auth\./.test(String(u)), { timeout: 60000 }).catch(() => null);
      await p.waitForTimeout(8000);
    }
    return { url: p.url().slice(0, 100), title: await p.title() };
  };

  m.switchAccount = async (p, name) => {
    const trig = p.locator('.navigation-controls-user .navigation-menu-header').first();
    await trig.hover(); await p.waitForTimeout(400);
    const box = p.locator('[placeholder="Search Account"]');
    if (!(await box.isVisible().catch(() => false))) await trig.click();
    await box.waitFor({ state: 'visible', timeout: 10000 });
    await box.fill(''); await box.pressSequentially(name, { delay: 40 });
    let ok = false;
    for (let i = 0; i < 8 && !ok; i++) {
      await p.waitForTimeout(2500);
      ok = await p.evaluate(() => [...document.querySelectorAll('*')].some(e => e.children.length === 0 && (e.textContent || '').trim() === 'Results' && e.offsetParent !== null));
      if (!ok) { await box.press('Backspace'); await box.pressSequentially(name.slice(-1), { delay: 40 }); }
    }
    if (!ok) return { ok: false, why: 'no Results header' };
    const h = await p.evaluateHandle((name) => { const hdr = [...document.querySelectorAll('*')].find(e => e.children.length === 0 && (e.textContent || '').trim() === 'Results' && e.offsetParent !== null); return [...document.querySelectorAll('.lfm-ta-option')].find(o => (hdr.compareDocumentPosition(o) & Node.DOCUMENT_POSITION_FOLLOWING) && o.innerText.trim().toUpperCase() === name.toUpperCase()) || null; }, name);
    const el = h.asElement(); if (!el) return { ok: false, why: 'no option' };
    const bb = await el.boundingBox(); await p.mouse.click(bb.x + bb.width / 2, bb.y + bb.height / 2);
    await p.waitForTimeout(8000);
    const acct = ((await m.text(p)).match(/ACCOUNT:\s*([^\n]+)/) || [])[1];
    return { ok: (acct || '').trim().toUpperCase() === name.toUpperCase(), acct, url: p.url().slice(0, 120) };
  };

  m.navLink = async (p, header, item) => {
    const hdr = p.locator('.navigation-menus .navigation-menu-header-label', { hasText: new RegExp('^' + header + '$') }).first();
    await hdr.hover(); await p.waitForTimeout(800);
    await p.locator('a.navigation-menu-link').filter({ visible: true }).filter({ hasText: new RegExp('^' + item + '$') }).first().click();
    await p.waitForTimeout(6000); await p.mouse.move(700, 450);
    return p.url();
  };
  m.gotoContent = (p) => m.navLink(p, 'Brand', 'Content');

  m.waitPosts = async (p, maxMs = 90000) => {
    const t0 = Date.now();
    while (Date.now() - t0 < maxMs) {
      const s = await p.evaluate(() => { const t = document.body.innerText; return { posts: (t.match(/Posts \((\d+)\)/) || [])[1], failed: /failed to load/i.test(t), loading: /Loading/.test(t) }; });
      if (s.failed) { const l = p.locator('.error-data-link a').first(); if (await l.isVisible().catch(() => false)) await l.click(); await p.waitForTimeout(5000); continue; }
      if (s.posts !== undefined && !s.loading) return s.posts;
      await p.waitForTimeout(3000);
    }
    return null;
  };

  m.setDSNth = async (p, name, nth) => {
    const box = p.locator('.lfm-dropdown-select-box').filter({ visible: true }).first();
    await box.click(); await p.waitForTimeout(800);
    const opts = p.locator('.lfm-dropdown-option').filter({ visible: true }).filter({ hasText: new RegExp('^\\s*' + name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '\\s*$') });
    const n = await opts.count();
    if (!n) { const all = await p.locator('.lfm-dropdown-option').filter({ visible: true }).allInnerTexts(); await p.keyboard.press('Escape'); return { ok: false, options: all }; }
    const idx = nth === 'last' ? n - 1 : (nth || 0);
    await opts.nth(idx).click(); await p.waitForTimeout(3000);
    return { ok: true, n, idx, posts: await m.waitPosts(p) };
  };
  m.setDS = (p, name) => m.setDSNth(p, name, 0);
  m.setRank = m.setDS;

  m.setChannels = async (p, want) => {
    const present = await p.evaluate(() => [...document.querySelectorAll('.channel-ghost')].map(e => e.className.split(/\s+/).find(c => !['channel-ghost', 'enabled', 'disabled', 'warning', 'fa-stack'].includes(c))));
    for (const c of want) { if (!present.includes(c)) continue; const g = p.locator('.channel-ghost.' + c).first(); if ((await g.getAttribute('class') || '').includes('disabled')) { await g.click(); await p.waitForTimeout(400); } }
    for (const c of present) { if (want.includes(c)) continue; const g = p.locator('.channel-ghost.' + c).first(); if ((await g.getAttribute('class') || '').includes('enabled')) { await g.click(); await p.waitForTimeout(400); } }
    const en = await p.evaluate(() => [...document.querySelectorAll('.channel-ghost.enabled')].map(e => e.className.replace(/channel-ghost|enabled|warning|fa-stack/g, '').trim()));
    const apply = p.getByRole('button', { name: 'Apply' }).first();
    if (await apply.isVisible().catch(() => false)) { await apply.click(); await p.waitForTimeout(3000); }
    return { present, enabled: en, posts: await m.waitPosts(p) };
  };

  m.tableView = async (p) => {
    const has = () => p.evaluate(() => !![...document.querySelectorAll('table.lfm-table')].find(t => t.offsetParent !== null && [...t.querySelectorAll('thead th')].some(h => h.innerText.trim() === 'Rank')));
    if (await has()) return true;
    await p.locator('[title="Table View"]').first().click(); await p.waitForTimeout(4000); await m.waitPosts(p);
    return has();
  };

  m.scrape = (p) => p.evaluate(() => {
    const t = [...document.querySelectorAll('table.lfm-table')].find(t => t.offsetParent !== null && [...t.querySelectorAll('thead th')].some(h => h.innerText.trim() === 'Rank'));
    if (!t) return null;
    const H = [...t.querySelectorAll('thead th')].map(h => h.innerText.trim().replace(/\n/g, ' '));
    const rows = [...t.querySelectorAll('tbody tr')].map(tr => { const c = [...tr.querySelectorAll('td')].map(td => td.innerText.trim().replace(/\n/g, ' ')); const o = {}; H.forEach((h, i) => o[h] = c[i]); o._links = [...tr.querySelectorAll('a')].map(a => a.href); return o; });
    return { H, agg: rows.filter(r => /Sum|Average/.test(r.Rank || '')), posts: rows.filter(r => !/Sum|Average/.test(r.Rank || '')) };
  });
  m.scrapeStable = async (p) => { let s = await m.scrape(p); for (let i = 0; i < 4 && (!s || !s.posts.length); i++) { await p.waitForTimeout(4000); await m.waitPosts(p, 30000); await m.tableView(p); s = await m.scrape(p); } return s; };

  m.keyOf = (r) => { const l = (r._links || []).filter(h => h && !/lfmdev\.in|listenfirstmedia\.com/.test(h) && !/\/(ucla|user|channel|@)[^/]*\/?$/.test(h) && !/instagram\.com\/[^/]+\/?$/.test(h) && !/twitter\.com\/[^/]+\/?$/.test(h) && !/x\.com\/[^/]+\/?$/.test(h) && !/facebook\.com\/[^/]+\/?$/.test(h) && !/tiktok\.com\/@[^/]+\/?$/.test(h) && !/linkedin\.com\/(company|school)\/[^/]+\/?$/.test(h) && !/youtube\.com\/(channel|c|user|@)/.test(h) && !/threads\.(net|com)\/@[^/]+\/?$/.test(h) && !/pinterest\.com\/[^/]+\/?$/.test(h)); return l.length ? l[l.length - 1] : (r.Date + '|' + (r.Text || '').slice(0, 60)); };

  m.setBrand = async (p, name, typed) => {
    typed = typed || name;
    await p.locator('.brand-selector .brand-selector-name-container').first().click(); await p.waitForTimeout(1000);
    let ta = p.locator('.brand-selector textarea, textarea.lfm-textarea').filter({ visible: true }).first();
    if (!(await ta.count())) ta = p.locator('.brand-selector input').filter({ visible: true }).first();
    await ta.click(); await ta.fill(''); await ta.pressSequentially(typed, { delay: 50 });
    let texts = [];
    for (let i = 0; i < 6; i++) { await p.waitForTimeout(2500); texts = await p.locator('.lfm-ta-option').filter({ visible: true }).allInnerTexts(); if (texts.length) break; if (i === 2) { await ta.press('Backspace'); await ta.pressSequentially(typed.slice(-1), { delay: 50 }); } }
    const idx = texts.findIndex(t => t.trim().toUpperCase() === name.toUpperCase());
    if (idx < 0) { await p.keyboard.press('Escape'); await p.mouse.click(5, 300); return { ok: false, texts: texts.slice(0, 12) }; }
    const bb = await p.locator('.lfm-ta-option').filter({ visible: true }).nth(idx).boundingBox();
    await p.mouse.click(bb.x + bb.width / 2, bb.y + bb.height / 2);
    await p.waitForTimeout(4000); await m.waitPosts(p, 60000);
    const brand = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    return { ok: brand === name, brand, url: (p.url().match(/brand_id=\d+/) || [])[0] };
  };

  m.setDates = async (p, from, to) => {
    const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    await p.locator('button').filter({ hasText: /\d{4}\s*-\s*[A-Z][a-z]{2}/ }).first().click(); await p.waitForTimeout(800);
    await p.locator('.date-selector-container.display-date-picker').first().waitFor({ state: 'visible', timeout: 10000 });
    const pick = async (which, iso) => {
      const [y, mo, d] = iso.split('-').map(Number);
      await p.locator('.date-range-fields').getByText(which, { exact: false }).first().click(); await p.waitForTimeout(500);
      const dp = p.locator('.datepicker').filter({ visible: true }).first();
      await dp.locator('.datepicker-days .datepicker-switch').filter({ visible: true }).first().click(); await p.waitForTimeout(300);
      await dp.locator('.datepicker-months .datepicker-switch').filter({ visible: true }).first().click(); await p.waitForTimeout(300);
      for (let i = 0; i < 6; i++) { const yr = dp.locator('.datepicker-years span.year', { hasText: new RegExp('^' + y + '$') }).filter({ visible: true }); if (await yr.count()) { await yr.first().click(); break; } await dp.locator('.datepicker-years th.prev').filter({ visible: true }).first().click(); await p.waitForTimeout(300); }
      await p.waitForTimeout(300);
      await dp.locator('.datepicker-months span.month', { hasText: new RegExp('^' + MONTHS[mo - 1] + '$') }).filter({ visible: true }).first().click(); await p.waitForTimeout(300);
      await dp.locator('.datepicker-days td.day:not(.old):not(.new)', { hasText: new RegExp('^' + d + '$') }).filter({ visible: true }).first().click(); await p.waitForTimeout(400);
    };
    await pick('START', from); await pick('END', to);
    const fields = await p.locator('.date-range-fields').first().innerText().catch(() => null);
    await p.locator('.date-selector-container.display-date-picker').getByRole('button', { name: /^Ok$/i }).first().click();
    await p.waitForTimeout(3000); await m.waitPosts(p, 90000);
    return { fields, url: (p.url().match(/from=[^&]+&to=[^&]+/) || [])[0] };
  };

  m.compareOnce = async (opts) => {
    const { prod, dev } = m.pages(); const out = { opts };
    const scr = {};
    for (const [name, p] of [['dev', dev], ['prod', prod]]) {
      const o = {};
      if (opts.ds) o.ds = await m.setDSNth(p, opts.ds, opts.dsNth || 0);
      if (opts.channels) o.ch = await m.setChannels(p, opts.channels);
      o.table = await m.tableView(p);
      const s = await m.scrapeStable(p);
      o.n = s ? s.posts.length : null; o.H = s ? s.H : null; o.agg = s ? s.agg : null;
      out[name] = o; scr[name] = s;
    }
    const d = scr.dev, q = scr.prod;
    if (!d || !q) { out.verdict = 'BLOCKED'; out.why = 'table missing'; return out; }
    const skip = new Set(['Rank', 'Actions', 'Text', '_link', '_links']);
    const cols = d.H.filter(h => q.H.includes(h) && !skip.has(h));
    const qmap = new Map(q.posts.map(r => [m.keyOf(r), r]));
    let matched = 0, onlyDev = [], mism = []; const perCol = {};
    for (const r of d.posts) {
      const k = m.keyOf(r); const pr = qmap.get(k);
      if (!pr) { onlyDev.push(k); continue; }
      matched++; qmap.delete(k);
      for (const c of cols) { const a = (r[c] || '').trim(), b = (pr[c] || '').trim(); if (a === b) continue; const na = m.toNum(a), nb = m.toNum(b); if (na !== null && nb !== null && Math.abs(na - nb) < 1e-9) continue; perCol[c] = (perCol[c] || 0) + 1; if (mism.length < 15) mism.push({ post: k.slice(0, 80), col: c, dev: a, prod: b }); }
    }
    const aggDiff = [];
    for (const c of cols) { const a = (d.agg[0] || {})[c], b = (q.agg[0] || {})[c]; if ((a || '').trim() !== (b || '').trim()) aggDiff.push({ col: c, dev: a, prod: b }); }
    out.summary = { devPosts: d.posts.length, prodPosts: q.posts.length, matched, onlyDev: onlyDev.length, onlyProd: qmap.size, onlyDevSample: onlyDev.slice(0, 3), onlyProdSample: [...qmap.keys()].slice(0, 3), colsCompared: cols, mismatchCols: perCol, mismatchSample: mism, aggDiff, devAgg: Object.fromEntries(Object.entries(d.agg[0] || {}).filter(([k, v]) => v && !['Rank', '_links'].includes(k))) };
    const totalMism = Object.values(perCol).reduce((a, b) => a + b, 0);
    out.verdict = (d.posts.length === 0 && q.posts.length === 0) ? 'BLOCKED-NODATA' : (totalMism === 0 && onlyDev.length === 0 && qmap.size === 0 ? 'PASS' : 'FAIL');
    return out;
  };
  m.compact = (r) => ({ verdict: r.verdict, why: r.why, devPosts: r.summary?.devPosts, prodPosts: r.summary?.prodPosts, matched: r.summary?.matched, onlyDev: r.summary?.onlyDev, onlyProd: r.summary?.onlyProd, mismatchCols: r.summary?.mismatchCols, sample: (r.summary?.mismatchSample || []).slice(0, 6), aggDiff: r.summary?.aggDiff, devDS: r.dev?.ds, prodDS: r.prod?.ds, devCh: r.dev?.ch?.enabled, prodCh: r.prod?.ch?.enabled });

  m.setup = async (account, brand) => {
    const { prod, dev } = m.pages(); const r = {};
    for (const [n, p] of [['dev', dev], ['prod', prod]]) {
      r[n] = { sw: await m.switchAccount(p, account) };
      await m.gotoContent(p); await m.waitPosts(p, 90000);
      const cur = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
      if (brand && cur !== brand) r[n].setBrand = await m.setBrand(p, brand);
      r[n].brand = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    }
    return r;
  };
  m.runAccount = async (account, brand, cases, dates) => {
    const out = { setup: await m.setup(account, brand) };
    if (dates) { const { prod, dev } = m.pages(); out.dates = { dev: await m.setDates(dev, dates[0], dates[1]), prod: await m.setDates(prod, dates[0], dates[1]) }; }
    for (const [id, o] of cases) { try { const r = await m.compareOnce(o); r.meta = { account, brand: out.setup.dev.brand, dates: dates ? dates.join(' – ') : undefined }; ctx._res[id] = r; out[id] = m.compact(r); } catch (e) { out[id] = { err: String(e).slice(0, 300) }; } }
    return out;
  };

  // --- bootstrap: two tabs, both logged in ---
  const status = { installed: Object.keys(m).length };
  if (ctx._creds) {
    let prod = ctx.pages()[0]; let dev = ctx.pages()[1] || await ctx.newPage();
    status.prod = await m.login(prod, HOSTS.prod);
    status.dev = await m.login(dev, HOSTS.dev);
  }
  return status;
}
