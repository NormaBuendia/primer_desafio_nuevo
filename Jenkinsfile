pipeline {
    agent any
     parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Aprobar automáticamente.')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Seleccione la acción a realizar.')
    }

    environment {
        // Define las variables de entorno para las credenciales de AWS
        AWS_KEY_SSH = credentials('awsnueva') 
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

        stage('Ejecutando Init y Plan') {
            steps {
                script {
                    // Configura las credenciales de AWS para Terraform
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awscredenciales', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    
                        // Inicializa Terraform
                        print '########## Configurando terraform... ##########'
                        sh 'terraform init terraform/'
                        
                        // Ejecuta el plan de Terraform
                        print '########## Ejecutando plan de terraform... ##########'
                        sh "terraform plan -out=tfplan terraform/"
                    }
                }
            }
        }

        stage('Ejecutando Apply o Destroy') {
            steps {
                script {
                    // Configura las credenciales de AWS para Terraform
                    withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'awscredenciales', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        if(params.action == 'apply') {
                             // Aplica los cambios en AWS
                        print '########## Ejecutando apply... ##########'
                        sh 'terraform apply -auto-approve terraform/'     
                        }
                        else if(params.action == 'destroy') {
                           // elimina
                        print '########## Ejecutando destroy... ##########'
                        sh 'terraform destroy -auto-approve terraform/'  
                        }   
                        else {
                            error 'Parametro incorrecto'
                        }      
                       
                    }
                }
            }
        }
    }
}
