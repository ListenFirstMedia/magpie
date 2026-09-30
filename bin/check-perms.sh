#!/usr/bin/env bash
# Temporary diagnostic: can the jenkins user, and a claude -p session, read config/.env?
# Prints no credential values.
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1
ROOT="$(pwd)"

echo "== 1. who / where =="
echo "whoami=$(whoami)  HOME=$HOME  pwd=$ROOT"
ls -ld "$HOME" "$HOME/git" "$HOME/git/magpie" /root 2>&1 | sed 's/^/   /'

echo "== 2. config/.env on disk =="
if [ ! -f config/.env ]; then
  echo "   config/.env not present (ci-runner not run) - creating a DUMMY one for the test"
  mkdir -p config && printf 'DUMMY_USER=x\nDUMMY_PASS=y\n' > config/.env
  DUMMY=1
fi
ls -la config/.env | sed 's/^/   /'
[ -r config/.env ] && echo "   readable by $(whoami): YES" || echo "   readable by $(whoami): NO"

echo "== 3. Claude Code settings that could block reading .env =="
for f in .claude/settings.json .claude/settings.local.json \
         "$HOME/.claude/settings.json" "$HOME/.claude/settings.local.json" \
         /etc/claude-code/managed-settings.json; do
  [ -f "$f" ] || continue
  echo "   --- $f"
  grep -n -i -E 'deny|allow|env|permission|additionalDirectories' "$f" | sed 's/^/      /'
done

echo "== 4. flags run-case.sh passes to claude =="
grep -n -E 'allowedTools|disallowedTools|permission-mode|add-dir|dangerously|settings' bin/run-case.sh | sed 's/^/   /'

echo "== 5. references to ~/git/magpie in repo =="
grep -rn --exclude-dir=results --exclude-dir=.git --exclude=check-perms.sh 'git/magpie' . | sed 's/^/   /' | head -40

echo "== 6. live test: can a claude session read config/.env? =="
OUT="$(claude -p "Use the Read tool on config/.env. Reply ONLY with the variable NAMES found (never values), comma-separated, or the exact error you got." \
        --model "${CLAUDE_MODEL:-claude-sonnet-5-5}" --max-turns 3 --output-format json 2>&1)"
printf '%s' "$OUT" | python3 -c '
import json,sys
raw=sys.stdin.read()
try:
    d=json.loads(raw)
except Exception:
    print("   (non-JSON output)"); print(raw[:2000]); sys.exit()
print("   result:", (d.get("result") or "").strip()[:500])
print("   permission_denials:", json.dumps(d.get("permission_denials"), indent=2))
'

[ "${DUMMY:-0}" = 1 ] && rm -f config/.env
echo "== done =="