pipeline {
    agent {
        docker {
            image 'testmnrp/dart-converter:2'
            args '-u root:root'
        }
    }
    options {
        timeout(time: 2, unit: 'HOURS')
    }
    environment {
        METRICS_PROJECT_ID = "jenkins_ci_integrations"
    }
    stages {
        stage('Git clone') {
            steps {
                git branch: 'master', url: 'https://github.com/platform-platform/monorepo.git'
            }
        }
        stage('Get Dependencies') {
            steps {
                dir('metrics/ci_integrations'){
                    sh 'pub get'
                }
                script{
                    isTested = false
                }
            }
        }
        stage('Parallel Stage') {
                    parallel {
                        stage('Run Analyzer') {
                            steps {
                                dir('metrics/ci_integrations'){
                                    sh 'dartanalyzer . --fatal-infos --fatal-warnings'
                                }
                            }
                        }
                        stage('Run tests') {
                            steps {
                                dir('metrics/ci_integrations'){
                                    sh 'pub run test_coverage --print-test-output --no-badge --port 9498'
                                }
                                script{
                                    isTested = true
                                }
                            }
                        }
                        stage('Convert coverage report') {
                            steps {
                                waitUntil{
                                    script{
                                        return isTested
                                    }
                                }
                                dir('metrics/ci_integrations'){
                                    sh 'coverage_converter lcov -i coverage/lcov.info -o coverage-summary.json'
                                }
                            }
                        post {
                          always {
                                archiveArtifacts artifacts: 'metrics/ci_integrations/coverage-summary.json', fingerprint: true
                            }
                        }
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