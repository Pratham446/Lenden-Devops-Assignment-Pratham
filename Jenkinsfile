pipeline {
    agent any

    environment {
        PROJECT_NAME = 'devsecops-app'
        TRIVY_REPORT = 'trivy-report.txt'
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
        // STAGE 2: Infrastructure Security Scan
        // ─────────────────────────────────────────
        stage('Infrastructure Security Scan') {
            steps {
                echo '============================================'
                echo ' STAGE 2: Running Trivy Security Scan...'
                echo '============================================'

                script {
                    // Run Trivy scan and save report
                    def scanResult = sh(
                        script: """
                            trivy config ./terraform \
                                --severity LOW,MEDIUM,HIGH,CRITICAL \
                                --exit-code 0 \
                                --format table \
                                2>&1 | tee ${TRIVY_REPORT}
                        """,
                        returnStdout: true
                    ).trim()

                    echo scanResult

                    // Check for CRITICAL issues
                    def criticalCount = sh(
                        script: "grep -c 'CRITICAL' ${TRIVY_REPORT} || true",
                        returnStdout: true
                    ).trim().toInteger()

                    def highCount = sh(
                        script: "grep -c 'HIGH' ${TRIVY_REPORT} || true",
                        returnStdout: true
                    ).trim().toInteger()

                    echo '--------------------------------------------'
                    echo "🔍 Scan Summary:"
                    echo "   CRITICAL issues: ${criticalCount}"
                    echo "   HIGH issues    : ${highCount}"
                    echo '--------------------------------------------'

                    if (criticalCount > 0) {
                        echo '⚠️  ================================================'
                        echo '⚠️  CRITICAL VULNERABILITIES FOUND!'
                        echo '⚠️  Review the report above and use AI to fix them'
                        echo '⚠️  ================================================'
                        error("❌ Pipeline failed: ${criticalCount} CRITICAL security issue(s) found in Terraform code. Use AI remediation to fix.")
                    } else {
                        echo '✅ No CRITICAL vulnerabilities found. Proceeding...'
                    }
                }
            }
            post {
                always {
                    echo '📄 Trivy scan report saved to: trivy-report.txt'
                    archiveArtifacts artifacts: "${TRIVY_REPORT}", allowEmptyArchive: true
                }
                failure {
                    echo '❌ Security scan FAILED — fix vulnerabilities before proceeding!'
                }
                success {
                    echo '✅ Security scan PASSED — no critical issues!'
                }
            }
        }

        // ─────────────────────────────────────────
        // STAGE 3: Terraform Plan
        // ─────────────────────────────────────────
        stage('Terraform Plan') {
            steps {
                echo '============================================'
                echo ' STAGE 3: Running Terraform Plan...'
                echo '============================================'

                dir('terraform') {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -out=tfplan'
                    echo '✅ Terraform plan completed successfully'
                }
            }
            post {
                success {
                    echo '✅ Infrastructure plan is valid and ready for deployment'
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
            echo '❌ PIPELINE FAILED — Check stage logs above'
            echo '============================================'
        }
        always {
            echo "📦 Build #${BUILD_NUMBER} finished at ${new Date()}"
        }
    }
}
