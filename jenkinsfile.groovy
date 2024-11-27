pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'myapp_image'
        REGISTRY = 'mydockerregistry'
        K8S_NAMESPACE = 'mynamespace'
        SONARQUBE = 'sonarqube-server'  // Tên của server SonarQube đã cấu hình
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${REGISTRY}/${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Chạy các test tự động (ví dụ: unit tests, integration tests)
                    sh 'mvn test'  // Ví dụ với Maven nếu sử dụng Java
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Kiểm tra chất lượng mã nguồn với SonarQube
                    withSonarQubeEnv('sonarqube-server') {
                        sh 'mvn sonar:sonar'  // Lệnh phân tích mã nguồn của Maven 
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    // Kiểm tra kết quả phân tích từ SonarQube và đảm bảo mã đạt chất lượng
                    timeout(time: 1, unit: 'HOURS') {
                        def qualityGate = waitForQualityGate()  // Kiểm tra chất lượng mã nguồn
                        if (qualityGate.status != 'OK') {
                            error "Pipeline failed due to quality gate failure"
                        }
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Đẩy image lên Docker registry
                    docker.push("${REGISTRY}/${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        stage('Security Check - Snyk') {
            steps {
                script {
                    // Kiểm tra bảo mật với Snyk (có thể thay bằng Trivy)
                    sh 'snyk test'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy ứng dụng lên Kubernetes
                    sh 'kubectl apply -f k8s/deployment.yaml --namespace=${K8S_NAMESPACE}'
                }
            }
        }
    }
    post {
        always {
            cleanWs()  // Dọn dẹp workspace sau khi hoàn tất
        }
    }
}
