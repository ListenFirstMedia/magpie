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

properties([
  // Nightly. Adjust time/TZ as needed (Jenkins honors a leading TZ= line).
  pipelineTriggers([cron('TZ=America/New_York\nH 2 * * *')]),
  parameters([
    choice(name: 'SET', choices: ['qa22298', 'qa4325', 'qa-22296-remaining', 'qa-4204'],
           description: 'Which batch set to run (file under batches/).'),
    string(name: 'BRANCH', defaultValue: 'feature/jenkins-ci', description: 'magpie branch to test (must contain bin/ci-runner.sh).'),
    string(name: 'CASE_TIMEOUT', defaultValue: '1800', description: 'Per-case hard cap (seconds).'),
    string(name: 'BATCH_SIZE', defaultValue: '5', description: 'Cases per checkpoint.')
  ])
])

node('QAPipelineMaster') {
  def runDir = null
  def counts = [total: '?', passed: '?', failed: '?', blocked: '?', skipped: '?']

  buildName "${env.BUILD_NUMBER} - ${params.SET}"

  try {
    stage('Checkout') {
      deleteDir()
      git branch: params.BRANCH, credentialsId: GIT_CRED, url: MAGPIE_REPO
    }

    stage('Run set') {
      nvm(version: '20.18.0') {
        withCredentials([string(credentialsId: CLAUDE_CRED, variable: 'CLAUDE_CODE_OAUTH_TOKEN')]) {
          withEnv(["SET=${params.SET}", "CASE_TIMEOUT=${params.CASE_TIMEOUT}", "BATCH_SIZE=${params.BATCH_SIZE}"]) {
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
      }
      echo "Run dir: ${runDir} | ${counts}"
    }

    stage('Publish') {
      // Screenshots + markdown reports are the artifacts (PNGs are gitignored; archived here).
      archiveArtifacts allowEmptyArchive: true, artifacts: 'results/**/*.md, results/**/*.png, results/**/summary.json'
    }

    currentBuild.result = 'SUCCESS'
  } catch (Exception e) {
    currentBuild.result = 'FAILURE'
    echo "Pipeline failed: ${e.message}"
    throw e
  } finally {
    stage('Notify') {
      def status = currentBuild.result ?: 'SUCCESS'
      slackSend channel: SLACK_CHANNEL,
        tokenCredentialId: SLACK_TOKEN,
        message: "magpie regression — ${params.SET}\n" +
          "    Status: ${status}\n" +
          "    Build: <${env.BUILD_URL}|#${env.BUILD_NUMBER}>\n" +
          "    Total: ${counts.total}  |  PASS: ${counts.passed}  FAIL: ${counts.failed}  BLOCKED: ${counts.blocked}  SKIPPED: ${counts.skipped}"
    }
    stage('Cleanup') {
      deleteDir()
    }
  }
}
