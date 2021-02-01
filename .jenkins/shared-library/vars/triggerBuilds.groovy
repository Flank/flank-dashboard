#!/usr/bin/env groovy

def call(List buildList){
  builds = [:]
  buildList.each {
    builds["${it}"] = {
      stage("Trigger job for ${it}"){
        build job: "${it}"
      }
    }
  parallel builds
  }
}