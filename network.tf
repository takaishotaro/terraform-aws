module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = local.vpc_name
  cidr               = local.vpc_cidr
  azs                = local.vpc_azs
  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  enable_nat_gateway = true
  single_nat_gateway  = false
  one_nat_gateway_per_az = false

}
