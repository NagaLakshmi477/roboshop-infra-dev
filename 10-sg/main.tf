module "frontend" {
  #source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  source = "../../terraform-aws-security-group"
  project = var.project
  frontend_sg_description = var.frontend_sg_description
  frontend_sg_name = var.frontend_sg_name
  # here vpc id comes from vpc check ssm-pars.io
  vpc_id = var.vpc_id 
  environment = var.environment

}