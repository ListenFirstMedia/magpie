# QA-110071 — Brand > Audience - Threads - Metrics Export

> **Status:** 🟡 Steps executed; assertions deferred to manual Downloads verification
> **Run date:** 2026-05-13 (session continued through 2026-05-17 per Data Last Updated stamp)
> **Env:** dev · **Browser:** Regression Testing · **Account:** Adam Orfei · **User:** LFQA (LFIQA)

## Execution

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Brand → Audience | ✅ |
| 2 | MTV brand (already loaded as Adam Orfei's default) | ✅ |
| 3 | Threads-only, Mar 16 – Mar 22, 2025 | ✅ (Apply confirmed via channel-ghost state: facebook=OFF, threads=ON) |
| 4 | Export → Metrics | ⚠ click registered (Mixpanel telemetry fired) but no file captured by Blob / anchor-download / window.open / form.submit hooks |

## Assertions

| ID | Description | Status |
|---:|-------------|:------:|
| A1 | Filename = `Brand-Audience-Metrics` | ⏸ **DEFERRED** — please verify the file in Downloads |
| A2 | Headers = `Display Name`, `Key` | ⏸ **DEFERRED** — open the downloaded file and confirm the header row |

## Finding

### ⚠ F1 — Metrics export bypasses standard download interception

The Audience tab's Export → Metrics option appears to download a file via a mechanism that isn't `URL.createObjectURL` + anchor.click (the path CSV/Google-Sheets/normal CSV use). My hooks across `URL.createObjectURL`, `HTMLAnchorElement.prototype.click` (with `download` attr), `window.open`, and `HTMLFormElement.prototype.submit` captured nothing. Only telemetry pings to mixpanel/new-relic fired.

Possibilities (in order of likelihood):
1. The export uses `fetch(...)` then triggers download via `Response.blob()` and a different download mechanism (e.g., FileSystem API).
2. The export silently failed (no UI feedback either way).
3. The export downloaded to your Downloads folder normally and my hook installation order missed it.

**Recommendation:** Check your Downloads folder for a recent `Brand-Audience-Metrics.csv` (or similar) file. If present, the export works and the case passes pending manual header verification. If absent, this is a real bug — the click registers but no file is produced.

## Note

This case is marked "Not Recommended for Automation" in Jira (priority Minor). The skill `audience-metrics-export` documents the download capture limitation so future automation attempts know to look in the user's Downloads folder rather than relying on Blob interception.
