# QA-531 — Brand > Content - Facebook - CSV for Unauthorized Brand

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-531
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Browser:** Regression Testing
- **Account:** Adam Orfei (account_id 54)
- **Brand:** Star Wars (brand_id 75007)
- **Date range:** May 11, 2026 – May 17, 2026 (Last 7 Days)
- **Channels:** Facebook only

## Result

**PASS (6/7), 1 BUG candidate.**

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (step 5) | CSV default in view toggle | Export dialog opens with `View: [CSV] / Google Sheets` toggle defaulting to CSV (toggle dot on left). | ✅ |
| A2 (step 7a) | Filename `Brand-Content-YYYYMMDD-YYYYMMDD-posts.csv` | Server delivers file as `290891-1cf67c943fca0bb956460b27440d6537.csv` with **no `Content-Disposition` header**, so the browser uses the URL's last path segment as the saved filename — does **not** match the spec format. | ❌ **Bug candidate** |
| A3 (step 7b) | En-dash UI values export as blank cells | Confirmed: no `–` (U+2013) or `—` (U+2014) characters in CSV. UI-blanks render as empty quoted strings (e.g. `""` for missing Video Views), which is correct CSV blank-cell behaviour. | ✅ |
| A4 (step 7c) | All export metrics match page data | Spot-checked rows 1 and 33 — Engagements, Reactions, Comments, Shares values, channel, and post URL all match the in-page grid. Sum row (page) = E:299,417 R:281,481 C:3,713 S:14,223; CSV per-post values reconcile. | ✅ |
| A5 (step 7d) | Date format `MM/(D)D/YYYY` | All 35 rows formatted as `MM/DD/YYYY` (e.g. `05/16/2026`, `05/11/2026`, `05/17/2026`). | ✅ |
| A6 (step 7e) | Day of Week format `DOW` | All rows use 3-letter abbreviation (`Mon`, `Sat`, `Sun`, `Thu`, etc.). | ✅ |
| A7 (step 7f) | Time format `HH:MM XM` | All rows use 12-hour `HH:MM AM/PM` format (e.g. `11:43 PM`, `03:20 PM`, `07:01 AM`). | ✅ |

## Proof — CSV header row

```
Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Reactions,Comments,Shares,Response Rate,Video Views,Video Response Rate
```

## Proof — Row 1 (post-level data)

```
1,05/16/2026,Sat,11:43 PM,Facebook,Star Wars,https://www.facebook.com/StarWars,Video,https://www.facebook.com/169299103121699_1523613812466064,"",Original Post,"","","","","","",Pedro Pascal creates the surprise of a lifetime at Star Wars: Galaxy's Edge at Disneyland… ,"66,743","62,410",949,"3,384",0.0035289905119153904,"1,397,841",0.0477472044388453
```

Verifies A5 (`05/16/2026`), A6 (`Sat`), A7 (`11:43 PM`) in one row.

## Proof — Row 33 (blanks for missing data)

```
33,05/17/2026,Sun,06:07 PM,Facebook,Star Wars,...,"Pedro Pascal, Sigourney Weaver, …",926,842,14,70,4.8955974199038505e-05,"",""
```

Trailing `"",""` are the Video Views + Video Response Rate columns — the UI renders these as en-dash for this row; CSV renders them as empty quoted strings. ✅ A3.

## Bug — A2 filename pattern

**Repro:**

1. Trigger CSV export from Brand → Content for any brand (here, Star Wars on FB).
2. Wait for the "Select Data Sets Export" notification (bell icon).
3. Click `Download file`.

**Expected:** Saved file is named `Brand-Content-20260511-20260517-posts.csv` (per spec A2).

**Actual:** Saved file is named `290891-1cf67c943fca0bb956460b27440d6537.csv`.

**Root cause:** The download URL is `https://analytics-cdn.lfmdev.in/290891-1cf67c943fca0bb956460b27440d6537.csv` with `download=""` on the anchor (i.e. no client-side filename override). Response headers from the CDN are:

```
content-length: 16032
content-type: binary/octet-stream
etag: "e531d17e006b5e9471d99f0bddb1fa97"
last-modified: Mon, 18 May 2026 14:47:27 GMT
```

There is **no `Content-Disposition: attachment; filename="…"` header**, and **no `download` attribute value**, so the browser falls back to the URL's last path segment — the internal CDN hash.

Two ways to fix:
1. Server-side: emit `Content-Disposition: attachment; filename="Brand-Content-20260511-20260517-posts.csv"` from the CDN object metadata.
2. Client-side: set `download="Brand-Content-20260511-20260517-posts.csv"` on the anchor element rendered in the notification.

Severity: **Medium** — the data is correct; only the filename is wrong. End users will get an opaque hash filename instead of the documented friendly name, which makes spreadsheet organization painful.

## CSV saved to disk

The exported CSV body has been saved to `runs/2026-05-13/QA-531-Star-Wars-export.csv` (16 KB, 38 lines = 1 dataset header + 1 column header + 35 posts + trailing newline).
