

module "frontend" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

module "bastion" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

module "backend_alb" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "backend-alb"
  sg_description = "for backend alb"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

# we need open some ports for vpn
module "vpn" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "vpn"
  sg_description = "for vpn"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

# bastion accepting connection from my laptop
# after creating we need to attach that sgid so bastion host s depend on sg
# so we can use parameter to store the sg_id from bastion
resource "aws_security_group_rule" "bastion_laptop" {
  type = "ingress"
  to_port = 22
  from_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
  
}

# backend ALB accepting connections from bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

# vpn ports 22,443,1194,943
resource "aws_security_group_rule" "vpn_shh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  
}

resource "aws_security_group_rule" "vpn_https" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  
}

resource "aws_security_group_rule" "vpn_1194" {
  type = "ingress"
  from_port = 1194
  to_port = 1194
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  
}

resource "aws_security_group_rule" "vpn_943" {
  type = "ingress"
  from_port = 943
  to_port = 943
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
  
}

# backend ALB accepting connections from my VPN host on port 80
resource "aws_security_group_rule" "backend_alb_vpn" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id
  
}

#mongodb sg

module "mongodb" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "mongodb"
  sg_description = "for mongodb"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}


module "redis" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "redis"
  sg_description = "for redis"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

module "mysql" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "mysql"
  sg_description = "for mysql"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

module "rabbitmq" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = "rabbitmq"
  sg_description = "for rabbitmq"
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}

# rules for rabbitmq
resource "aws_security_group_rule" "rabbitmq_vpn_ssh" {
  count = length(var.rabbitmq_ports_vpn)
  type = "ingress"
  from_port = var.rabbitmq_ports_vpn[count.index]
  to_port = var.rabbitmq_ports_vpn[count.index]
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
   source_security_group_id = module.vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
 
  
}

resource "aws_security_group_rule" "mysql_vpn_ssh" {
  count = length(var.mysql_ports_vpn)
  type = "ingress"
  from_port = var.mysql_ports_vpn[count.index]
  to_port = var.mysql_ports_vpn[count.index]
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
   source_security_group_id = module.vpn.sg_id
  security_group_id = module.mysql.sg_id
 
  
}

resource "aws_security_group_rule" "redis_vpn_ssh" {
  count = length(var.redis_ports_vpn)
  type = "ingress"
  from_port = var.redis_ports_vpn[count.index]
  to_port = var.redis_ports_vpn[count.index]
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
   source_security_group_id = module.vpn.sg_id
  security_group_id = module.redis.sg_id
 
  
}


# rules for mongodb
resource "aws_security_group_rule" "mongodb_vpn_ssh" {
  count = length(var.mongodb_ports_vpn)
  type = "ingress"
  from_port = var.mongodb_ports_vpn[count.index]
  to_port = var.mongodb_ports_vpn[count.index]
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.mongodb.sg_id
  source_security_group_id = module.vpn.sg_id
  
}

