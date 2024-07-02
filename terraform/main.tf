# Proveedor de AWS
provider "aws" {
    region = "us-west-2"
}

# Definición de la VPC
resource "aws_vpc" "nueva_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "nuevaVPC"
  }
}

# Definición de una subred pública
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.nueva_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "SubnetPublica"
  }
}

# Definición de una subred privada
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.nueva_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "SubnetPrivada"
  }
}

# Definicion de grupo de seguridad
resource "aws_security_group" "security_group" {
  name        = "security_group"
  description = "Security group for example"

   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# Reglas de ingreso 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Reglas de salida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Definición de la instancia EC2
resource "aws_instance" "instance_nueva" {
  ami           = "ami-0f226ae5ce4b11922"  
  instance_type = "t2.micro" 
  // Especifica el nombre de tu clave par de claves en aws
  key_name      = "awsnueva"             

  # Asignación del security group creado arriba
  vpc_security_group_ids = [aws_security_group.security_group.id]

  # Asignación de nombre a la instancia (tag)
  tags = {
    Name = "instance_nueva"
  }	

 user_data = <<-EOF

            #!/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install -y nginx1

            # Iniciar y habilitar Nginx
            sudo systemctl start nginx
            sudo systemctl enable nginx

            # Verificar la ubicación actual y el contenido de /terraform/
            ls -l /terraform

            # Mensaje de depuración
            echo "Copiando index.html desde terraform/ a /tmp/"

            # Copiar index.html a /tmp (verifica que /terraform/index.html existe y es accesible)
            sudo cp terraform/index.html /tmp/index.html 

            # Mover index.html a la carpeta de Nginx y ajustar permisos
            sudo mv /tmp/index.html /usr/share/nginx/html/index.html
            sudo chown nginx:nginx /usr/share/nginx/html/index.html
            sudo chmod 644 /usr/share/nginx/html/index.html

            # Reiniciar Nginx para aplicar los cambios
            sudo systemctl restart nginx
            EOF

}

