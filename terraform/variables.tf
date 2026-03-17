variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for tagging resources"
  type        = string
  default     = "devsecops-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS AMI ID for ap-south-1"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "public_key" {
  description = "SSH public key for EC2 key pair"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvLRIoGO9FDmtJ5ycGnAnWZf5ic1+9K4VALWEne2jc9EnA2ORfoQnlQeRwsx1A1JOKDrymefmUk3qlxQ1C0clvzu4en+jQ9YPZLx/emrZYPGcvsdy/nk7+RlAqee1b+t+23HlYOXrRoRzRTinxqb0b4ZpZ/1zybtoD6TUhCFR5Jl7chLpicAv52t7snt5wP5PXLJVBYqp4hlUXi9RQxnypKllhcimr8IaB38sdo0lTHk/Xtt30NkNR7hZ6pjEJSS6K1+Z+evR3AeIuPzXC2UvXmpl9ZJbM8dgk0HCsF0EiNuBcxeWzKxnF4vg36q6AT4iJJX4YwvXSw76fS29kFqBD vrajm@LAPTOP-S0DVK14V"
}
