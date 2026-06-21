# QA-52778 — Brand definition update - Include URL Manager — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** #1 Happy Family USA (383037, Film Studio)
- **Skills:** settings-brands-edit
- **Result:** ✅ PASS

## Steps
1. Settings → Brands → Actions (⋯) on **#1 Happy Family USA** → **Edit**.
2. Edit wizard: **Basic Info** (Brand Name + Industry prefilled) → **Next** → **Channels** step (`#brands/edit?step=2`).
3. Channels step = the **URL Manager**: each existing channel rendered as a row with a **channel-type dropdown**, an **editable URL field**, (for YouTube) a handle + optional channel-filter field, and a per-row **Remove** link. Existing channels: YouTube (`youtube.com/user/amazonstudios`), Wikipedia ×2, IMDb, Metacritic.
4. Clicked **Add Channel** → a new empty **"Select a Channel"** row appended at top (with Remove).
5. **Cancel** → returned to Brands listing. **No save — no mutation.**

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| URL Manager present in brand definition update | Edit flow includes a channel/URL manager | Channels step renders the URL Manager (type + URL + filter per channel) | ✅ |
| Add Channel | Adds a new editable channel row | New "Select a Channel" row added | ✅ |
| Edit/Remove URLs | URLs editable, per-row Remove present | Editable URL fields + Remove links on every row | ✅ |
| Non-destructive cancel | Cancel discards without saving | Cancelled clean; brand list reloaded unchanged | ✅ |

## Notes / automation learning
- The "URL Manager" referenced by this case **is the Channels step of the Edit Brand wizard** (helper text: "you can add as many channels as you need… click the 'Add Channel' button"). Add/Remove/type-select/URL-edit all functional.
- Mutating surface handled safely: only added a row in-memory and **cancelled** (no brand definition was saved).

## Bugs filed
_None._
