pipeline {
    agent {
        docker {
            image 'ubuntu:focal'
        }
    }
    options {
        timeout(time: 2, unit: 'HOURS') 
    }
    environment {
        HOME = '.'
    }
    stages {
        stage('Git clone') {
            steps {
                git branch: 'master', url: 'https://github.com/platform-platform/monorepo.git'
            }
        }
        stage('Run Metrics Web Build'){
            when {
                anyOf {
                    changeset "metrics/web/**"
                    changeset "metrics/core/**"
                }
            }
            steps {
                build job: 'Metrics Web', propagate: false, wait: false
            }
        }
        stage('Run CI Integrations Build'){
            when {
                anyOf {
                    changeset "metrics/ci_integrations/**"
                    changeset "metrics/core/**"
                }
            }
            steps {
                build job: 'CI Integrations', propagate: false, wait: false
            }
        }
        stage('Run Coverage Converter Build'){
            when {
                anyOf {
                    changeset "metrics/coverage_converter/**"
                    changeset "metrics/core/**"
                }
            }
            steps {
                build job: 'Coverage Converter', propagate: false, wait: false
            }
        }
    }    
    post { 
        always { 
            cleanWs cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true, notFailBuild: true
        }
    }
}
