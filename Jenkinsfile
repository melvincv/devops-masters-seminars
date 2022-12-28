pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-port-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-port-secret-key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
