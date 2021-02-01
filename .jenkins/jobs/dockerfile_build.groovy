#!/usr/bin/env groovy

pipelineJob('dockerfile_build') {
    displayName('Dockerfile Build')

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
            scriptPath('.jenkins/pipelines/dockerfile_build.groovy') 
        }
    }
}