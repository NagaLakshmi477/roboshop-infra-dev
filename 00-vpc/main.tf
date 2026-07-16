module "vpc" {
  source = "git::https://github.com/NagaLakshmi477/terraform-aws-vpc.git?ref=main"
  project              = var.project
  environment          = var.environment
  public_subnet_cidr   = var.pub_subnet
  private_subnet_cidr  = var.pri_subnet
  database_subnet_cidr = var.db_subnet
  is_peering_required = true
}

# here we have all code in source right so we need to give module and modulename

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }