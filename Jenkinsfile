pipeline {
    agent {
        label 'JenkinsSlaveAWS'
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
	}
}