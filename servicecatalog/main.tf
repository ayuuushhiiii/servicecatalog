terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3"
}

provider "aws" {
  region = "us-west-1"
}

variable "instance_type" { default = "t2.micro" }
variable "ami_id"        { default = "ami-020cba7c55df1f615" }
variable "subnet_id"     { default = "subnet-05d699a18f9aa8e91" }

# Service Catalog Portfolio
resource "aws_servicecatalog_portfolio" "ec2_portfolio" {
  name          = "EC2 Portfolio"
  description   = "Portfolio for EC2 instances"
  provider_name = "MyTeam"
}

# Service Catalog Product
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

# Provision EC2 instance from Service Catalog
resource "aws_servicecatalog_provisioned_product" "ec2_instance" {
  name                     = "My-EC2-From-ServiceCatalog"
  product_id               = aws_servicecatalog_product.ec2_product.id
  # Use the provisioning artifact ID from the AWS console
  provisioning_artifact_id = "pa-xxxxxxxxxxxx"  

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
output "portfolio_id" { value = aws_servicecatalog_portfolio.ec2_portfolio.id }
output "product_id"   { value = aws_servicecatalog_product.ec2_product.id }
output "provisioned_product_id" { value = aws_servicecatalog_provisioned_product.ec2_instance.id }
