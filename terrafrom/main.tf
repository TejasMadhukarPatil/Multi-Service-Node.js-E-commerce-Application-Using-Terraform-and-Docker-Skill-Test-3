provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow HTTP and internal traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                         = "ami-0c02fb55956c7d316" # Ubuntu 22.04 LTS
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install docker.io -y
              systemctl start docker

              docker pull ${var.dockerhub_username}/user-service
              docker pull ${var.dockerhub_username}/products-service
              docker pull ${var.dockerhub_username}/orders-service
              docker pull ${var.dockerhub_username}/cart-service
              docker pull ${var.dockerhub_username}/frontend-service

              docker run -d -p 3001:3001 ${var.dockerhub_username}/user-service
              docker run -d -p 3002:3002 ${var.dockerhub_username}/products-service
              docker run -d -p 3003:3003 ${var.dockerhub_username}/orders-service
              docker run -d -p 3004:3004 ${var.dockerhub_username}/cart-service
              docker run -d -p 3000:3000 ${var.dockerhub_username}/frontend-service
              EOF

  tags = {
    Name = "EcommerceApp"
  }
}
