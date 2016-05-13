# These are all examples of things you can do in your variables.tf file
# This central file is linked to from all your stack subdirs by the makelinks.bash script

# AWS access variables. we recommend getting these out of your terraform.tfvars
variable "aws_access_key" {}
variable "aws_secret_access_key" {}

# default region (eg. us-east-1, eu-central-1, etc.)
variable "region" {default = "us-east-1"}

# your VPC ID
variable "vpc_id" {default = "vpc-12345678"}

# array of AMI IDs
variable "ami" {
    default = {
      pv = "ami-12345678"
      hv = "ami-87654321"
    }
}
