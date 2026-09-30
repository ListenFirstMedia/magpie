// magpie regression pipeline (scripted, mirrors the qa Playwright pipeline conventions).
//
// Unlike the qa suite (npx playwright test), magpie's cases are executed BY Claude via the
// Playwright MCP. This pipeline prepares the env and runs bin/ci-runner.sh, which hands off to
// bin/run-batches.sh (login smoke gate -> sequential batches -> results/<date>/*.md + summary.json).
//
// v1 is a single sequential job. Parallel fan-out to a downstream runner job (like qa) is deferred
// until bin/run-case.sh is made isolation-safe (its global `pkill @playwright/mcp` currently kills
// sibling browsers). Because of that, builds of THIS job must never overlap either — see
// disableConcurrentBuilds() below.

// Node runtime helper (nvm) from the same shared library the qa pipeline uses.
library identifier: 'xenv-jenkins-lib@master',
  retriever: modernSCM([$class: 'GitSCMSource',
            remote: 'https://github.com/drylogics/Xenv-jenkins-lib.git'])

def MAGPIE_REPO   = 'git@github.com:ListenFirstMedia/magpie.git'
def GIT_CRED      = '7056f520-1a30-4a75-a108-5ccbb1022604'   // reuse qa SSH cred (confirm org-wide access)
def CLAUDE_CRED   = 'magpie-claude-oauth'                    // Secret text: `claude setup-token` OAuth token
def SLACK_CHANNEL = 'magpie-regression'
def SLACK_TOKEN   = 'magpie-slack-auth'
def JIRA_BASE     = 'https://listenfirstmedia.atlassian.net'
// XRAY_CLIENT_ID / XRAY_CLIENT_SECRET come from Jenkins Global properties (Manage Jenkins →
// System), same as the qa jobs — inherited into every build env, so no credential binding.

properties([
  // Never run two builds of this job at once. Overlapping builds on QAPipelineMaster (1) share
  // ~/.cache/ms-playwright, so one build's `playwright install` can garbage-collect the browser
  // another build is using, and (2) the pre-run sweep's machine-wide pkill kills the sibling
  // build's @playwright/mcp. Queued builds wait instead of overlapping.
  disableConcurrentBuilds(),
  // Prune old builds so the controller doesn't fill up. Each build archives per-case PNGs/MD/JSON;
  // unbounded, that filled the controller disk and killed running builds with
  // `No space left on device`. Keep build records for the last 10 builds / 7 days, and artifacts
  // for the last 15 builds / 30 days.
  buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '7',
                            artifactNumToKeepStr: '15', artifactDaysToKeepStr: '30')),
  // Nightly. Adjust time/TZ as needed (Jenkins honors a leading TZ= line).
  // NOTE: a full set takes ~13h, and disableConcurrentBuilds() queues these one after another.
  pipelineTriggers([
    parameterizedCron('''
  TZ=IST
  30 12 * * 0-4 %SET=qa-22298
  35 12 * * 0-4 %SET=qa-4325
  45 12 * * 0-4 %SET=qa-22296
  ''') ]),
  parameters([
    choice(name: 'SET', choices: ['qa-22298', 'qa-4325', 'qa-22296', 'qa-4204', 'ci-smoke'],
           description: 'Which batch set to run (file under batches/). ci-smoke = 2 deterministic cases to validate the pipeline cheaply.'),
    string(name: 'TEST_CASES', defaultValue: '',
           description: 'Optional: comma/space-separated QA-IDs (e.g. "QA-84193, QA-949" or "84193 949"). When set, runs ONLY these cases and ignores SET.'),
    string(name: 'BRANCH', defaultValue: 'fix/premission-error', description: 'magpie branch to test (must contain bin/ci-runner.sh).'),
    string(name: 'CASE_TIMEOUT', defaultValue: '1800', description: 'Per-case hard cap (seconds).'),
    string(name: 'BATCH_SIZE', defaultValue: '5', description: 'Cases per checkpoint.'),
    // Token economy: runs bill the shared Claude weekly usage limit. Default is Sonnet 5.5 (user
    // call 2026-08-26: an opus set burns ~10% of the weekly Max-20x limit — 3 sets/night at opus
    // exhausts the week by Tuesday). Sonnet 5.5 is near-opus on scaffolded agentic work and
    // ~1.7x cheaper per token (the old "~5x" ratio predates Opus 5 pricing). Pick opus here for
    // targeted quality reruns. Exact model IDs (not aliases) so neither the node default nor an
    // alias moving to a new release can silently change the model.
    choice(name: 'CLAUDE_MODEL',
           choices: ['claude-sonnet-5-5', 'claude-opus-5-5', 'claude-haiku-4-5-20251001'],
           description: 'Model for the per-case claude sessions, pinned to exact model IDs. Default Sonnet 5.5 (~1.7x cheaper vs Opus against the weekly limit); pick Opus for targeted quality reruns.'),
    choice(name: 'CLAUDE_EFFORT', choices: ['medium', 'high', 'low'],
           description: 'Reasoning effort per case. medium cuts thinking-token spend; high only for targeted reruns.'),
    booleanParam(name: 'SYNC_SET', defaultValue: true,
           description: 'Rebuild the case list from the LIVE Xray Test Set before running (new tests ingested, removed tests dropped, edited steps refreshed). Untick to run exactly the committed batches/<set>.txt snapshot.'),
    // QAPipelineMaster runs Ubuntu 20.04; Playwright 1.63+ refuses to install browsers there.
    // Keep the 1.62 line until the node is upgraded to 22.04+.
    string(name: 'PW_VERSION', defaultValue: '1.62',
           description: 'Playwright version/range for the browser install (npx playwright@<this>). 1.62 = newest 1.62.x, the last line that supports Ubuntu 20.04.'),
    string(name: 'PW_MCP_VERSION', defaultValue: '',
           description: 'Exact @playwright/mcp version. Empty = ci-runner auto-picks the newest release built on playwright PW_VERSION.x.')
  ])
])

