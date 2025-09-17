resource "aws_servicecatalog_portfolio" "ec2_portfolio" {
  name          = "EC2 Portfolio"
  description   = "Portfolio for EC2 instances"
  provider_name = "MyTeam"
}

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

resource "aws_servicecatalog_portfolio_product_association" "association" {
  portfolio_id = aws_servicecatalog_portfolio.ec2_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}
# Provision EC2 instance from Service Catalog
resource "aws_servicecatalog_provisioned_product" "ec2_instance" {
  name                     = "My-EC2-From-ServiceCatalog"
  product_id               = aws_servicecatalog_product.ec2_product.id
  provisioning_artifact_id = aws_servicecatalog_product.ec2_product.provisioning_artifact_ids[0]

  provisioning_parameters {
    key   = "InstanceType"
    value = "t2.micro"
  }

  provisioning_parameters {
    key   = "AmiId"
    value = "ami-020cba7c55df1f615" # Replace with a valid AMI in us-west-1
  }

  provisioning_parameters {
    key   = "SubnetId"
    value = "subnet-05d699a18f9aa8e91" # Replace with a subnet ID from your VPC
  }

  # provisioning_parameters {
  #   key   = "KeyName"
  #   value = "your-keypair-name" # Replace with your existing EC2 keypair
  # }
}

