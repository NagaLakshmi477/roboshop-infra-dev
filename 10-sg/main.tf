

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