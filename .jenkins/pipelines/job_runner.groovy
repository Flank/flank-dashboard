#!/usr/bin/env groovy

METRICS_BUILDABLE_PROJECTS = ["ci_integrations", "coverage_converter", "web"]

node('master'){
  timeout(time: 3, unit: 'MINUTES') {
    cleanWs()
    checkout scm
    loadSharedLib(".jenkins/shared-library")
  }
  stage("test"){

    def toRunList  = []
    def changedList = getChangeList()

    if (changedList.findAll {it.contains('metrics/core/')}){
        toRunList = ["ci_integrations, coverage_converter", "web"]
    } else{
        METRICS_BUILDABLE_PROJECTS.each {
          if (buildListAppender(changedList, it)){
            toRunList << it
          }
        }
      }
    println(toRunList)

    if (toRunList){
      triggerBuilds(toRunList)
      return
    }
    println("NO BUILD TO RUN, ABORTED BUILD")
    currentBuild.result='ABORTED'
  }
}

def loadSharedLib(String libraryPath){
  try{
    sh("""git config --global user.email "jenkins@localhost" && \
          git config --global user.name "Jenkins" && \
          cd ./$libraryPath && \
          (rm -rf .git || true) && \
          git init && \
          git add --all && \
          git commit -m init
          """)

    def repoPath = sh(returnStdout: true, script: 'pwd').trim() + "/$libraryPath"

    library identifier: 'local-lib@master',
          retriever: modernSCM([$class: 'GitSCMSource', remote: "$repoPath"]),
          changelog: false

    deleteDir()
    echo "Shared library correctly loaded"

  } catch (Exception e){
      currentBuild.result='ABORTED'
      error "Exception caught during shared library loading. Aborting build.\n" + e.toString()
      return
    }
}
