#!/usr/bin/env groovy

pipelineJob('monorepo') {
    displayName('Monorepo')

    properties {
        pipelineTriggers {
            triggers {
                githubPush()
            }
        }
    }

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
            scriptPath('.jenkins/pipelines/monorepo.groovy')
        }
    }
}
