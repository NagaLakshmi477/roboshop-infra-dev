

module "frontend" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-security-group.git?ref=main"
  sg_name = var.frontend_sg_name
  sg_description = var.frontend_sg_description
  environment = var.environment
  project = var.project
  sg_tags = var.sg_tags
  vpc_id = local.vpc_id
}