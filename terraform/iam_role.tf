resource "aws_iam_role" "flappy_lab_role" {
  name = "FlappyLabRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.flappy_lab_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "flappy_lab_profile" {
  name = "FlappyLabInstanceProfile"
  role = aws_iam_role.flappy_lab_role.name
}