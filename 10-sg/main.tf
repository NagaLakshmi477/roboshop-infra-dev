module "frontend" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  project = var.project
  vpc_id = local.vpc_id
  environment = var.environment
  sg_tags = var.sg_tags
  sg_description = var.frontend_sg_description
  sg_name = var.frontend_sg_name

  

}

  # project = var.project
  # sg_name = var.frontend_sg_name
  # frontend_sg_description = var.frontend_sg_description
  
  # # here vpc id comes from vpc check ssm-pars.io
  # vpc_id = local.vpc_id
  # environment = var.environment
