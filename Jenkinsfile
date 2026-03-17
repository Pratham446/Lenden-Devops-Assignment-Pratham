pipeline {
    agent any

    environment {
        PROJECT_NAME = 'devsecops-app'
        TRIVY_REPORT = 'trivy-report.txt'
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        // ─────────────────────────────────────────
        // STAGE 1: Checkout
        // ─────────────────────────────────────────
        stage('Checkout') {
            steps {
                echo '============================================'
                echo ' STAGE 1: Checking out source code...'
                echo '============================================'
                checkout scm
                echo '✅ Source code checked out successfully'
                sh 'ls -la'
            }
        }

        // ─────────────────────────────────────────
stage('Infrastructure Security Scan') {
    steps {
        script {
            sh '''
                set -e  # Exit script on any error
                echo "Running Trivy scan..."
                docker run --rm -v $WORKSPACE:/workspace aquasec/trivy:latest \
                    config --severity HIGH,CRITICAL --format table \
                    /workspace/terraform > trivy-report.txt || { echo "❌ Trivy command failed"; exit 1; }

                cat trivy-report.txt

                if grep -qE "HIGH|CRITICAL" trivy-report.txt; then
                    echo "❌ Security scan failed: HIGH/CRITICAL vulnerabilities detected!"
                    exit 1
                else
                    echo "✅ No HIGH/CRITICAL vulnerabilities found."
                fi
            '''
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'trivy-report.txt', allowEmptyArchive: true
        }
    }
}

        // ─────────────────────────────────────────
        // STAGE 3: Terraform Plan (with AWS credentials)
        // ─────────────────────────────────────────
        stage('Terraform Plan') {
            steps {
                echo '============================================'
                echo ' STAGE 3: Running Terraform Plan...'
                echo '============================================'

                dir('terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {
                        sh '''
                            export AWS_DEFAULT_REGION=ap-south-1
                            terraform init -input=false
                            terraform validate
                            terraform plan -input=false -out=tfplan
                        '''
                    }
                }
            }
            post {
                success {
                    echo '✅ Terraform plan completed successfully'
                }
                failure {
                    echo '❌ Terraform plan failed — check configuration'
                }
            }
        }
    }

    post {
        success {
            echo '============================================'
            echo '✅ PIPELINE PASSED — All stages completed!'
            echo '============================================'
        }
        failure {
            echo '============================================'
            echo '❌ PIPELINE FAILED — Check logs above'
            echo '============================================'
        }
        always {
            echo "📦 Build #${BUILD_NUMBER} finished at ${new Date()}"
        }
    }
}
