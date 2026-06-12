data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = "t3.micro"
  subnet_id            = module.vpc.public_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  vpc_security_group_ids = [
    aws_security_group.web_app.id
  ]

  # O bloco user_data abaixo foi gerado com auxílio de IA (ChatGPT)
  user_data = <<-EOF
  #!/bin/bash
  dnf install -y httpd 
  systemctl enable httpd
  systemctl start httpd
  EOF

  tags = {
    Name = "learn-terraform"
  }
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda/index.js"
  output_path = "${path.module}/lambda/function.zip"
}

resource "aws_lambda_function" "app_lambda" {
  filename      = data.archive_file.lambda_package.output_path
  function_name = "app_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  code_sha256   = data.archive_file.lambda_package.output_base64sha256
  runtime = "nodejs20.x"
}
