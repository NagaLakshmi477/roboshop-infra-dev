

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

#bastion accepting connection from my laptop
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
