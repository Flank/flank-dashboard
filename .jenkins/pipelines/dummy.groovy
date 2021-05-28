pipeline {
    agent {
        kubernetes {
          yamlFile '.jenkins/pod_templates/ubuntu.yaml'
        }
    }
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    environment {
        METRICS_PROJECT_ID = "jenkins_dummy"
    }
    stages {

        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Flank/flank-dashboard.git'
            }
        }

        stage('Fake builder') {
            steps {
                dir('scripts/random_sleep') {
                    sh 'bash random_sleep.sh'
                }
            }
        }

    }

    post {
        always {
            cleanWs cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true, notFailBuild: true
            build job: 'sync_build_data', propagate: false, wait: false, parameters: [string(name: 'FIREBASE_PROJECT_ID', value: "${env.FIREBASE_PROJECT_ID}"), string(name: 'METRICS_PROJECT_ID', value: "${env.METRICS_PROJECT_ID}"), string(name: 'ANCESTOR_JOB_NAME', value: "${env.JOB_NAME}")]
        }
    }
}
