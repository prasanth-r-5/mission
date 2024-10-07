pipeline {
    agent any
    tools {
        jdk 'jdk-17'
        maven 'maven-3'
    }
    
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    
    stages {
        stage ('clone the repo') {
            steps {
                git branch: 'main', changelog: false, poll: false, url: 'https://github.com/prasanth-r-5/mission.git'
            }
        }
        stage ('compile') {
            steps {
                sh 'mvn compile'
            }
        }
        stage ('test') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }
        stage ('file scane') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-mission-report.html .'
            }
        }
        stage ('sonar scanning') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=Mission -Dsonar.projectName=Mission \
                           -Dsonar.java.binaries=target/classes -X '''
                }
            }
        }
        stage ('maven build') {
            steps {
                sh 'mvn package -DskipTests=true'
            }
        }
        stage ('build docker image') {
            steps {
                withDockerRegistry(credentialsId: 'Dockerhub-ID', url: 'https://registry-1.docker.io') {
                    sh 'docker build -t prasanthr5/mission:latest .'
                }
            }
        }
        // stage ('scane the image') {
        //     steps {
        //         sh 'trivy image  --scanners vuln --format table -o trivy-image-mission-report.html prasanthr5/mission:latest '
        //     }
        // }
        stage ('deploy docker image') {
            steps {
                withDockerRegistry(credentialsId: 'Dockerhub-ID', url: 'https://registry-1.docker.io') {
                    sh 'docker run -d --name mission -p 8081:8080 prasanthr5/mission:latest' 
                }
            }
        }
    }
}
