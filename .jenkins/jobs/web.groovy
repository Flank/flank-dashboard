#!/usr/bin/env groovy

pipelineJob('web') {
    displayName('Web')
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
            scriptPath('.jenkins/pipelines/web.groovy')
        }
    }
}
