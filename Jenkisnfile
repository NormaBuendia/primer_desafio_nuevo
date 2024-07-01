pipeline {
    agent any

    environment {

        withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'terraform', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) 
    // some block

// Define las variables de entorno para las credenciales de AWS
        AWS_ACCESS_KEY_ID = credentials('awscredenciales_id')
        AWS_SECRET_ACCESS_KEY = credentials('awscredenciales_key_id')
        AWS_KEY_SSH = credentials('clave')
       
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout del repositorio
                    checkout scm
                }
            }
        }

        stage('Setup') {
            steps {
                script {
                    // Configura las credenciales de AWS para Terraform
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awscredenciales', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                        // Inicializa Terraform
                        sh 'terraform init terraform/'
                        
                        // Ejecuta el plan de Terraform
                        sh "terraform plan -out=tfplan terraform/"
                        
                        // Aplica los cambios en AWS
                        sh 'terraform apply -auto-approve terraform/'
                                         
                        // elimina
                        sh 'terraform destroy -auto-approve terraform/'

                    }
                }
            }
        }
    }
}
