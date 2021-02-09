#!/usr/bin/env groovy

pipelineJob('dummy') {
    displayName('Dummy')
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
            scriptPath('.jenkins/pipelines/dummy.groovy')
        }
    }
}
