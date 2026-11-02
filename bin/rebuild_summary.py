#!/usr/bin/env python3
"""Rebuild results/<date>/summary.json + results.tsv from every QA-*-report.md in the folder
(unattended batch reports + interactive reports), and print a per-set breakdown.
Usage: python3 bin/rebuild_summary.py [YYYY-MM-DD]"""
import json, re, os, sys, glob, datetime
DATE = sys.argv[1] if len(sys.argv) > 1 else datetime.date.today().isoformat()
D = f"results/{DATE}"
sets = {}
for f in glob.glob("batches/qa-2*.txt"):
    name = os.path.basename(f)[:-4].upper()
    if name.endswith("-RUNA") or name.endswith("-RUNB") or name.endswith("-DEVONLY"): continue
    sets[name] = [l.strip() for l in open(f) if l.strip().startswith("QA-")]
rows = {}
for p in sorted(glob.glob(f"{D}/QA-*-report.md")):
    key = os.path.basename(p).split("-report")[0]
    s = open(p).read()
    m = re.search(r"Verdict:[\s*]*([A-Z]+)", s)
    v = m.group(1) if m else "UNKNOWN"
    if v == "FAILED": v = "FAIL"
    rows[key] = (v, p)
with open(f"{D}/results.tsv", "w") as fh:
    for k, (v, p) in rows.items(): fh.write(f"{k}\t{v}\t{p}\n")
counts = {}
for v, _ in rows.values(): counts[v] = counts.get(v, 0) + 1
summary = {"date": DATE, "total": len(rows), "counts": counts, "cases": {k: v for k, (v, _) in rows.items()}}
json.dump(summary, open(f"{D}/summary.json", "w"), indent=1)
print("ALL:", len(rows), counts)
for name, keys in sorted(sets.items()):
    c = {}
    for k in keys:
        v = rows.get(k, ("NOT RUN", None))[0]
        c[v] = c.get(v, 0) + 1
    print(name, len(keys), c)
