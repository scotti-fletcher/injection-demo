resource "aws_security_group" "webserver_sg" {
  name        = "lab-webserver-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = data.aws_vpc.wizlabs.id

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
    Name = "lab-webserver-sg"
  }
}

resource "aws_security_group" "attacker_sg" {
  name        = "lab-attacker-sg"
  description = "Allow all ingress and egress traffic"
  vpc_id      = data.aws_vpc.wizlabs.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab-attacker-sg"
  }
}