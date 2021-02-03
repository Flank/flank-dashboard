#!/usr/bin/env groovy

pipelineJob('sync_build_data') {
    displayName('Sync build data')
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
            scriptPath('.jenkins/pipelines/sync.groovy')
        }
    }
}
