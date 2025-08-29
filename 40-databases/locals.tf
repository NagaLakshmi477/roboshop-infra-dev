
locals {
  ami_id = data.aws_ami.joindevops.id
  mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
  redis_sg_id = data.aws_ssm_parameter.redis_sg_id
  rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id
  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id
  database_subnet_id = split(",",data.aws_ssm_parameter.database_subnet_id.value)[0]
  
  
  common_tags = {
    Project = var.project
    Environment = var.environment
    Terraform = "true"
  }
}