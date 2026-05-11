pipeline {
  agent any

  environment {
    APP_DIR = '/opt/college-project'
    EC2_USER = 'ubuntu'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Validate Docker Compose') {
      steps {
        sh 'docker compose config'
      }
    }

    stage('Build Images') {
      steps {
        sh 'docker compose build'
      }
    }

    stage('Deploy To EC2') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([
          sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY'),
          string(credentialsId: 'ec2-host', variable: 'EC2_HOST')
        ]) {
          sh '''
            ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$EC2_USER@$EC2_HOST" "
              cd $APP_DIR &&
              git pull origin main &&
              docker compose up -d --build &&
              docker image prune -f
            "
          '''
        }
      }
    }
  }
}

