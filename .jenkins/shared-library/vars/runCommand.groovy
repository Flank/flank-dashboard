#!/usr/bin/env groovy

def call(String workDir, String command = "echo test", boolean abortOnFail = false) {
  dir(workDir){
    try {
      sh "$command"
      return 1
    } catch (Exception e){
        if (abortOnFail){
          currentBuild.result='FAILED'
          error "Exception caught.\n" + e.toString() + "\nStopping failed build."
        }
        println "Exception caught. Build marked as unstable.\n" + e.toString()
        currentBuild.result='UNSTABLE'
        return 0
    }
  }
}

