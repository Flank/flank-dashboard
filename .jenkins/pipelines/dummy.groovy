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
    environment {
        METRICS_PROJECT_ID = "jenkins_dummy"
    }
    stages {

        stage('Fake builder') {
            steps {
                sh 'DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y curl '
                sh 'curl -L https://raw.githubusercontent.com/jdzsz/randomsleep/main/randomsleep.sh -o randomsleep.sh'
                sh 'bash randomsleep.sh'
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
