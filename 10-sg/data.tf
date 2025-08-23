data "aws_ssm_parameter" ""{
    name = "/${var.project}/${var.environment}/vpc_id"
   

}