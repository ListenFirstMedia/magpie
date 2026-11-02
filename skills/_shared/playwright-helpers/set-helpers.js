// magpie — extension helpers for the Data Testing sets (Brand Sets vs Content, Brand>Paid vs TWC,
// Benchmark, Settings>Data Collection, LFM-vs-Native, Brand>Stories). Requires devprod-helpers.js
// to be loaded first (ctx._m with pages/text/toNum/navLink/setBrand/setDS/setChannels/tableView/scrape...).
// Load with browser_run_code_unsafe { filename: "skills/_shared/playwright-helpers/set-helpers.js" }.
async (page) => {
  const ctx = page.context(); const m = ctx._m;
  if (!m) throw new Error('load devprod-helpers.js first');
  const toNum = m.toNum;


  // Dev under batch load can sit on "Loading" for 2-3 minutes; wait for the post list before switching views.
  m.tableViewSlow = async (p, maxMs = 180000) => {
    await m.waitPosts(p, maxMs);
    const t0 = Date.now();
    while (Date.now() - t0 < maxMs) { const has = await p.evaluate(() => !!document.querySelector('[title="Table View"]') || !![...document.querySelectorAll('table.lfm-table')].find(t => t.offsetParent !== null)); if (has) break; await p.waitForTimeout(4000); }
    return m.tableView(p);
  };
  // ---------- Brand Sets > Content ----------
  // Brand Sets > Content sometimes renders the header without the Rank dropdown / post list; wait for the
  // Rank dropdown and reload once if it never appears (2026-10-26).
  m.gotoBrandSetsContent = async (p) => {
    const url = await m.navLink(p, 'Brand Sets', 'Content');
    const ready = () => p.evaluate(() => [...document.querySelectorAll('.lfm-dropdown-select-box')].some(e => e.offsetParent !== null) && !/Loading/.test(document.body.innerText));
    let t0 = Date.now(); while (Date.now() - t0 < 150000) { if (await ready()) return { url }; await p.waitForTimeout(4000); }
    await p.reload(); await p.waitForTimeout(10000);
    t0 = Date.now(); while (Date.now() - t0 < 150000) { if (await ready()) return { url, reloaded: true }; await p.waitForTimeout(4000); }
    return { url, reloaded: true, ready: false };
  };

  m.contentBrandFilter = async (p, brand) => {
    // huge brand sets (e.g. LF // TV // Episodic Plus, 87k posts) render the filter control minutes after the header (2026-10-26/27)
    { let t0 = Date.now(); while (Date.now() - t0 < 240000) { const ok = await p.evaluate(() => !!document.querySelector('[data-ui-name*=select_filter]') && !/\| Loading|\nLoading\n/.test(document.body.innerText)).catch(() => false); if (ok) break; await p.waitForTimeout(5000); } }
    const panelOpen = await p.evaluate(() => [...document.querySelectorAll('.option-row')].some(e => e.offsetParent !== null));
    if (!panelOpen) { await p.locator('[data-ui-name=content_select_filter_cta], [data-ui-name*=select_filter]').first().click(); await p.waitForTimeout(1200); await p.locator('.option-row').filter({ visible: true }).filter({ hasText: /^Content Brand$/ }).first().click(); await p.waitForTimeout(1200); }
    const searches = p.locator('textarea.lfm-textarea[placeholder="Search"]').filter({ visible: true });
    const n = await searches.count(); const ta = searches.nth(n - 1);
    await ta.click(); await ta.fill(''); await ta.pressSequentially(brand, { delay: 40 }); await p.waitForTimeout(2500);
    const vals = await p.evaluate(() => [...document.querySelectorAll('.option-row')].filter(e => e.offsetParent !== null).map(e => e.innerText.trim()));
    const opt = p.locator('.option-row').filter({ visible: true }).filter({ hasText: new RegExp('^' + brand.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '$') }).first();
    if (!(await opt.count())) return { ok: false, vals: vals.slice(0, 20) };
    await opt.click(); await p.waitForTimeout(800);
    await p.locator('[data-ui-name=apply_filter_cta]').first().click(); await p.waitForTimeout(3000);
    const posts = await m.waitPosts(p, 90000);
    return { ok: true, posts, url: decodeURIComponent((p.url().match(/filters=[^&]+/) || [''])[0]).slice(0, 200) };
  };

  // One brand set / content brand / ONE channel, several Rank By metrics (QA-573, QA-576 pattern).
  m.bsVsContent = async (p, o) => {
    const out = { opts: o };
    if (o.account) out.sw = await m.switchAccount(p, o.account);
    let cmap;
    if (!(o.resume && ctx._bsCache && ctx._bsCache[o.contentBrand + '|' + o.channel])) {
    await m.gotoContent(p); await m.waitPosts(p, 90000);
    const cur = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    out.brand = cur === o.contentBrand ? { ok: true, brand: cur } : await m.setBrand(p, o.contentBrand);
    if (o.contentDS) out.cds = await m.setDS(p, o.contentDS);
    out.cch = await m.setChannels(p, [o.channel]);
    await m.tableViewSlow(p);
    const cs = await m.scrapeStable(p);
    cmap = new Map((cs?.posts || []).map(x => [m.keyOf(x), x]));
    out.contentN = cs?.posts.length; out.contentH = cs?.H;
    ctx._bsCache = ctx._bsCache || {}; ctx._bsCache[o.contentBrand + '|' + o.channel] = { cmap, contentN: out.contentN, contentH: out.contentH };
    } else { const c = ctx._bsCache[o.contentBrand + '|' + o.channel]; cmap = c.cmap; out.contentN = c.contentN; out.contentH = c.contentH; out.resumed = true; }
    out.nav = (await m.gotoBrandSetsContent(p)).url; await m.waitPosts(p, 120000);
    const cur2 = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    out.bs = cur2 === o.brandSet ? { ok: true, brand: cur2 } : await m.setBrand(p, o.brandSet);
    out.filter = await m.contentBrandFilter(p, o.contentBrand);
    out.cmp = {};
    for (const r of o.ranks) {
      const set = await m.setDSNth(p, r.rank, r.nth || 0);
      await p.waitForTimeout(1500);
      const ch = await m.setChannels(p, [o.channel]); await m.tableViewSlow(p);
      const s = await m.scrapeStable(p);
      const rows = (s?.posts || []).map(x => ({ k: m.keyOf(x), v: x[r.rank] ?? x[s.H[10]] })).filter(x => !o.domainRe || o.domainRe.test(x.k));
      let matched = 0, mism = [], missing = [];
      for (const row of rows) { const c = cmap.get(row.k); if (!c) { missing.push(row.k.slice(-28)); continue; } matched++; if (toNum(row.v) !== toNum(c[r.col])) mism.push({ k: row.k.slice(-28), bs: row.v, content: c[r.col] }); }
      out.cmp[r.rank] = { set, enabled: ch.enabled, H: s?.H, bsRows: rows.length, matched, missing: missing.length, missingSample: missing.slice(0, 3), mismatches: mism.length, sample: mism.slice(0, 5), top: rows[0] };
    }
    return out;
  };

  // One Rank By metric, several channels, optional Filtered rank mode (QA-32524 / QA-32526 pattern).
  m.bsVsContentMulti = async (p, o) => {
    const out = { opts: { ...o } };
    if (o.account) out.sw = await m.switchAccount(p, o.account);
    ctx._bsCache = ctx._bsCache || {};
    const ck = 'multi|' + o.contentBrand + '|' + (o.contentDS || '') + '|' + o.channels.join(',');
    let cmaps;
    if (o.resume && ctx._bsCache[ck]) { cmaps = ctx._bsCache[ck]; out.resumed = true; }
    else {
    await m.gotoContent(p); await m.waitPosts(p, 90000);
    const cur = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    out.brand = cur === o.contentBrand ? { ok: true, brand: cur } : await m.setBrand(p, o.contentBrand);
    if (o.contentDS) { out.cds = await m.setDS(p, o.contentDS); const slug = o.contentDS.toLowerCase().replace(/\s+/g, '_'); if (!new RegExp('table_data_set=' + slug).test(p.url())) { await p.waitForTimeout(5000); out.cds2 = await m.setDSNth(p, o.contentDS, 'last'); } out.dsUrl = (p.url().match(/table_data_set=[^&]+/) || [])[0]; } // verify the data set really applied (2026-10-27: first setDS was ignored while the page settled)
    cmaps = {};
    for (const ch of o.channels) { await m.setChannels(p, [ch]); await m.tableViewSlow(p); const cs = await m.scrapeStable(p); cmaps[ch] = { H: cs?.H, n: cs?.posts.length, map: new Map((cs?.posts || []).map(x => [m.keyOf(x), x])) }; }
    ctx._bsCache[ck] = cmaps;
    }
    out.content = Object.fromEntries(Object.entries(cmaps).map(([k, v]) => [k, { n: v.n, H: v.H }]));
    out.nav = (await m.gotoBrandSetsContent(p)).url; await m.waitPosts(p, 120000);
    const cur2 = await p.evaluate(() => document.querySelector('.brand-selector-name')?.innerText.trim());
    out.bs = cur2 === o.brandSet ? { ok: true, brand: cur2 } : await m.setBrand(p, o.brandSet);
    out.rank = await m.setDSNth(p, o.rank, o.rankNth);
    out.filter = await m.contentBrandFilter(p, o.contentBrand);
    if (o.filteredRankMode) { const fr = p.getByText('Filtered', { exact: true }).first(); if (await fr.count()) { await fr.click(); await p.waitForTimeout(2000); } }
    out.cmp = {};
    for (const ch of o.channels) {
      const chs = await m.setChannels(p, [ch]); await m.tableViewSlow(p);
      const s = await m.scrapeStable(p);
      const re = (o.domainRes || {})[ch];
      const rows = (s?.posts || []).map(x => ({ k: m.keyOf(x), v: x[o.rank] })).filter(x => !re || re.test(x.k));
      let matched = 0, mism = [], missing = [];
      for (const r of rows) { const c = cmaps[ch].map.get(r.k); if (!c) { missing.push(r.k.slice(-30)); continue; } matched++; if (toNum(r.v) !== toNum(c[o.col])) mism.push({ k: r.k.slice(-30), bs: r.v, content: c[o.col] }); }
      out.cmp[ch] = { enabled: chs.enabled, rank: (p.url().match(/rank_by_metric=[^&]+/) || [])[0], H: s?.H, bsRows: rows.length, contentRows: cmaps[ch].n, matched, missing: missing.length, missingSample: missing.slice(0, 4), mismatches: mism.length, sample: mism.slice(0, 6), top: rows[0] };
    }
    return out;
  };

  // ---------- Brand > Paid ----------
  m.gotoPaid = async (p) => { const u = await m.navLink(p, 'Brand', 'Paid'); for (let i = 0; i < 20; i++) { await p.waitForTimeout(4000); const l = await p.evaluate(() => /Loading/.test(document.body.innerText)); if (!l) break; } return u; };
  m.paidBig = (p) => p.evaluate(() => { const o = {}; for (const t of [...document.querySelectorAll('.tile')].filter(e => e.offsetParent !== null)) { const head = t.innerText.split('\n')[0]; const c = t.querySelector('.count[title]'); if (c && /:/.test(head)) o[head.split(':')[0].trim()] = c.getAttribute('title'); const c2 = t.querySelectorAll('.count[title]')[1]; if (c2) { const h2 = (t.innerText.split('\n').find(l => /^(CTR|Paid Action Rate|[A-Z][^:]+):/.test(l) && l !== head) || '').split(':')[0].trim(); if (h2) o[h2] = c2.getAttribute('title'); } } return { url: location.href.replace(/^.*\?/, ''), big: o }; });

  // ---------- Reporting > Time Window Comparison ----------
  m.twcAddBrand = async (p, name) => {
    const inp = p.locator('input.al-typeahead__text-input').first();
    await inp.click();
    await p.evaluate((name) => { const el = document.querySelector('input.al-typeahead__text-input'); const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set; setter.call(el, name); el.dispatchEvent(new InputEvent('input', { bubbles: true, inputType: 'insertText', data: name })); }, name);
    await p.waitForTimeout(3000);
    const opts = await p.locator('.al-typeahead__option').allInnerTexts();
    const idx = opts.findIndex(t => t.trim() === name);
    if (idx < 0) return { ok: false, opts: opts.slice(0, 8) };
    // real mouse click (locator.click() left the dropdown open, 2026-10-26); the first click is sometimes swallowed
    // while the list re-renders, so verify the brand row and retry up to 3× (2026-10-27)
    const added = () => p.evaluate((name) => [...document.querySelectorAll('table tbody tr')].some(x => x.innerText.includes(name) && /View:/.test(x.innerText)), name);
    for (let i = 0; i < 3 && !(await added()); i++) { await p.waitForTimeout(1500); const bb = await p.locator('.al-typeahead__option').nth(idx).boundingBox().catch(() => null); if (!bb) break; await p.mouse.click(bb.x + bb.width / 2, bb.y + bb.height / 2); await p.waitForTimeout(3000); }
    if (!(await added())) return { ok: false, why: 'option click not applied', opts: opts.slice(0, 5) };
    return { ok: true, rows: await p.evaluate(() => [...document.querySelectorAll('table tbody tr')].map(r => r.innerText.trim().replace(/\s+/g, ' ')).filter(t => t).slice(0, 3)) };
  };
  m.twcPick = async (p, filterText, wantPaths) => {
    const f = p.locator('#filter-metrics-search-bar'); await f.scrollIntoViewIfNeeded(); await f.click(); await f.fill(''); await f.pressSequentially(filterText, { delay: 40 }); await p.waitForTimeout(2500);
    const res = [];
    for (const path of wantPaths) {
      const h = await p.evaluateHandle((path) => { const leaves = [...document.querySelectorAll('.controlled-check-box__label')].filter(e => e.offsetParent !== null); for (const e of leaves) { const chain = []; let n = e.closest('details'); while (n) { const s = n.querySelector(':scope > summary'); if (s) chain.unshift(s.innerText.trim().split('\n')[0].replace(/\s*\(.*$/, '')); n = n.parentElement?.closest('details'); } if (chain.join(' › ') + ' › ' + e.innerText.trim() === path) return e; } return null; }, path);
      const el = h.asElement(); if (!el) { res.push({ path, ok: false }); continue; }
      await el.scrollIntoViewIfNeeded(); const bb = await el.boundingBox(); await p.mouse.click(bb.x + bb.width / 2, bb.y + bb.height / 2); await p.waitForTimeout(400);
      const checked = await el.evaluate(e => { const cb = e.parentElement.querySelector('[role=checkbox], input[type=checkbox]'); return cb ? (cb.getAttribute('aria-checked') ?? String(cb.checked)) : null; });
      res.push({ path, ok: true, checked });
    }
    return res;
  };
  m.twcNavCalendar = async (p, which, monthLabel) => {
    for (let i = 0; i < 40; i++) { const hdr = await p.evaluate((w) => (document.querySelector('.' + w + ' th.datepicker-switch, .' + w + ' .datepicker-switch') || {}).innerText?.trim().toUpperCase(), which); if (hdr === monthLabel) return hdr; const prev = p.locator('.' + which + ' th.prev').first(); await prev.scrollIntoViewIfNeeded(); await prev.click(); await p.waitForTimeout(150); }
    return 'not reached';
  };
  // o = {brand, authorized, fromDay, toDay, fromMonth?: 'JANUARY 2025', toMonth?, picks: [[filterText, [paths]]]}
  m.twcBuild = async (p, o) => {
    const r = {};
    await m.navLink(p, 'Reporting', 'Time Window Comparison');
    await p.waitForTimeout(6000); await p.mouse.move(700, 450); await p.waitForTimeout(500);
    r.brand = await m.twcAddBrand(p, o.brand);
    await p.mouse.move(700, 450);
    const lab = p.locator('label[for="0-perspective-toggle"]').first();
    const checked = await p.evaluate(() => document.querySelector('#\\30 -perspective-toggle')?.checked);
    if (o.authorized && !checked) { await lab.scrollIntoViewIfNeeded(); await lab.click({ force: true }); await p.waitForTimeout(500); }
    r.persp = await p.evaluate(() => document.querySelector('#\\30 -perspective-toggle')?.checked);
    const hdr = p.getByText('Select a Date Range', { exact: true }).first(); await hdr.scrollIntoViewIfNeeded(); await hdr.click(); await p.waitForTimeout(500);
    const box = p.locator('.lfm-dropdown-select-box').filter({ visible: true }).filter({ hasText: /^Days$/ }).first();
    await box.scrollIntoViewIfNeeded(); await box.click(); await p.waitForTimeout(600);
    await p.locator('.lfm-dropdown-option').filter({ visible: true }).filter({ hasText: /^Aggregate$/ }).first().click(); await p.waitForTimeout(800);
    r.interval = await p.evaluate(() => (document.body.innerText.match(/Interval\n([^\n]+)/) || [])[1]);
    if (o.fromMonth) r.fromNav = await m.twcNavCalendar(p, 'from-calendar', o.fromMonth);
    const fc = p.locator('.from-calendar td.day:not(.old):not(.new)').filter({ hasText: new RegExp('^' + o.fromDay + '$') }).first(); await fc.scrollIntoViewIfNeeded(); await fc.click(); await p.waitForTimeout(400);
    if (o.toMonth) r.toNav = await m.twcNavCalendar(p, 'to-calendar', o.toMonth);
    const tc = p.locator('.to-calendar td.day:not(.old):not(.new)').filter({ hasText: new RegExp('^' + o.toDay + '$') }).first(); await tc.scrollIntoViewIfNeeded(); await tc.click(); await p.waitForTimeout(800);
    r.dates = await p.evaluate(() => ({ start: document.querySelector('.from-calendar td.range-start')?.innerText, end: document.querySelector('.to-calendar td.range-end')?.innerText, fromHdr: document.querySelector('.from-calendar .datepicker-switch')?.innerText, toHdr: document.querySelector('.to-calendar .datepicker-switch')?.innerText }));
    const bc = p.getByText('By Channel', { exact: true }).first(); await bc.scrollIntoViewIfNeeded(); await bc.click(); await p.waitForTimeout(1500);
    r.picked = [];
    for (const [filterText, paths] of o.picks) { r.picked.push(...await m.twcPick(p, filterText, paths)); }
    const g = p.locator('.controlled-check-box__label').filter({ hasText: /^Show Metrics Graphs$/ }).first();
    await g.scrollIntoViewIfNeeded();
    const gchk = await g.evaluate(e => { const cb = e.parentElement.querySelector('[role=checkbox], input[type=checkbox]'); return cb ? (cb.getAttribute('aria-checked') ?? String(cb.checked)) : null; });
    if (gchk === 'true') { await g.click(); await p.waitForTimeout(500); }
    // wait for the story URL (builder tables would otherwise satisfy a table-count check), then for the loading text to clear;
    // the first Run click is sometimes ignored (2026-10-26) → click again once
    for (let k = 0; k < 2 && !/#story\//.test(p.url()); k++) { const run = p.getByRole('button', { name: /Run Report/i }).first(); await run.scrollIntoViewIfNeeded(); await run.click(); for (let i = 0; i < 20; i++) { await p.waitForTimeout(4000); if (/#story\//.test(p.url()) && !(await p.evaluate(() => /Loading|Generating/i.test(document.body.innerText)))) break; } }
    await p.waitForTimeout(3000);
    r.url = p.url();
    r.tables = await p.evaluate(() => [...document.querySelectorAll('table')].filter(t => t.offsetParent !== null).map(t => ({ rows: [...t.querySelectorAll('tr')].map(r => [...r.querySelectorAll('th,td')].map(c => c.innerText.trim())).slice(0, 3) })).slice(0, 16));
    return r;
  };

  // ---------- Settings ----------
  m.navSettings = async (p, item) => {
    const hdr = p.locator('.navigation-controls .navigation-menu-header, .navigation-menus .navigation-menu-header-label').filter({ hasText: /^Settings$/ }).first();
    await hdr.hover(); await p.waitForTimeout(800);
    await p.locator('a.navigation-menu-link').filter({ visible: true }).filter({ hasText: new RegExp('^' + item + '$') }).first().click();
    await p.waitForTimeout(6000); await p.mouse.move(700, 450);
    return p.url();
  };
  // Settings > Data Collection: pick brand (dispatched click on the typeahead option), channel row, first page row → feeds.
  m.dataCollection = async (p, brand, channelRe) => {
    const out = { url: await m.navSettings(p, 'Data Collection') };
    let st; for (let i = 0; i < 25; i++) { await p.waitForTimeout(3000); st = await p.evaluate(() => ({ loading: /\nLoading\n|Loading\.\.\./.test(document.body.innerText), brands: document.querySelectorAll('.brand-row').length })); if (!st.loading && st.brands) break; }
    const ta = p.locator('textarea.brand-filter-typeahead').first(); await ta.hover(); await ta.click(); await ta.pressSequentially(brand, { delay: 70 }); await p.waitForTimeout(2500);
    out.clicked = await p.evaluate((brand) => { const o = [...document.querySelectorAll('.lfm-ta-option')].find(e => e.offsetParent !== null && e.getAttribute('title') === brand); if (!o) return 'no option'; for (const t of ['mouseover', 'mousedown', 'mouseup', 'click']) o.dispatchEvent(new MouseEvent(t, { bubbles: true, cancelable: true })); return 'dispatched'; }, brand);
    await p.waitForTimeout(5000);
    await p.locator('.channel-row').filter({ hasText: channelRe }).first().click();
    for (let i = 0; i < 10; i++) { await p.waitForTimeout(2500); const n = await p.evaluate(() => document.querySelectorAll('.page-row').length); if (n) break; }
    out.pages = await p.evaluate(() => [...document.querySelectorAll('.page-row')].filter(e => e.offsetParent !== null).map(e => e.innerText.trim().replace(/\n/g, ' | ')));
    if (out.pages.length) { await p.locator('.page-row').first().click(); for (let i = 0; i < 10; i++) { await p.waitForTimeout(2500); const n = await p.evaluate(() => document.querySelectorAll('.data-sources-row').length); if (n) break; } }
    Object.assign(out, await p.evaluate(() => { const t = document.body.innerText.replace(/\n{2,}/g, '\n'); const i = t.indexOf('Data Collection Summary'); return { feeds: [...document.querySelectorAll('.data-sources-row')].filter(e => e.offsetParent !== null).map(e => e.innerText.trim().replace(/\t/g, ' ¦ ').replace(/\n/g, ' | ').slice(0, 200)), summary: i >= 0 ? t.slice(i, i + 1200) : null, lastLines: [...t.matchAll(/[^\n]*Last[^\n]*\n[^\n]*/gi)].map(x => x[0].replace(/\n/g, ' ⏎ ')).slice(0, 8) }; }));
    return out;
  };

  // ---------- LFM vs Native ----------
  m.nativeFirst = async (p, channel, nth = 0) => {
    const r = { channel }; const ch = await m.setChannels(p, [channel]); r.posts = ch.posts;
    let hasCards = await p.evaluate(() => document.querySelectorAll('.image-card').length);
    if (!hasCards) { const g = p.locator('[title="Grid View"], [title*="Grid"]').first(); if (await g.count()) { await g.click(); await p.waitForTimeout(4000); } hasCards = await p.evaluate(() => document.querySelectorAll('.image-card').length); }
    r.cards = hasCards; if (!hasCards) return r;
    r.first = await p.evaluate((nth) => { const c = document.querySelectorAll('.image-card')[nth]; const t = c.innerText.trim(); const kv = {}; const lines = t.split('\n').map(s => s.trim()).filter(Boolean); for (let i = 0; i < lines.length - 1; i++) { if (/^(Engagements|Reactions|Comments|Shares|Likes|Video Views|Views|Response Rate)$/.test(lines[i]) && /[\d,.%KM–-]/.test(lines[i + 1])) kv[lines[i]] = lines[i + 1]; } return { text: t.slice(0, 220).replace(/\n/g, ' | '), kv, links: [...c.querySelectorAll('a')].map(a => a.href) }; }, nth);
    const popupP = p.context().waitForEvent('page', { timeout: 20000 }).catch(() => null);
    await p.locator('.image-card .image-link').nth(nth).click();
    const popup = await popupP; if (!popup) { r.native = { err: 'no popup' }; return r; }
    await popup.waitForLoadState('domcontentloaded').catch(() => null); await popup.waitForTimeout(8000);
    r.native = await popup.evaluate(() => ({ url: location.href, title: document.title, meta: (document.querySelector('meta[name="description"]')?.getAttribute('content') || '').slice(0, 250), like: document.querySelector('[aria-label*="like this video"]')?.getAttribute('aria-label'), txt: document.body.innerText.slice(0, 400).replace(/\n+/g, ' | ') })).catch(e => ({ err: String(e).slice(0, 150), url: popup.url() }));
    if (/youtube\.com\/watch/.test(r.native.url || '')) { await popup.mouse.wheel(0, 1200); await popup.waitForTimeout(5000); r.native.commentsCount = await popup.evaluate(() => document.querySelector('#comments #count')?.innerText || null).catch(() => null); r.native.like = await popup.evaluate(() => document.querySelector('[aria-label*="like this video"]')?.getAttribute('aria-label') || null).catch(() => null); }
    await popup.close().catch(() => null); return r;
  };

  // ---------- Brand > Stories ----------
  m.storiesList = async (p) => {
    let st = await p.evaluate(() => ({ stories: (document.body.innerText.match(/Stories \((\d+)\)/) || [])[1], tv: !!document.querySelector('[title="Table View"]') }));
    if (!st.tv) { const dv = p.getByText('Data Visualization', { exact: true }).first(); if (await dv.count()) { await dv.click(); await p.waitForTimeout(6000); } st = await p.evaluate(() => ({ stories: (document.body.innerText.match(/Stories \((\d+)\)/) || [])[1], tv: !!document.querySelector('[title="Table View"]'), toggled: true })); }
    return st;
  };

  return { installed: Object.keys(m).length };
}
