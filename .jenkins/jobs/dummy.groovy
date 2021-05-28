#!/usr/bin/env groovy

pipelineJob('dummy') {
    displayName('Dummy')

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
                        url('https://github.com/Flank/flank-dashboard.git')
                    }
                    branches('*/master')
                }
            }
            scriptPath('.jenkins/pipelines/dummy.groovy')
        }
    }
}
