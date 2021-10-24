pipeline {
    agent {
        label 'aws'
    }

	environment {		
		SLACK_CHANNEL = 'aik-messages'		
		IP_ADDRESS = "undefined"
		PORT = "31279"
	}

	stages {

		stage('Prerequisites') {
			steps {
					sh """
						sudo yum -y update
						sudo yum -y install gcc-c++	curl
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
						g++ chatclient.cpp -lpthread -o ../Chat-Terminal/Client/chatclient
						g++ chatserver.cpp -lpthread -o ../Chat-Terminal/Server/chatserver						
					"""
			}
		}

		stage('Test stage') {
			steps {
					sh """
						pwd
						uptime
					"""
			}
		}		
	}

	post {
	failure {
		slackSend channel: "${ SLACK_CHANNEL }", color: 'danger', message: "${ env.JOB_NAME } ${ env.BUILD_NUMBER } failed (<${ env.BUILD_URL }|Open>)"
	}

	post {
		success {
			slackSend channel: "${ SLACK_CHANNEL }", color: 'good', message: "${ env.JOB_NAME} ${ env.BUILD_NUMBER } complete (<${ env.BUILD_URL }|Open>)"
		}
	}
}