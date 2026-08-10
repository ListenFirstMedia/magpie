#!/usr/bin/env python3
"""Create an Xray Cloud Test Execution from a magpie run and import per-case results.

Reads results/<date>/summary.json, authenticates to Xray Cloud with client id/secret,
POSTs an import/execution payload (one entry per case), and prints the created execution
key (e.g. QA-123456) to STDOUT. All diagnostics go to STDERR so the caller can capture
the key cleanly:  XRAY_KEY=$(bin/xray_report.py results/2026-07-21/summary.json)

Env:
  XRAY_CLIENT_ID, XRAY_CLIENT_SECRET   (required)  Xray Cloud API key pair
  XRAY_BASE   (optional)  default https://xray.cloud.getxray.app
Args:
  1: path to summary.json
  2: (optional) summary text for the execution
  3: (optional) Xray Test Plan key to link the execution under (e.g. QA-4325)
"""
import json, os, sys, urllib.request, urllib.error
from datetime import datetime, timezone

def log(*a): print(*a, file=sys.stderr)

# magpie verdict -> Xray Cloud status. Adjust here if your Xray uses custom statuses.
STATUS_MAP = {"PASS": "PASSED", "FAIL": "FAILED", "BLOCKED": "FAILED",
              "TIMEOUT": "FAILED", "SKIPPED": "TODO", "UNKNOWN": "TODO"}

def post(url, data, headers):
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=60) as r:
        return r.read().decode()

def main():
    if len(sys.argv) < 2:
        log("usage: xray_report.py <summary.json> [summary_text] [test_plan_key]"); sys.exit(2)
    summary_path = sys.argv[1]
    summary_text = sys.argv[2] if len(sys.argv) > 2 else "magpie regression run"
    plan_key     = sys.argv[3] if len(sys.argv) > 3 else os.environ.get("XRAY_TEST_PLAN", "")
    cid, csec    = os.environ.get("XRAY_CLIENT_ID", ""), os.environ.get("XRAY_CLIENT_SECRET", "")
    base         = os.environ.get("XRAY_BASE", "https://xray.cloud.getxray.app").rstrip("/")
    if not (cid and csec):
        log("ERROR: XRAY_CLIENT_ID / XRAY_CLIENT_SECRET not set"); sys.exit(1)

    s = json.load(open(summary_path))
    tests = []
    for c in s.get("cases", []):
        key = c.get("id", "")
        if not key.startswith("QA-"):
            continue
        tests.append({"testKey": key, "status": STATUS_MAP.get(c.get("status", "UNKNOWN"), "TODO")})
    if not tests:
        log("ERROR: no QA-* cases in summary.json — nothing to import"); sys.exit(1)
    log(f">> {len(tests)} results to import (plan={plan_key or 'none'})")

    # 1) authenticate -> bearer token (response body is the quoted token string)
    token = json.loads(post(f"{base}/api/v2/authenticate",
                             {"client_id": cid, "client_secret": csec},
                             {"Content-Type": "application/json"}))

    # 2) import/execution -> creates a new Test Execution, returns its key
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S%z")
    # `project` tells Xray which Jira project to create the Test Execution issue in. Without it
    # (and without a testPlanKey to infer from) Xray returns "Create issue failed".
    info = {"project": os.environ.get("XRAY_PROJECT", "QA"),
            "summary": summary_text, "description": "Created by the magpie Jenkins pipeline.",
            "startDate": now, "finishDate": now}
    if plan_key:
        info["testPlanKey"] = plan_key
    resp = post(f"{base}/api/v2/import/execution", {"info": info, "tests": tests},
                {"Content-Type": "application/json", "Authorization": f"Bearer {token}"})
    key = json.loads(resp).get("key", "")
    if not key:
        log(f"ERROR: no execution key in Xray response: {resp}"); sys.exit(1)
    log(f">> created Xray execution {key}")
    print(key)   # STDOUT: the one line the pipeline captures

if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as e:
        log(f"ERROR: Xray HTTP {e.code}: {e.read().decode(errors='ignore')}"); sys.exit(1)
    except urllib.error.URLError as e:
        log(f"ERROR: Xray unreachable: {e.reason}"); sys.exit(1)
    except Exception as e:
        log(f"ERROR: {type(e).__name__}: {e}"); sys.exit(1)
