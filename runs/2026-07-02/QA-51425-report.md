# QA-51425 — Duplicate Brands and Social Pages Report on Radaac

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-51425 · Priority: Blocker
- **Result:** **PASS** — popup message, CSV filename, and column set all verified.
- **App:** Dev Radaac (`radaac.lfmdev.in`)
- **Skills:** radaac-report (v1)

## Linked bug scan
No open/unresolved linked bugs (all Closed) — [[open-bug-auto-fail]] N/A. (APPS-47752 "Export failed to download" is Closed; not reproduced — export downloaded fine.)

## Steps executed
1. Radaac list → opened **Duplicate Brands and Social Pages** (#16). ✅
2. Popup opened with the description message. ✅
3–4. **File Format** `<select>` (tsv/csv/xls) → **csv**. ✅
5. **Submit** → `/duplicate_brand_social_pages?file_format=csv`, page title "File is Ready", CSV downloaded. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A2 popup | "The report will pull a list of all brands in the platform that have one of the same social pages associated to multiple brands (Facebook, Twitter, Instagram). This pull should exclude brands with the same name (public and extended)" | **Verbatim match** | ✅ PASS |
| A5 download | CSV downloads after a few seconds | Downloaded (server filename `20260703DuplicateBrandSocialPages_8b0b04.csv`) | ✅ PASS |
| A5 filename | `YYYYMMDDDuplicateBrandSocialPages_<hash>.csv` | `20260703DuplicateBrandSocialPages_8b0b04.csv` — date + name + **underscore** + hash `8b0b04` + `.csv` ✓ (hash per-run) | ✅ PASS |
| A5 columns | Brand ID, Brand Name, Title Category, Channel, Url, Perspective (with data) | Header `brand id,brand name,title category,channel,url,perspective`; 15,198 data rows | ✅ PASS |
| A5 no duplicate col | "duplicate" column should NOT display | Only the 6 columns above — no duplicate column | ✅ PASS |

## Evidence
- `.playwright-out/20260703DuplicateBrandSocialPages-8b0b04.csv` (saved with `-`; server name uses `_` — see note). Sample rows: `101834,James Bond 007 - DAR,Movies,instagram,007,Standard` / `95175,No Time to Die,Movies,instagram,007,Extended` (two differently-named brands sharing IG page "007" — a legit duplicate; same-name pairs excluded per spec).

## Notes / findings
- **Filename separator is an underscore on the server** (`..._8b0b04.csv`), matching the spec. The Playwright MCP **sanitizes `_`→`-` in the local saved path** (`...-8b0b04.csv`) — a download-tool artifact, not app behavior. **This corrects the QA-43916 report's "dash vs underscore" note** (that too was the local-save artifact; the Radaac server filenames use underscore as specified). radaac-report skill updated accordingly.

## Bugs filed
None. All assertions passed.
