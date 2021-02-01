#!/usr/bin/env groovy

def call(String componentPath, String firebaseProjectId, String metricsProjectId, String jobName){
  stage('Get Dependencies') {
    runCommand(componentPath,"pub get", true)
  }
  boolean isTested = false
  parallel(

    "Pub test": {
      stage('Run tests') {
              runCommand(componentPath,"pub run test_coverage --print-test-output --no-badge --port 9498", false)
              isTested = true
      }
    },

    "Dart Analyzer": {
      stage('Run Analyzer') {
              runCommand(componentPath, "dartanalyzer . --fatal-infos --fatal-warnings", false)
      }
    },

    "Coverage report": {
      stage('Convert coverage report') {
        waitUntil{
          isTested
        }
        runCommand(componentPath, 'coverage_converter lcov -i coverage/lcov.info -o coverage-summary.json')
        archiveArtifacts artifacts: "$componentPath/coverage-summary.json", fingerprint: true
      }
    }
  )
  stage('Trigger sync job'){
     build job: 'sync_build_data', parameters: [
     string(name: 'FIREBASE_PROJECT_ID',  value: "${firebaseProjectId}"),
     string(name: 'METRICS_PROJECT_ID',  value: "${metricsProjectId}"),
     string(name: 'ANCESTOR_JOB_NAME',  value: "${jobName}")]
  }
}
