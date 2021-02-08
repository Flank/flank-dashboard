pipeline {
    agent {
        docker {
            image 'ubuntu:focal'
            args '-u root:root'
        }
    }
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    parameters {
        string(name: 'FIREBASE_PROJECT_ID')
        string(name: 'METRICS_PROJECT_ID')
        string(name: 'ANCESTOR_JOB_NAME')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/platform-platform/monorepo.git'
            }
        }

        stage('Import build data') {
            steps {
                dir('.metrics/jenkins') {
                    sh 'DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl gettext-base'
                    sh 'curl -o ci_integrations -k https://github.com/platform-platform/monorepo/releases/download/ci_integrations-snapshot/ci_integrations_linux -L'
                    sh 'chmod a+x ci_integrations'
                    withEnv(["FIREBASE_PROJECT_ID=${params.FIREBASE_PROJECT_ID}", "METRICS_PROJECT_ID=${params.METRICS_PROJECT_ID}", "ANCESTOR_JOB_NAME=${params.ANCESTOR_JOB_NAME}", "CI_INTEGRATION_JENKINS_URL=${CI_INTEGRATION_JENKINS_URL}"]) {
                        withCredentials([usernamePassword(credentialsId: 'app_credentials', passwordVariable: 'WEB_APP_USER_PASSWORD', usernameVariable: 'WEB_APP_USER_EMAIL')]) {
                            withCredentials([string(credentialsId: 'ci_integrations_firebase_api_key', variable: 'CI_INTEGRATIONS_FIREBASE_API_KEY')]) {
                                withCredentials([usernamePassword(credentialsId: 'jenkins_credentials', passwordVariable: 'JENKINS_API_KEY', usernameVariable: 'JENKINS_USERNAME')]) {
                                    sh 'envsubst < config_template.yml > config.yml'
                                }
                            }
                        }
                    }
                    sh './ci_integrations sync --config-file config.yml'
                }
            }
        }
    }
    post {
        always {
            cleanWs cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true, notFailBuild: true
        }
    }
}
