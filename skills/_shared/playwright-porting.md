# Playwright MCP porting conventions

How to convert a skill written for **Chrome MCP** (the `staging/lf-regression` line) into one that runs on **Playwright MCP** (the `feature/playwright-mcp` branch). Claude is still the executor/judge — only the browser-driving tool calls change.

Port skills **lazily**: one at a time, only when you're about to run that flow. An unported skill keeps its Chrome-MCP steps and simply isn't run on this branch yet. Never break a working skill speculatively.

## General principles

1. **Prefer locators over coordinates.** Target elements by role/text/CSS, not pixels. Playwright resolves the element and clicks its center, so layout shifts don't break the click.
2. **Lean on auto-waiting.** Playwright waits for visible + stable + enabled before acting. Delete fixed `sleep`s; use `wait_for` on a real element instead.
3. **Real events first, JS hacks second.** Try `.click()` / `.fill()` / `.hover()` before reaching for `evaluate()` + synthetic events. Many Chrome-MCP workarounds existed only because coordinate/synthetic input was unreliable.
4. **`evaluate()` is still available** for the genuinely in-page work (CDN `fetch` with credentials, xlsx parsing, RGB reads).
5. **Mutating skills need encoded cleanup** (see bottom) — no human watches headless runs.

## Mechanic translation table

| Chrome-MCP mechanic (magpie) | Playwright equivalent | Difficulty | Notes |
|---|---|---|---|
| Coordinate `left_click [x,y]` / `hover [x,y]` | `locator(sel).click()` / `.hover()` | Low | Prefer a selector; use `.click({position})` only for canvas ghosts |
| `left_click_drag from→to` (tag-modal-drag) | `locator(src).dragTo(dst)` | Low | |
| React `value`-setter + `dispatchEvent('input')` (TWC, dashboard-mutation-flows, settings-custom-metrics, social-recap brand+name inputs) | Try `.fill()` first (fires React handlers); fallback `locator.evaluate(el => {setter; dispatch})` | **High — fragile** | Validate React state actually updated after `.fill()`; CPR builder showed the JS-setter path can fail to surface typeahead results |
| `controlled-check-box` focus + Space `KeyboardEvent` (TWC Options, social-recap Options, CPR Options) | `locator.focus()` + `keyboard.press('Space')`; fallback `evaluate` focus+KeyboardEvent dispatch | **High** | This widget ignores `.click()` — do not assume a normal checkbox |
| Numeric React `<input>` triple_click+type+Tab (CPR) | `.fill(value)` + `.press('Tab')` to force onBlur | Medium | React reverts the value without the blur |
| Recharts synthetic `mouseover`+`mousemove` (chart-hover-tooltip, dpa-modal) | `.hover()` over the data point; if no tooltip, add `evaluate` synthetic `mouseover`+`mousemove` | Medium | Quantify in the spike whether `.hover()` alone works |
| `window.open` hook capturing Google Sheets URL (export-google-sheets) | `context.on('page')` / `page.on('popup')` then read `popup.url()` | **Out of scope** | Google Sheets export is **deferred** on this track — GS requires Google 2FA on a separate auth surface, impractical per-run. Skip GS steps/assertions; keep this popup technique only for non-Google popups |
| `createObjectURL` / anchor-click blob hook (export-csv, dpa-modal) | `page.on('download')` → `download.path()` / `download.saveAs()` | Medium | Native + simpler; satisfies Rule 6 directly |
| CDN queued export `fetch(url,{credentials:'include'})` (export-csv) | keep via `page.evaluate` (request must run in page context for cookies) | Low | Read filename from the Recent-Activity bell first, as today |
| Duplicate hidden datepicker `offsetParent` filter (TWC, data-studio-historical-limit) | filter to the visible one: `.isVisible()` / `locator(...).filter` before interacting | Low | Two `.datepicker-days` exist; acting on the hidden one silently no-ops |
| `computer.zoom` for tiny toggle indicator (view-perspective-toggle) | `page.evaluate(() => document.body.style.zoom=...)` or a screenshot crop | Low | Rarely needed |
| in-page xlsx parse (`DecompressionStream`) / `pdftoppm` PNG render (pdf-end-to-end-verification, social-recap, cpr) | keep the parsing/rasterizing; downloads arrive via `download.path()` | Medium (env dep) | Runner must have **poppler-utils** installed for `pdftoppm`/`pdfinfo` |
| `el.offsetParent !== null` visibility check | `locator.isVisible()` or `locator.boundingBox()` | Low | |
| `getBoundingClientRect()` | `locator.boundingBox()` | Low | |

## Spec-adherence rules under Playwright

The 6 rules in `_shared/spec-adherence-rules.md` still hold. Two get *easier*:

- **Rule 2 (click toggles, don't trust URL):** still click the toggle; use `wait_for` on the post-toggle data refresh instead of a fixed wait.
- **Rule 6 (verify real download):** `page.on('download')` + on-disk read IS the valid end-to-end verification — no more hook-vs-reality ambiguity.

## Mutating skills — cleanup is mandatory and must be encoded

`brand-content-tag-post`, `dashboard-mutation-flows`, `settings-custom-metrics`, `settings-custom-data-sets`, `brand-content-tag-modal-drag` create/delete data. Headless = no human to catch a half-finished mutation, so:

- Encode cleanup as the **last step that always runs** (treat it like try/finally — if the assertion phase fails, still attempt teardown).
- Reuse the confirm-modal pattern (`Are you absolutely sure you want to delete your <entity> '<name>'?` → Ok) and the **F5-verify** that the entity is gone.
- Use a unique timestamped identifier per run (e.g. `qa-<id>-pw-<date>-<time>`) so orphans, if any, are traceable.
