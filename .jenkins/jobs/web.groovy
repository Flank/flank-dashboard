#!/usr/bin/env groovy

pipelineJob('web') {
    displayName('Metrics Web')

    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('git@github.com:jdzsz/monorepo.git')
                        credentials('jenkins-key')
                    }
                    branches('*/feat-jenkins')
                }
            }
            scriptPath('.jenkins/pipelines/web.groovy')
        }
    }
}