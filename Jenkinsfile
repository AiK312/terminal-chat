pipeline {
    agent {
        label 'aws'
    }

	stages {

		stage('Prerequisites') {
			steps {
					sh """
						sudo yum -y update
						sudo yum -y install g++						
					"""
			}
		}

		stage('Compile') {
			steps {
					ssh """
						g++ --version
						g++ chatclient.cpp -lpthread -o ../chatclient						
					"""
			}
		}		
	}
}