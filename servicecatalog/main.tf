terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  required_version = ">= 1.3"
}

provider "aws" {
  region = "us-west-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-020cba7c55df1f615"
}

variable "subnet_id" {
  default = "subnet-05d699a18f9aa8e91"
}

 Portfolio
resource "aws_servicecatalog_portfolio" "ec2_portfolio" {
  name          = "EC2 Portfolio"
  description   = "Portfolio for EC2 instances"
  provider_name = "MyTeam"
}

# Product
resource "aws_servicecatalog_product" "ec2_product" {
  name  = "Simple EC2 Instance"
  owner = "MyTeam"
  type  = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name         = "v1"
    description  = "Initial version"
    type         = "CLOUD_FORMATION_TEMPLATE"
    template_url = "https://servicecatalogbucket01.s3.us-west-1.amazonaws.com/ec2-Template.yml"
  }
}

# Portfolio-Product Association (top-level, not nested)
resource "aws_servicecatalog_portfolio_product" "association" {
  portfolio_id = aws_servicecatalog_portfolio.ec2_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}

# Data source to fetch artifact ID
data "aws_servicecatalog_provisioning_artifact" "ec2_artifact" {
  product_id = aws_servicecatalog_product.ec2_product.id
  name       = "v1"
}

# Provision EC2 instance
resource "aws_servicecatalog_provisioned_product" "ec2_instance" {
  name                     = "My-EC2-From-ServiceCatalog"
  product_id               = aws_servicecatalog_product.ec2_product.id
  provisioning_artifact_id = data.aws_servicecatalog_provisioning_artifact.ec2_artifact.id

  provisioning_parameters {
    key   = "InstanceType"
    value = var.instance_type
  }

  provisioning_parameters {
    key   = "AmiId"
    value = var.ami_id
  }

  provisioning_parameters {
    key   = "SubnetId"
    value = var.subnet_id
  }
}

# Outputs
output "portfolio_id" {
  value = aws_servicecatalog_portfolio.ec2_portfolio.id
}

output "product_id" {
  value = aws_servicecatalog_product.ec2_product.id
}

output "provisioned_product_id" {
  value = aws_servicecatalog_provisioned_product.ec2_instance.id
}