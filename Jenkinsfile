pipeline {

  agent any
  stages {
    stage('Configure') {
      when { anyOf { branch 'main'; branch 'trial' } }
      steps {
        script {
          GIT_TAG = sh(returnStdout: true, script: "git tag | head -1").trim()
          echo "${GIT_TAG}"
          echo "$GIT_TAG"
          GIT_HASH = sh(returnStdout: true, script: "git rev-parse --short HEAD").trim()
          echo "$GIT_HASH"
       }
      }
    }

    // trial is optional and only goes to dev
   stage('Build and Publish trial image') {
      when {
            branch 'trial'
        }
      steps {
        echo 'Building and Pushing docker image to the registry...'
        script {
            if (GIT_TAG != "") {
              echo "$GIT_TAG"
              def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}:$GIT_TAG")
              docker.withRegistry(registryUri, registryCredentialsId){
                customImage.push()
              }
            } else {
                  echo "$GIT_HASH"
                  def devImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-dev:$GIT_HASH")
                  docker.withRegistry(registryUri, registryCredentialsId){
                    // push the dev with hash image
                    devImage.push()
                    // then tag with latest
                    devImage.push('latest')
                }
              }
        }
      }
   }
    stage('TrialDevDeploy') {
      when {
          branch 'trial'
        }
      steps {
          echo "Deploying to dev"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              }
          }
      }
    }   
   stage('Build and Publish dev image') {
      when {
            branch 'main'
        }
      steps {
        echo 'Building and Pushing docker image to the registry...'
        script {
            if (GIT_TAG != "") {
              echo "$GIT_TAG"
              def customImage = docker.build("registry.lts.harvard.edu/lts/${imageName}:$GIT_TAG")
              docker.withRegistry(registryUri, registryCredentialsId){
                customImage.push()
              }
            } else {
                  echo "$GIT_HASH"
                  def devImage = docker.build("registry.lts.harvard.edu/lts/${imageName}-dev:$GIT_HASH")
                  docker.withRegistry(registryUri, registryCredentialsId){
                    // push the dev with hash image
                    devImage.push()
                    // then tag with latest
                    devImage.push('latest')
                }
              }
        }
      }
    }
    stage('MainDevDeploy') {
      when {
          branch 'main'
        }
      steps {
          echo "Deploying to dev"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['hgl_svcupd']) {
                      sh "ssh -t -t ${env.DEV_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              }
          }
      }
    }  
    stage('Publish main qa image') {
      when {
            branch 'main'
        }
      steps {
        echo 'Pushing docker image to the registry...'
        echo "$GIT_TAG"
        script {
            if (GIT_TAG != "") {
              echo "Already pushed tagged image in dev deploy"
            } else {
                  echo "$GIT_HASH"
                  sh("docker pull registry.lts.harvard.edu/lts/${imageName}-dev:$GIT_HASH")
                  sh("docker tag registry.lts.harvard.edu/lts/${imageName}-dev:$GIT_HASH registry.lts.harvard.edu/lts/${imageName}-qa:$GIT_HASH")
                  qaImage = docker.image("registry.lts.harvard.edu/lts/${imageName}-qa:$GIT_HASH")
                  docker.withRegistry(registryUri, registryCredentialsId){
                    qaImage.push()
                    qaImage.push('latest')
                }
            }
        }
      }
    }
    stage('MainQADeploy') {
      when {
          branch 'main'
        }
      steps {
          echo "Deploying to qa"
          script {
              if (GIT_TAG != "") {
                  echo "$GIT_TAG"
                  sshagent(credentials : ['qatest']) {
                      sh "ssh -t -t ${env.QA_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              } else {
                      echo "$GIT_HASH"
                      sshagent(credentials : ['qatest']) {
                      sh "ssh -t -t ${env.QA_SERVER} '${env.STACK_COMMAND} ${env.HOME}${projName}${env.DOCKER} ${stackName}'"
                  }
              }
          }
      }
    }
   }
    post {
        fixed {
            script {
                if(env.BRANCH_NAME == "main" || env.BRANCH_NAME == "trial") {
                    // Specify your project channel here. Feel free to add/remove states that are relevant to your project (i.e. fixed, failure,...)
                    slackSend channel: "#hdc-3a", color: "##77caed", message: "Build Fixed: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                }
            }
        }
        failure {
            script {
                if(env.BRANCH_NAME == "main" || env.BRANCH_NAME == "trial") {
                    // Specify your project channel here. Feel free to add/remove states that are relevant to your project (i.e. fixed, failure,...)
                    slackSend channel: "#hdc-3a", color: "danger", message: "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                }
            }
        }
        success {
            script {
                if(env.BRANCH_NAME == "main" || env.BRANCH_NAME == "trial") {
                    // Specify your project channel here. Feel free to add/remove states that are relevant to your project (i.e. fixed, failure,...)
                    slackSend channel: "#hdc-3a", color: "good", message: "Build Succeeded: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                }
            }
        }
    }
   environment {
    imageName = 'curiosity'
    stackName = 'CURIOSITY'
    projName = 'curiosity'
    slackChannel = 'lts-curiosity-alerts'
    registryCredentialsId = "${env.REGISTRY_ID}"
    registryUri = 'https://registry.lts.harvard.edu'
   }
 }
