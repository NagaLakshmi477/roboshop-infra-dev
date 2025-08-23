module "vpc" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-vpc.git?ref=main"
  environment = var.environment
  project = var.project
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required = true
}

# getting the vpcid

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }