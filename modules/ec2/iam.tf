resource "aws_iam_role" "role" {
  name = "${var.name}-${var.env_name}-ec2-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.name}-${var.env_name}-ec2-role"
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.name}-${var.env_name}-ec2-role"
  role = aws_iam_role.role.name
}