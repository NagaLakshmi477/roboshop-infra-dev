terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "5.98.0"
    }
  }
  backend "s3" {
    bucket = "s3-bucket-state-demo-dev1"
    key = "roboshop-dev-backend-alb"
    region = "us-east-1"
    use_lockfile =  true
    encrypt =  true
    
  }
}

provider "aws" {
    region = "us-east-1"
  
}