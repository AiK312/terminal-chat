pipeline {
    agent {
        label 'aws'
    }

    environment {
        SLACK_CHANNEL = 'aik-messages'
        IP_ADDRESS = 'undefined'
        PORT = '31279'
        IMAGE_NAME_SERVER = 'chat-server'
        IMAGE_NAME_CLIENT = 'chat-client'
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
                    ls -la
                    echo "Building image: ${IMAGE_NAME_SERVER}"
                    sudo docker build --label ${IMAGE_NAME_SERVER} --tag ${IMAGE_NAME_SERVER}:latest . 
                    echo "Building image: ${IMAGE_NAME_CLIENT}"
                    sudo docker build --label ${IMAGE_NAME_CLIENT} --tag ${IMAGE_NAME_CLIENT}:latest . 
                    ls -la
                """
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
