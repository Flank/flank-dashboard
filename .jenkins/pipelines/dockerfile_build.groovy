#!/usr/bin/env groovy

podTemplate(yaml: """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
"""
  ) {
  node(POD_LABEL) {

    stage('Init') {
      cleanWs()
      timeout(time: 3, unit: 'MINUTES') {
        checkout([
          $class: 'GitSCM',
          branches: scm.branches,
          doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
          extensions: scm.extensions + [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]],
          submoduleCfg: [],
          userRemoteConfigs: scm.userRemoteConfigs
          ])
      }

      def validTag = 'dockerfile'
      def tags = getHeadTags()

      println ("Following tags found:\n" + tags)

      valid = tags.findAll{ it.contains('dockerfile') }

      println("Valid tags: \n" + valid)

      if (valid.size() == 0){
        currentBuild.result = 'ABORTED'
        println('Skipping build - no valid tags found ')
        return
      }

    }

      container('kaniko') {
        stage('Copy credentials') {
          withCredentials([usernamePassword(credentialsId: 'jenkins-dockerhub-credentials', passwordVariable: 'CI_REGISTRY_PASSWORD', usernameVariable: 'CI_REGISTRY_USER')]) {
            sh "echo '{\"auths\":{\"https://index.docker.io/v1/\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}' > /kaniko/.docker/config.json"
          }
        }

        stage('Build image(s)'){
          valid.each{
            image = parseTag(it)
            runKaniko(image.name, image.version)
        }
      }
    }
  }
}

def runKaniko(String imageName, String imageVersion){
  sh """/kaniko/executor -f `pwd`/.jenkins/dockerfiles/$imageName/Dockerfile -c `pwd`  --cache=true --destination=$imageName:$imageVersion"""
}

def getHeadTags(){
  return sh (script: 'git tag --points-at HEAD', returnStdout: true).trim().split("\n")
}

def parseTag(String gitTag){
  if (gitTag.matches("^dockerfile=.*")){
      gitTag = gitTag.replaceAll("_",":")
      splittedTag = gitTag.tokenize('=:')

      def image = [name:splittedTag[1], version:splittedTag[2]]
      return image
  }
    return false
}
