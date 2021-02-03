pipeline {
    agent {
        docker {
            image 'testmnrp/flutter-chromedriver:3'
            args '-u root:root'
        }
    }
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    environment {
        METRICS_PROJECT_ID = "jenkins_metrics_web"
    }
    stages {
        
        stage('Git clone') {
            steps {
                git branch: 'master', url: 'https://github.com/platform-platform/monorepo.git'
            }
        }

        stage('Get Dependencies') {
            steps {
                dir('metrics/web'){
                    sh 'flutter config --enable-web'
                    sh 'pub get'
                }
            }
        }

        stage('Run tests') {
                    failFast true
                    parallel {
                        stage('Run web driver tests') {
                            steps {
                                dir('metrics/web'){
                                    withCredentials([usernamePassword(credentialsId: 'app_credentials', passwordVariable: 'PASSWORD', usernameVariable: 'EMAIL')]) {
                                        sh 'dart test_driver/main.dart --verbose --store-logs-to=build/logs --email=$EMAIL --password=$PASSWORD --no-verbose'
                                    }
                                }
                            }
                        }
                        stage('Run flutter tests') {
                            steps {
                                dir('metrics/web'){
                                    sh 'flutter test -v --coverage --coverage-path build/coverage.info'
                                }
                            }
                        }

                    }
                }

        stage('Convert coverage report') {
            steps {
                dir('metrics/web'){
                    sh 'coverage_converter lcov -i build/coverage.info -o coverage-summary.json'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'metrics/web/coverage-summary.json', fingerprint: true, allowEmptyArchive: true
            cleanWs cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true, notFailBuild: true
            build job: 'sync_build_data', propagate: false, wait: false, parameters: [string(name: 'FIREBASE_PROJECT_ID', value: "${env.FIREBASE_PROJECT_ID}"), string(name: 'METRICS_PROJECT_ID', value: "${env.METRICS_PROJECT_ID}"), string(name: 'ANCESTOR_JOB_NAME', value: "${env.JOB_NAME}")]
        }
    }
}
