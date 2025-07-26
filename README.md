# Multi-Service-Node.js-E-commerce-Application-Using-Terraform-and-Docker-Skill-Test-3


Create **Dockerfile**s for Each Service

Create five folders: **user, products, orders, cart, frontend**. Each folder contains:
Example: user/Dockerfile
FROM node:18
WORKDIR /app
COPY . .
EXPOSE 3001
CMD ["node", "-e", "require('http').createServer((_,res)=>res.end('User Service Running')).listen(3001)"]




- products → port 3002 → "Products Service Running"
- orders → port 3003 → "Orders Service Running"
- cart → port 3004 → "Cart Service Running"
- frontend → port 3000 → "Frontend is Live"


**Build and Test Docker Images Locally**

docker build -t user-service ./user
docker run -p 3001:3001 user-service


**Tag and Push to DockerHub**


docker tag user-service yourdockerhub/user-service
docker push yourdockerhub/user-service
Infrastructure Provisioning with Terraform
2.1 Project Structure
terraform/
├── main.tf
├── variables.tf
├── outputs.tf


2.2 variables.tf
variable "region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "dockerhub_username" {
  default = "yourdockerhub"
}


2.3 main.tf
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
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                         = "ami-0c02fb55956c7d316" # Ubuntu 22.04 in us-east-1
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


2.4 outputs.tf
output "frontend_public_ip" {
  value = aws_instance.app.public_ip
}



🚀 Step 3: Deployment and Accessibility
3.1 Apply Terraform
terraform init
terraform apply -auto-approve


Infrastructure Provisioning with Terraform
2.1 Project Structure
terraform/
├── main.tf
├── variables.tf
├── outputs.tf


2.2 variables.tf
variable "region" {
  default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "dockerhub_username" {
  default = "yourdockerhub"
}


2.3 main.tf
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
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  ami                         = "ami-0c02fb55956c7d316" # Ubuntu 22.04 in us-east-1
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


2.4 outputs.tf
output "frontend_public_ip" {
  value = aws_instance.app.public_ip
}



🚀 **Step 3: Deployment and Accessibility**

3.1 Apply Terraform
terraform init
terraform apply -auto-approve


**3.2 Verify Deployment**
- Visit http://<frontend_public_ip>:3000 → should show “Frontend is Live”
- SSH into EC2 and run:
docker ps
curl localhost:3001  # Should return "User Service Running"


**3.3 Output**
Terraform will display:
frontend_public_ip = "XX.XX.XX.XX"


Use this IP to access the frontend.

✅ Summary
| Component | Tool Used | Status | 
| Dockerized Services | Docker | ✅ | 
| Infrastructure | Terraform | ✅ | 
| EC2 Setup | User Data | ✅ | 
| Public Access | Security Group | ✅ | 
| Frontend Live | Browser Test | ✅ | 




- Visit http://<frontend_public_ip>:3000 → should show “Frontend is Live”
- SSH into EC2 and run:
docker ps
curl localhost:3001  # Should return "User Service Running"


**3.3 Output**
Terraform will display:
frontend_public_ip = "XX.XX.XX.XX"


Use this IP to access the frontend.

✅ **Summary**
| Component | Tool Used | Status | 
| Dockerized Services | Docker | 
| Infrastructure | Terraform | 
| EC2 Setup | User Data | 
| Public Access | Security Group | 
| Frontend Live | Browser Test | 


<img width="308" height="37" alt="image" src="https://github.com/user-attachments/assets/52374cd7-b302-480a-b092-e85ae88f7aef" />
<img width="220" height="113" alt="image" src="https://github.com/user-attachments/assets/eb304399-adc8-4091-8edf-73fcf7563276" />
<img width="1173" height="228" alt="image" src="https://github.com/user-attachments/assets/e116d103-3b7d-402f-822b-ea592443ae28" />
<img width="1516" height="807" alt="image" src="https://github.com/user-attachments/assets/62301025-a673-4dfd-9545-c67ba18afb5c" />
<img width="1446" height="673" alt="image" src="https://github.com/user-attachments/assets/53e43edc-9b67-4adf-a5d0-13f303654249" />















