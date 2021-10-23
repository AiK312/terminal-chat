pipeline {
    agent {
        label 'aws'
    }

	stages {
		stage('Prerequisites') {
			steps {
				sh """
					yum update -y
					yum install -y g++
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