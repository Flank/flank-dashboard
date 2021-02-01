#!/usr/bin/env groovy

pipelineJob('ci_integrations') {
    displayName('CI Integrations')

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
            scriptPath('.jenkins/pipelines/ci_integrations.groovy')
        }
    }
}