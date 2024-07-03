# Terraform output
output "ec2_public_ip" {
  value = aws_instance.instance_nueva.public_ip
}