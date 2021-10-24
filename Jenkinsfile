pipeline {
    agent {
        label 'aws'
    }

	environment {		
		//SLACK_CHANNEL = ''		
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
}