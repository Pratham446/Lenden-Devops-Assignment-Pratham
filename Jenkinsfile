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
                # Run Trivy and capture output
                docker run --rm -v $WORKSPACE:/workspace aquasec/trivy:latest \
                    config --severity HIGH,CRITICAL --format table /workspace/terraform > trivy-report.txt
                cat trivy-report.txt
                # Check if any HIGH or CRITICAL issues found (exit code 1 if any)
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
        // STAGE 3: Terraform Plan (WITH AWS CREDS)
        // ─────────────────────────────────────────
        stage('Terraform Plan') {
            steps {
                echo '============================================'
                echo ' STAGE 3: Running Terraform Plan...'
                echo '============================================'

                dir('terraform') {

                    // 🔥 THIS IS WHERE withCredentials IS USED
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
