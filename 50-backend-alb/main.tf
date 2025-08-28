module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${var.project}-${var.environment}-backend-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids

  # Security Group already created so no need to create here agin
  create_security_group = false


  access_logs = {
    bucket = "my-alb-logs"
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix      = "h1"
      protocol         = "HTTP"
      port             = 80
      target_type      = "instance"
      target_id        = "i-0f6d38a07d50d080f"
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}