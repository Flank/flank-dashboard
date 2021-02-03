#!/usr/bin/env groovy

pipelineJob('coverage_converter') {
    displayName('Coverage converter')
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
            scriptPath('.jenkins/pipelines/coverage_converter.groovy')
        }
    }
}
