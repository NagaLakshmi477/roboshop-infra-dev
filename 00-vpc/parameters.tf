resource "aws_ssm_parameter" "vpc" {
  name = "/${var.project}/${var.environment}/vpc_id"
  type = "String"
  value = module.vpc.vpc_id
}