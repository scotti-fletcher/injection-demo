resource "tls_private_key" "lab_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "lab_key"
  public_key = tls_private_key.lab_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.lab_key.private_key_pem
  # filename = "${path.module}/example-key.pem"
  filename = "~/lab_key.pem"
  file_permission = "0400"
}

output "private_key" {
  value     = tls_private_key.lab_key.private_key_pem
  sensitive = true
}

output "lab_key_name" {
  value = aws_key_pair.generated_key.key_name
}