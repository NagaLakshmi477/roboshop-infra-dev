module "alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true # private lb
  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids

  # Security Group already created so no need to create here agin
  create_security_group = false
  security_groups = [local.backend_alb_sg_id]
# we will create load blancers and listens separately


  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-backend-alb"
    }
  )
}