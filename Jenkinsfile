pipeline {
    agent {
        label 'aws'
    }

	stages {
		stage('Prerequisites') {
			steps {
				sh """
					apt update -y
					apt install -y g++
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