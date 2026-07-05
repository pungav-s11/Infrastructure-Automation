packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }

    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

#############################################
# AWS AMI Builder
#############################################

source "amazon-ebs" "ubuntu" {

  region        = var.aws_region
  instance_type = var.instance_type
  ssh_username  = var.ssh_username

  # Latest Ubuntu 24.04 LTS AMI
  source_ami_filter {

    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"] # Canonical
    most_recent = true
  }

  #############################################
  # AMI Name
  #############################################

  ami_name = "${var.ami_name}-${formatdate("YYYYMMDD-hhmmss", timestamp())}"

  #############################################
  # AMI Tags
  #############################################

  tags = {
    Name        = var.ami_name
    Project     = "ImageBakery"
    Environment = "Development"
    CreatedBy   = "Packer"
    OS          = "Ubuntu24.04"
  }

  #############################################
  # Temporary Builder EC2 Tags
  #############################################

  run_tags = {
    Name    = "packer-builder"
    Project = "ImageBakery"
    Purpose = "Temporary Build Instance"
  }

  #############################################
  # Root Volume
  #############################################

  launch_block_device_mappings {

    device_name           = "/dev/sda1"
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
  }

  #############################################
  # SSH Configuration
  #############################################

  temporary_key_pair_type = "ed25519"

  ssh_timeout = "10m"
}

#############################################
# Build Configuration
#############################################

build {

  name = "image-bakery-build"

  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  #############################################
  # Provision using Ansible
  #############################################

  provisioner "ansible" {

    playbook_file = "../ansible/playbook.yml"

    user = var.ssh_username

    use_proxy = false

    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]

    extra_arguments = [
      "--scp-extra-args",
      "-O"
    ]
  }

}