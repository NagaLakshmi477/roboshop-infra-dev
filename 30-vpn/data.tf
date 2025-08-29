data "aws_ami" "joindevops"{
  owners = [] #need togive ami id of vpn"
  most_recent = true
    filter {
      name = "name"
      values = ["Open VPN acess community image id "]
    }
     filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "vpn_sg_id" {
    name = "/${var.project}/${var.environment}/vpn_sg_id"
  
}
# for subnet region
data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.environment}/public_subnet_ids"
  
}