node('QAPipelineMaster') {
  def runDir = null
  def counts = [total: '?', passed: '?', failed: '?', blocked: '?', timeout: '?', skipped: '?', unknown: '?']
  def failedIds = []
  def xrayKey = ''
  def adhoc = (params.TEST_CASES ?: '').trim()      // non-empty => ad-hoc run, SET ignored
  def label = adhoc ? 'ad-hoc' : params.SET

  buildName "${env.BUILD_NUMBER} - ${label}"

  try {
    stage('Checkout') {
      deleteDir()
      git branch: params.BRANCH, credentialsId: GIT_CRED, url: MAGPIE_REPO
    }

    stage('Run set') {
      nvm(version: '20.18.0') {
        withCredentials([string(credentialsId: CLAUDE_CRED, variable: 'CLAUDE_CODE_OAUTH_TOKEN')]) {
          withEnv(["SET=${params.SET}", "TEST_CASES=${params.TEST_CASES}",
                   "CASE_TIMEOUT=${params.CASE_TIMEOUT}", "BATCH_SIZE=${params.BATCH_SIZE}",
                   "CLAUDE_MODEL=${params.CLAUDE_MODEL}", "CLAUDE_EFFORT=${params.CLAUDE_EFFORT}",
                   "SYNC_SET=${params.SYNC_SET ? '1' : '0'}",
                   "PW_VERSION=${params.PW_VERSION}",
                   "PW_MCP_VERSION=${params.PW_MCP_VERSION}",
                   // Never let a (failed) `playwright install` delete the browser we run on.
                   "PLAYWRIGHT_SKIP_BROWSER_GC=1"]) {
            sh 'bash bin/ci-runner.sh'
            // sh 'bash bin/check-perms.sh'
          }
        }
      }
    }

    stage('Collect results') {
      runDir = sh(script: "ls -d results/* | grep -E '/[0-9]{4}-[0-9]{2}-[0-9]{2}\$' | sort | tail -1", returnStdout: true).trim()
      if (runDir && fileExists("${runDir}/summary.json")) {
        def s = readJSON file: "${runDir}/summary.json"
        counts = [total: "${s.total}", passed: "${s.passed}", failed: "${s.failed}",
                  blocked: "${s.blocked}", timeout: "${s.timeout ?: 0}", skipped: "${s.skipped ?: 0}",
                  unknown: "${s.unknown ?: 0}"]
        failedIds = s.cases.findAll { it.status == 'FAIL' }.collect { it.id }
      }
      echo "Run dir: ${runDir} | ${counts} | failed: ${failedIds}"
    }

    stage('Report to Xray') {
      // Create a Test Execution for this run and import per-case PASS/FAIL. Non-blocking:
      // a Xray hiccup must not fail the regression build.
      if (!runDir || !fileExists("${runDir}/summary.json")) {
        echo 'No summary.json — skipping Xray.'
      } else {
        try {
          // The SET names (qa-4325, qa-22298, …) are Xray *Test Sets*, not Test Plans. Xray's
          // import/execution endpoint only accepts a Test Plan in `testPlanKey`, so passing a Test
          // Set key there returns HTTP 400 and aborts the whole import — no execution is created.
          // So we create a bare Test Execution (empty key): it always yields an execution key + Jira
          // link, and the per-case testKey results attach to it. To roll the execution up under a
          // set/plan later, associate it via Xray GraphQL after creation.
          xrayKey = sh(returnStdout: true, script:
            "python3 bin/xray_report.py '${runDir}/summary.json' 'magpie ${label} #${env.BUILD_NUMBER}' ''").trim()
          echo "Xray execution: ${xrayKey}"
        } catch (Exception e) {
          echo "Xray reporting failed (non-blocking): ${e.message}"
        }
      }
    }

    currentBuild.result = 'SUCCESS'
  } catch (Exception e) {
    currentBuild.result = 'FAILURE'
    echo "Pipeline failed: ${e.message}"
    throw e
  } finally {
    // Archive in finally (before Cleanup) so reports are captured even when an earlier stage
    // fails — otherwise deleteDir() wipes them and the build has no artifacts to inspect.
    stage('Publish') {
      archiveArtifacts allowEmptyArchive: true, artifacts: 'results/**/*.md, results/**/*.png, results/**/summary.json'
    }
    stage('Notify') {
      def status = currentBuild.result ?: 'SUCCESS'
      def xrayLine = xrayKey ? "    Xray: <${JIRA_BASE}/browse/${xrayKey}|${xrayKey}>\n" : ""
      // Failed count links to a Jira JQL listing exactly the failed cases (same trick as qa).
      def failedDisp = "${counts.failed}"
      if (failedIds) {
        failedDisp = "<${JIRA_BASE}/issues/?jql=key%20in(${failedIds.join('%2C')})|${counts.failed}>"
      }
      slackSend channel: SLACK_CHANNEL,
        tokenCredentialId: SLACK_TOKEN,
        message: "magpie regression — ${label}\n" +
          "    Status: ${status}\n" +
          "    Model: ${params.CLAUDE_MODEL}@${params.CLAUDE_EFFORT}\n" +
          xrayLine +
          "    Build: <${env.BUILD_URL}|#${env.BUILD_NUMBER}>\n" +
          "    Total: ${counts.total}  |  PASS: ${counts.passed}  FAIL: ${failedDisp}  BLOCKED: ${counts.blocked}  TIMEOUT: ${counts.timeout}  SKIPPED: ${counts.skipped}  UNKNOWN: ${counts.unknown}"
    }
    stage('Cleanup') {
      // Storage report + cleanup, mirroring the qa testsets pipeline (STORAGE BEFORE/AFTER blocks).
      // deleteDir() only wipes the workspace — the space that needed MANUAL cleanup lives in the
      // agent's HOME and grows every run:
      //   - ~/.claude/projects/<workspace-slug>/  — `claude -p` writes a full transcript (page
      //     snapshots included) for EVERY case session; nothing else deletes them
      //   - ~/.cache/ms-playwright/               — old browser builds. We ALWAYS keep the newest
      //     chromium build: on Ubuntu 20.04 a fresh install can fail, so the cached one may be
      //     the only browser the node has. Directory mtime = install date, not last use.
      echo '========== STORAGE BEFORE CLEANUP =========='
      sh '''
        echo "Workspace Size:";               du -sh "$WORKSPACE"                 2>/dev/null || true
        echo "  results/:";                   du -sh "$WORKSPACE/results"         2>/dev/null || true
        echo "  .playwright-out/:";           du -sh "$WORKSPACE/.playwright-out" 2>/dev/null || true
        echo "Claude transcripts (HOME):";    du -sh "$HOME/.claude/projects"     2>/dev/null || true
        echo "Playwright browsers (HOME):";   du -sh "$HOME/.cache/ms-playwright" 2>/dev/null || true
        ls -1 "$HOME/.cache/ms-playwright" 2>/dev/null | sed 's/^/    /' || true
        echo "npm cache (HOME):";             du -sh "$HOME/.npm"                 2>/dev/null || true
        echo "Disk Usage:";                   df -h "$WORKSPACE"                             || true
      '''
      sh '''
        # This job's claude session transcripts (project slug = workspace path, non-alnum -> '-').
        SLUG="$(printf %s "$WORKSPACE" | tr -c '[:alnum:]' '-')"
        [ -n "$SLUG" ] && rm -rf "$HOME/.claude/projects/$SLUG" || true
        # Stale claude scratch (shell snapshots, todo files) older than a week.
        find "$HOME/.claude/shell-snapshots" "$HOME/.claude/todos" -type f -mtime +7 -delete 2>/dev/null || true

        # Browser builds older than 45 days, EXCEPT the newest chromium / headless-shell build.
        PW_CACHE="$HOME/.cache/ms-playwright"
        KEEP_CHROMIUM="$(ls -1d "$PW_CACHE"/chromium-[0-9]* 2>/dev/null | sort -V | tail -1)"
        KEEP_SHELL="$(ls -1d "$PW_CACHE"/chromium_headless_shell-[0-9]* 2>/dev/null | sort -V | tail -1)"
        find "$PW_CACHE" -mindepth 1 -maxdepth 1 -type d -mtime +45 2>/dev/null |
          while read -r d; do
            [ "$d" = "$KEEP_CHROMIUM" ] && continue
            [ "$d" = "$KEEP_SHELL" ] && continue
            case "$d" in */ffmpeg-*) continue ;; esac
            echo "pruning stale browser build: $d"
            rm -rf "$d"
          done || true
      '''
      deleteDir()
      echo '========== STORAGE AFTER CLEANUP =========='
      sh '''
        echo "Workspace Size After Cleanup:"; du -sh "$WORKSPACE"                 2>/dev/null || true
        echo "Claude transcripts (HOME):";    du -sh "$HOME/.claude/projects"     2>/dev/null || true
        echo "Playwright browsers (HOME):";   du -sh "$HOME/.cache/ms-playwright" 2>/dev/null || true
        echo "Disk Usage:";                   df -h "$WORKSPACE"                             || true
      '''
    }
  }
}