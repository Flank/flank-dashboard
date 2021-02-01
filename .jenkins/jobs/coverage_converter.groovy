#!/usr/bin/env groovy

pipelineJob('coverage_converter') {
    displayName('Coverage converter')

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
            scriptPath('.jenkins/pipelines/coverage_converter.groovy')
        }
    }
}