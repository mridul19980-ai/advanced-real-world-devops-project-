variable "aws_region" {
  description = "AWS region for EC2 deployment."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name used for AWS resources."
  type        = string
  default     = "college-project"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing EC2 key pair name."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into EC2, for example 1.2.3.4/32."
  type        = string
}

variable "repository_url" {
  description = "Git repository URL to clone on EC2."
  type        = string
}

variable "repository_branch" {
  description = "Git branch to deploy."
  type        = string
  default     = "main"
}

variable "mysql_database" {
  description = "MySQL database name."
  type        = string
  default     = "college_app"
}

variable "mysql_user" {
  description = "MySQL app user."
  type        = string
  default     = "college_user"
}

variable "mysql_password" {
  description = "MySQL app password."
  type        = string
  sensitive   = true
}

variable "mysql_root_password" {
  description = "MySQL root password."
  type        = string
  sensitive   = true
}

