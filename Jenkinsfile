pipeline {
    agent {
        label 'app-node'
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/mridul19980-ai/advanced-real-world-devops-project-.git'
            }
        }

        stage('Install Docker Using Script') {
            steps {
                sh '''
                chmod +x ec2-setup.sh
                ./ec2-setup.sh
                '''
            }
        }

        stage('Verify Docker Installation') {
            steps {
                sh '''
                docker --version
                docker compose version
                '''
            }
        }
        stage('Create Env File') {
            steps {
              withCredentials([
              string(credentialsId: 'mysql-database', variable: 'MYSQL_DATABASE'),
              string(credentialsId: 'mysql-user', variable: 'MYSQL_USER'),
              string(credentialsId: 'mysql-password', variable: 'MYSQL_PASSWORD'),
              string(credentialsId: 'mysql-root-password', variable: 'MYSQL_ROOT_PASSWORD')
        ]) {
            sh '''
            cat > .env <<EOF
       MYSQL_DATABASE=${MYSQL_DATABASE}
       MYSQL_USER=${MYSQL_USER}
       MYSQL_PASSWORD=${MYSQL_PASSWORD}
       MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
       EOF

            chmod 600 .env
            '''
        }
    }
        stage('Stop Old Containers') {
            steps {
                sh '''
                docker compose down || true
                '''
            }
        }

        stage('Build and Deploy App') {
            steps {
                sh '''
                docker compose up -d --build
                '''
            }
        }

        stage('Check Running Containers') {
            steps {
                sh '''
                docker ps
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD deployment successful on EC2'
        }

        failure {
            echo 'CI/CD deployment failed'
        }
    }
}
}
