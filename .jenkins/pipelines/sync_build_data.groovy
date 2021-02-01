#!/usr/bin/env groovy

podTemplate(yaml: """
kind: Pod
spec:
  containers:
  - name: sync
    image: testmnrp/sync-builddata:1
    imagePullPolicy: IfNotPresent
    command:
    - cat
    tty: true
"""
  ) {

  node(POD_LABEL) {
    properties(
  [
      parameters(
          [string(name: 'FIREBASE_PROJECT_ID'),
           string(name: 'METRICS_PROJECT_ID'),
           string(name: 'ANCESTOR_JOB_NAME')]
          )

  ]
  )
    container('sync') {
      stage("Run CI Integrations"){
        println(env.JENKINS_URL)
        checkout scm
        CI_INTEGRATION_JENKINS_URL = env.JENKINS_URL
        dir(".metrics/jenkins") {
          withEnv(["FIREBASE_PROJECT_ID=${params.FIREBASE_PROJECT_ID}", "METRICS_PROJECT_ID=${params.METRICS_PROJECT_ID}", "ANCESTOR_JOB_NAME=${params.ANCESTOR_JOB_NAME}", "CI_INTEGRATION_JENKINS_URL=${CI_INTEGRATION_JENKINS_URL}"]) {
              withCredentials([usernamePassword(credentialsId: 'jenkins-app-credentials', passwordVariable: 'WEB_APP_USER_PASSWORD', usernameVariable: 'WEB_APP_USER_EMAIL')]) {
                  withCredentials([string(credentialsId: 'jenkins-firebase-api-key', variable: 'CI_INTEGRATIONS_FIREBASE_API_KEY')]) {
                      withCredentials([usernamePassword(credentialsId: 'jenkins-api-credentials', passwordVariable: 'JENKINS_API_KEY', usernameVariable: 'JENKINS_USERNAME')]) {
                        sh "envsubst < config_template.yml > config.yml"
                        sh "ci_integrations -v sync --config-file config.yml"
                      }
                  }
              }
            }

    }
  }
}
}
}