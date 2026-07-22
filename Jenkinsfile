// magpie regression pipeline (scripted, mirrors the qa Playwright pipeline conventions).
//
// Unlike the qa suite (npx playwright test), magpie's cases are executed BY Claude via the
// Playwright MCP. This pipeline prepares the env and runs bin/ci-runner.sh, which hands off to
// bin/run-batches.sh (login smoke gate -> sequential batches -> results/<date>/*.md + summary.json).
//
// v1 is a single sequential job. Parallel fan-out to a downstream runner job (like qa) is deferred
// until bin/run-case.sh is made isolation-safe (its global `pkill @playwright/mcp` currently kills
// sibling browsers).

// Node runtime helper (nvm) from the same shared library the qa pipeline uses.
library identifier: 'xenv-jenkins-lib@master',
  retriever: modernSCM([$class: 'GitSCMSource',
            remote: 'https://github.com/drylogics/Xenv-jenkins-lib.git'])

def MAGPIE_REPO   = 'git@github.com:ListenFirstMedia/magpie.git'
def GIT_CRED      = '7056f520-1a30-4a75-a108-5ccbb1022604'   // reuse qa SSH cred (confirm org-wide access)
def CLAUDE_CRED   = 'magpie-claude-oauth'                    // Secret text: `claude setup-token` OAuth token
def SLACK_CHANNEL = 'qa-jenkins'
def SLACK_TOKEN   = 'listenfirstmediaqa'
def JIRA_BASE     = 'https://listenfirstmedia.atlassian.net'
// XRAY_CLIENT_ID / XRAY_CLIENT_SECRET come from Jenkins Global properties (Manage Jenkins →
// System), same as the qa jobs — inherited into every build env, so no credential binding.

properties([
  // Nightly. Adjust time/TZ as needed (Jenkins honors a leading TZ= line).
  pipelineTriggers([cron('TZ=America/New_York\nH 2 * * *')]),
  parameters([
    choice(name: 'SET', choices: ['qa-22298', 'qa-4325', 'qa-22296', 'qa-4204', 'ci-smoke'],
           description: 'Which batch set to run (file under batches/). ci-smoke = 2 deterministic cases to validate the pipeline cheaply.'),
    string(name: 'TEST_CASES', defaultValue: '',
           description: 'Optional: comma/space-separated QA-IDs (e.g. "QA-84193, QA-949" or "84193 949"). When set, runs ONLY these cases and ignores SET.'),
    string(name: 'BRANCH', defaultValue: 'feature/jenkins-ci', description: 'magpie branch to test (must contain bin/ci-runner.sh).'),
    string(name: 'CASE_TIMEOUT', defaultValue: '1800', description: 'Per-case hard cap (seconds).'),
    string(name: 'BATCH_SIZE', defaultValue: '5', description: 'Cases per checkpoint.')
  ])
])

// @NonCPS so the transient regex Matcher never lives in CPS-serialized pipeline scope —
// Matcher is not Serializable and otherwise crashes the build at a step boundary.
@NonCPS
String planKeyFromSet(String setName) {
  def m = (setName =~ /(\d+)/)
  return m ? "QA-${m[0][1]}" : ''
}

node('QAPipelineMaster') {
  def runDir = null
  def counts = [total: '?', passed: '?', failed: '?', blocked: '?', skipped: '?']
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
                   "CASE_TIMEOUT=${params.CASE_TIMEOUT}", "BATCH_SIZE=${params.BATCH_SIZE}"]) {
            sh 'bash bin/ci-runner.sh'
          }
        }
      }
    }

    stage('Collect results') {
      runDir = sh(script: "ls -d results/* | grep -E '/[0-9]{4}-[0-9]{2}-[0-9]{2}\$' | sort | tail -1", returnStdout: true).trim()
      if (runDir && fileExists("${runDir}/summary.json")) {
        def s = readJSON file: "${runDir}/summary.json"
        counts = [total: "${s.total}", passed: "${s.passed}", failed: "${s.failed}",
                  blocked: "${s.blocked}", skipped: "${s.skipped ?: 0}"]
        failedIds = s.cases.findAll { it.status == 'FAIL' }.collect { it.id }
        // Build the browsable HTML report from summary.json + the per-case reports.
        sh "python3 bin/gen_report.py '${runDir}/summary.json' '${runDir}/report.html' '${label}' '${env.BUILD_URL}'"
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
          // qa-4325 -> QA-4325; ci-smoke/ad-hoc -> none. Regex is isolated in a @NonCPS helper.
          def planKey = adhoc ? '' : planKeyFromSet(params.SET)
          // XRAY_CLIENT_ID / XRAY_CLIENT_SECRET are inherited from Jenkins Global properties
          // (no credential binding — matches the qa pipeline).
          xrayKey = sh(returnStdout: true, script:
            "python3 bin/xray_report.py '${runDir}/summary.json' 'magpie ${label} #${env.BUILD_NUMBER}' '${planKey}'").trim()
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
      archiveArtifacts allowEmptyArchive: true, artifacts: 'results/**/*.md, results/**/*.png, results/**/summary.json, results/**/report.html'
      // Browsable per-build report (magpie's equivalent of the Playwright HTML report).
      if (runDir && fileExists("${runDir}/report.html")) {
        publishHTML([reportDir: runDir, reportFiles: 'report.html', reportName: "magpie Report - ${label}",
                     reportTitles: 'magpie run', keepAll: true, allowMissing: true, alwaysLinkToLastBuild: true])
      }
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
          xrayLine +
          "    Build: <${env.BUILD_URL}|#${env.BUILD_NUMBER}>\n" +
          "    Total: ${counts.total}  |  PASS: ${counts.passed}  FAIL: ${failedDisp}  BLOCKED: ${counts.blocked}  SKIPPED: ${counts.skipped}"
    }
    stage('Cleanup') {
      deleteDir()
    }
  }
}
