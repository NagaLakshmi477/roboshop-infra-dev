module "frontend" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-sg-module.git?ref=main"
  project = var.project
  environment = var.environment

  
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_discription
 

  vpc_id = local.vpc_id

}

module "bastion" {
  source ="git::https://github.com/NagaLakshmi477/terraform-aws-sg-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_discription
 
  vpc_id = local.vpc_id

}
# bastion accepting my connection from laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

  security_group_id = module.bastion.sg_id
}

module "backend_alb" {
  source ="git::https://github.com/NagaLakshmi477/terraform-aws-sg-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name ="backend-alb"
  sg_description = "for backend alb"
 
  vpc_id = local.vpc_id

}


# backend alb accepting my connection from bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id

  security_group_id = module.backend_alb.sg_id
}

## sg for vpn

module "vpn" {
  source ="git::https://github.com/NagaLakshmi477/terraform-aws-sg-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "vpn"
  sg_description = "sg for Vpn"
 
  vpc_id = local.vpc_id

}

## vpnports 22,443


resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
# vpn internal ports 1194,943
resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id

  security_group_id = module.backend_alb.sg_id
}

module "mongodb" {
  source ="git::https://github.com/NagaLakshmi477/terraform-aws-sg-module.git?ref=main"
  project = var.project
  environment = var.environment

  sg_name = "mongodb"
  sg_description = "sg for mongodb"
 
  vpc_id = local.vpc_id

}


resource "aws_security_group_rule" "mongodb_vpn_shh" {
  type              = "ingress"
  from_port         = var.mongodb_ports_vpn[count.index]
  to_port           = var.mongodb_ports_vpn[count.index]
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id

  security_group_id = module.mongodb.sg_id
}