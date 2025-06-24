# Data source to get the existing VPC
data "aws_vpc" "wizlabs_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Wizlabs-VPC"]
  }
}

# Data source to get subnets in the VPC
data "aws_subnet" "wizlabs_public_subnets" {
  vpc_id = data.aws_vpc.wizlabs_vpc.id
  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

resource "aws_security_group" "lab_sg" {
  name        = "lab-instance-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = data.aws_vpc.wizlabs_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-instance-sg"
  }
}