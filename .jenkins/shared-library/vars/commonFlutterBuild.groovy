#!/usr/bin/env groovy

def call(String componentPath, String firebaseProjectId, String metricsProjectId, String jobName){

  boolean isTested = false
  stage('Get Dependencies') {
    runCommand(componentPath,"flutter config --enable-web", true)
    runCommand(componentPath,"pub get", true)
  }
  isTested = true

  stage("Test coverage"){
    runCommand(componentPath,"flutter test -v --coverage --coverage-path build/coverage.info", true)
  }
  parallel(

    "Chrome driver test": {
      stage('Run tests') {
        runCommand(componentPath,"dart test_driver/main.dart --verbose --store-logs-to=build/logs --no-verbose", false)

      }
    },

    "Flutter Analyzer": {
      stage('Run Analyzer') {
        runCommand(componentPath, "flutter analyze", false)
      }
    },

    "Coverage report": {
      stage('Convert coverage report') {
        waitUntil{
          isTested
        }
        runCommand(componentPath, 'coverage_converter lcov -i build/coverage.info -o coverage-summary.json')
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
