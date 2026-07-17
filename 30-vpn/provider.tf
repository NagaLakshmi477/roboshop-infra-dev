terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
  backend "s3" {
    bucket       = "roboshop-remote-states-dev1"
    key          = "roboshop-dev-openvpn"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true

  }
}

provider "aws" {
  region = "us-east-1"

}