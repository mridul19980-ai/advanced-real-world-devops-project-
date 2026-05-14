resource "aws_vpc" "college_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "college-project-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.college_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "college-public-subnet"
  }
}

resource "aws_internet_gateway" "college_igw" {
  vpc_id = aws_vpc.college_vpc.id

  tags = {
    Name = "college-project-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.college_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.college_igw.id
  }

  tags = {
    Name = "college-public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "college_project_sg" {
  name   = "docker-app-sg"
  vpc_id = aws_vpc.college_vpc.id

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

  ingress {
    from_port   = 3000
    to_port     = 3000
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
    Name = "college-project-sg"
  }
}

resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = "m7i-flex.large"
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.college_project_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              sudo apt install -y fontconfig openjdk-21-jre
              java -version
              EOF
  tags = {
    Name = "Docker-App-Server"
  }
}