pipeline {
    agent {
        label 'aws'
    }

    environment {
        SLACK_CHANNEL = 'aik-messages'
        IP_ADDRESS = 'undefined'
        PORT = '31279'
        IMAGE_NAME_SERVER = 'terminal-chat-server'
        IMAGE_NAME_CLIENT = 'terminal-chat-client'
        PASSWORD_CREDENTIALS_ID = 'dockerhub'   
    }

    stages {
        stage('Prerequisites') {
            steps {
                sh """
                    sudo yum -y update
                    sudo yum -y install gcc-c++ curl
                    IP_ADDRESS=\$(curl eth0.me)
                    mkdir -p ../Chat-Terminal/Client
                    mkdir -p ../Chat-Terminal/Server
                    printenv
                """
            }
        }

        stage('Get Version') {
            steps {
                echo "Get version from package.json"
                script {
                    packageJson = readJSON(file: 'package.json')
                    VERSION_SERVER = packageJson.versionServer
                    VERSION_CLIENT = packageJson.versionClient
                }  
            }
        }

        stage('Compile') {
            steps {
                sh """
                    g++ --version
                    g++ chatclient.cpp -lpthread -o chatclient
                    g++ chatserver.cpp -lpthread -o chatserver
                """
            }
        }

        stage('Check Version') {
            steps {
                sh """
                    docker --version
                    git --version
                """
            }
        }

        stage("Build docker image") {
            steps {
                echo "Build server and client docker images"
                sh """
                    pwd                    
                    echo "Building image: ${IMAGE_NAME_SERVER}"
                    sudo docker build --label ${IMAGE_NAME_SERVER} --tag ${IMAGE_NAME_SERVER}:${VERSION_SERVER} --tag ${IMAGE_NAME_SERVER}:latest . 
                    echo "Building image: ${IMAGE_NAME_CLIENT}"
                    sudo docker build --label ${IMAGE_NAME_CLIENT} --tag ${IMAGE_NAME_CLIENT}:${VERSION_CLIENT} --tag ${IMAGE_NAME_CLIENT}:latest . 
                    sudo docker images                    
                """
            }
        }

        stage("Push docker image") {
            steps {
                withCredentials([usernamePassword(credentialsId: env.PASSWORD_CREDENTIALS_ID, usernameVariable: 'REPOSITORY_USERNAME', passwordVariable: 'REPOSITORY_PASSWORD')]) {
                    echo "Pushing images to docker hub registry"
                    sh """
                        sudo docker login -u ${REPOSITORY_USERNAME} -p ${REPOSITORY_PASSWORD}
                        sudo docker tag ${IMAGE_NAME_SERVER}:${VERSION_SERVER} ${REPOSITORY_USERNAME}/${IMAGE_NAME_SERVER}:${VERSION_SERVER}
                        sudo docker tag ${IMAGE_NAME_SERVER}:latest ${REPOSITORY_USERNAME}/${IMAGE_NAME_SERVER}:latest
                        sudo docker tag ${IMAGE_NAME_CLIENT}:${VERSION_CLIENT} ${REPOSITORY_USERNAME}/${IMAGE_NAME_CLIENT}:${VERSION_CLIENT}
                        sudo docker tag ${IMAGE_NAME_CLIENT}:latest ${REPOSITORY_USERNAME}/${IMAGE_NAME_CLIENT}:latest

                        sudo docker push "${REPOSITORY_USERNAME}/${IMAGE_NAME_SERVER}:${VERSION_SERVER}"
                        sudo docker push "${REPOSITORY_USERNAME}/${IMAGE_NAME_SERVER}:latest"
                        sudo docker push "${REPOSITORY_USERNAME}/${IMAGE_NAME_CLIENT}:${VERSION_CLIENT}"
                        sudo docker push "${REPOSITORY_USERNAME}/${IMAGE_NAME_CLIENT}:latest"                        
                    """
                }
            }
        }
    }

    post {
        failure {
            slackSend channel: "${ SLACK_CHANNEL }", color: 'danger', message: "${ env.JOB_NAME } ${ env.BUILD_NUMBER } failed (<${ env.BUILD_URL }|Open>)"
        }

        success {
            slackSend channel: "${ SLACK_CHANNEL }", color: 'good', message: "${ env.JOB_NAME} ${ env.BUILD_NUMBER } complete (<${ env.BUILD_URL }|Open>)"
        }
    }
}
