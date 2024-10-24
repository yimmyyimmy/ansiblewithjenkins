pipeline {
  agent {
    label "java"
  }
  stages {
    stage('Build') {
      steps{
        sh 'mvn clean install'
      }
    }  
    stage('jacoco') {
      steps{
        jacoco()
      }
    }
    /*
    stage('SonarQube analysis') {
      steps{
        script {
          def scannerHome = tool 'sonarqube_scanner';
          withSonarQubeEnv('sonarqube') {
            sh """
              ${scannerHome}/bin/sonar-scanner \
              -Dsonar.projectKey=javawebappproject \
              -Dsonar.projectName=javawebappproject \
              -Dsonar.projectVersion=1.0 \
              -Dsonar.java.binaries='target/classes'
            """
          }
        }
      }
    }
    

    stage("Sonar Quality Gate Check") {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    script {
                        def qualityGate = waitForQualityGate()
                        if (qualityGate.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                        }
                    }
                } // End of timeout
            }
    }
    */
    stage('Upload to Nexus') {
      steps{
         nexusArtifactUploader artifacts: [[artifactId: 'SimpleWebApplication', classifier: '', file: 'target/SimpleWebApplication.war', type: 'war']], credentialsId: 'nexus_credentials', groupId: 'com.maven', nexusUrl: '13.201.66.209:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-snapshots', version: '9.1.14-SNAPSHOT'
      }
    }
     stage('Deploy to Tomcat') {
          agent {
        label "ansible"
    }
      steps{
        sh 'echo "Here we deploy the build to tomcat"'
        sh 'pwd'
        sh 'ls -al'
        //sh 'scp -o StrictHostKeyChecking=no /home/jenkins/workspace/javapipeline/target/SimpleWebApplication.war root@3.111.53.14:/opt/apache-tomcat-10.1.30/webapps/'
        //sh 'scp -o StrictHostKeyChecking=no /home/jenkins/workspace/javapipeline/target/SimpleWebApplication.war root@3.111.53.14:/tmp'
        //deploy adapters: [tomcat9(credentialsId: '9ae28e96-08b4-43bd-a07d-418c21df2572', path: '', url: 'http://3.111.53.14:8080/')], contextPath: '/home/jenkins/workspace/javapipeline/target/', war: '**/SampleWebApplication.war'
          deploy adapters: [tomcat9(credentialsId: 'cat', path: '', url: 'http://13.232.91.175:8080/')], contextPath: null, war: '**/*.war'
        //deploy adapters: [tomcat9(credentialsId: '9ae28e96-08b4-43bd-a07d-418c21df2572', path: '', url: 'http://15.206.210.179:8080/')], contextPath: null, war: '**/SampleWebApplication.war'
      }
    }
/*
     stage('Send build artifacts over SSH') {
        steps{
                sshPublisher(publishers: [sshPublisherDesc(configName: 'Tomcat_Deploy', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'apache-tomcat-10.1.30/webapps', remoteDirectorySDF: false, removePrefix: 'target', sourceFiles: 'target/SimpleWebApplication.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: true)])
            }
        }
        */
     stage('ansible deploy') {
        agent {
        label "ansible"
    }
      steps{
        script {
 	        	sh """
                ansible-playbook /etc/ansible/playbooks/warbackup.yml -i /etc/ansible/hosts
            """
           }
      }
    }  
  }
}
