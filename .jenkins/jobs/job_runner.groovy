#!/usr/bin/env groovy

pipelineJob('job_runner') {
    displayName('Job Runner')

    properties{
      pipelineTriggers{
        triggers{
          githubPush()
        }
      }
    }

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
            scriptPath('.jenkins/pipelines/job_runner.groovy')
        }
    }
}