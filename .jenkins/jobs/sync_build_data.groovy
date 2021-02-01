#!/usr/bin/env groovy

pipelineJob('sync_build_data') {
    displayName('Sync build data')

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
            scriptPath('.jenkins/pipelines/sync_build_data.groovy')
        }
    }
}