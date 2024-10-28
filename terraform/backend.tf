terraform {
  backend "s3" {
    bucket         = "s3-tf-statefile"
    encrypt        = true
    key            = "ec2-ansible-terraform/terraform.tfstate"
    region         = "us-east-1"
  }
}