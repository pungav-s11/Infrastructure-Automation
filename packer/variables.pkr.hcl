variable "aws_region" {
  type        = string
  description = "AWS region where the AMI will be created"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Temporary EC2 instance type used for building the AMI"
  default     = "t3.micro"
}

variable "ssh_username" {
  type        = string
  description = "SSH username for the Ubuntu AMI"
  default     = "ubuntu"
}

variable "ami_name" {
  type        = string
  description = "Base name of the generated AMI"
  default     = "image-bakery-ubuntu"
}