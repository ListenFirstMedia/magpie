# QA-48160 — Settings > Brands - Basic Info - Edit Functionality

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Account:** Adam Orfei (account_id=54) — the active account at login
- **Brand under test:** Alex Test 1 (brand_id=422865, Industry: Movies, channels: Twitter + YouTube) — a low-stakes editable test brand on the active account
- **Skill reused:** none as a dedicated `SKILL.md` (settings-brands-edit is a candidate; no file on disk). Flow reconstructed from the 2026-06-04 QA-4325 batch-4 run pattern (Edit wizard: Basic Info → Channels → Review → Finish).
- **Verdict:** **PASS** (5/5 assertions, incl. optional A5 sub-flow)

## Steps executed

1. Pre-flight: programmatic login as `lfiqa@listenfirstmedia.com` via the Cognito "With existing account" form → `#home` rendered (Adam Orfei, account_id=54).
2. Settings menu → **Brands** (`#brands`); title "Settings Brands". Searched "Alex Test" → row **Alex Test 1** (brand_id=422865) present. **(A1)**
3. Row Actions → **Edit** → Edit wizard `#brands/edit?step=1`. Basic Info step exposed **Brand Name** (`Alex Test 1`), **Industry** (Movies), IMDb Code, Studio Type, Release, Genre, etc. **(A2)**
4. Set **Brand Name** = `Alex Test 1 qa-48160-rerun-2026-07-11-1218` via `.fill()` (React value confirmed committed by reading `input.value`).
5. Next → Channels (existing YouTube channel intact) → Next → Review (Basic Info + Channels "Complete") → **Finish**. Reached `step=4` success page: **"Nice work! You've successfully updated your brand."** (evidence: `01-save-success.png`).
6. Navigated back to `#brands`, searched "qa-48160-rerun" → brand **row now displays** `Alex Test 1 qa-48160-rerun-2026-07-11-1218` (brand_id unchanged 422865). Re-opened Edit → Brand Name field **shows the persisted new value** `Alex Test 1 qa-48160-rerun-2026-07-11-1218`. **(A3)**
7. **Cleanup (NON-OPTIONAL):** In the re-opened Edit session set Brand Name back to `Alex Test 1` → Next → Next → Finish (success). Back on `#brands`, searched "Alex Test" → row restored to **`Alex Test 1`** (no suffix), Industry Movies, 2 channels intact (evidence: `02-revert-verified.png`). **(A4)**
8. **Optional A5 sub-flow (APPS-59449):** Re-opened Edit → Channels step → **Add Channel** → selected **Instagram** → typed invalid handle `bad handle!!!###$$$`.
   - **While the field was focused:** DOM probe found **no visible validation error** (`visibleErrors: []`).
   - **After blur (Tab):** error `channel-tile__error` appeared — *"Heads up! Looks like there's an issue with the url you entered. Make sure you enter a valid url."* (evidence: `03-invalid-handle-error-on-blur.png`).
   - Confirms APPS-59449's documented gap (validation fires on blur, not while typing). **Cancelled** the wizard so the test channel did **not** persist; re-verified the brand still has exactly 2 channels (Twitter + YouTube) and name `Alex Test 1`. **(A5)**

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1–2 | Settings > Brands list loads with the editable Brand row | List loaded (title "Settings Brands"); `Alex Test 1` (brand_id=422865) row present with Industry/Channels/Actions | PASS |
| A2 | 3 | Edit page opens and exposes Basic Info fields (Brand Name, Industry, etc.) | Edit wizard step=1 showed Brand Name (`Alex Test 1`), Industry (Movies), IMDb Code, Studio Type, Release, Studio, Genres, Primary Genre | PASS |
| A3 | 4–6 | Valid edit saves without errors; new value displays on row and in modal on re-open | Saved → success page; row shows `Alex Test 1 qa-48160-rerun-2026-07-11-1218`; re-opened modal shows same value | PASS |
| A4 | 7 | After cleanup revert, original value fully restored | Reverted to `Alex Test 1`; row + channels (2: Twitter, YouTube) restored, brand_id 422865 unchanged | PASS |
| A5 | 8 | Invalid channel handle does not flag an error until the field loses focus (APPS-59449 gap; do not file) | Focused = no error; on blur = `channel-tile__error` "…enter a valid url." appeared | PASS |

## Known bugs checked

- **bug-history.md (grep QA-48160):** 1 open linked bug — **APPS-59449** (Bug, Minor, Open) "Settings Brands channel validation timing — channel validation error does not appear until field loses focus." This is the **expected** behavior for the optional A5 sub-flow; the spec explicitly says to confirm it and **not** file it as new. It does **not** interfere with the primary assertions A1–A4, so per the open-bug-interference rule the case was **run** (not auto-failed).
- **A5 outcome:** APPS-59449 **reproduced exactly** (error suppressed while focused, shown on blur). Not a regression, not filed.
- No other linked/related bugs found for this surface.

## Bugs filed

None. (APPS-59449 reproduced as documented — intentionally not filed per spec.)

## Evidence (`.playwright-out/QA-48160/`)

- `01-save-success.png` — "Nice work! You've successfully updated your brand." after the valid edit
- `02-revert-verified.png` — brands list showing `Alex Test 1` restored after cleanup
- `03-invalid-handle-error-on-blur.png` — invalid Instagram handle error shown after blur (APPS-59449)

## Notes / Playwright-track findings

- The Edit Brand Name input is React-controlled; under Playwright a plain `.fill()` **committed reliably** (verified via `input.value` read). The 2026-06-04 Chrome-MCP note about needing a React `value`-setter + dispatch is **obsolete** on this track.
- Mutation was fully reverted; the A5 test channel was discarded via **Cancel** (never saved), so no cleanup residue remains.
