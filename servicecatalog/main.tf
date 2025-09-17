provider "aws" {
  region = "us-west-1"
}

# Portfolio
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

# Portfolio-Product Association
resource "aws_servicecatalog_portfolio_product_association" "association" {
  portfolio_id = aws_servicecatalog_portfolio.ec2_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}

# Outputs
output "portfolio_id" {
  value = aws_servicecatalog_portfolio.ec2_portfolio.id
}

output "product_id" {
  value = aws_servicecatalog_product.ec2_product.id
}
