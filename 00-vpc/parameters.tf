resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_sunet_ids" {
  name  = "/${var.project}/${var.environment}/public_sunet_ids"
  type  = "StringList"
  value = module.vpc.public_sunet_ids
}

