#!/usr/bin/env groovy

pipelineJob('ci_integrations') {
    displayName('CI Integrations')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://github.com/platform-platform/monorepo.git')
                    }
                    branches('*/master')
                }
            }
            scriptPath('.jenkins/pipelines/ci_integrations.groovy')
        }
    }
}
