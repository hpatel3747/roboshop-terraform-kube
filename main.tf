#Define all the variables in this variable file
# make sure values are provided thru auto.tfvars, .tfvars or from cli
variable "env" {}
variable "db_instances" {}
variable "app_instances" {}
variable "web_instances" {}
variable "zone_id" {}
variable "domain_name" {}
variable "vault_token" {}

#state file
terraform {
  backend "s3" {
  }
}

## Define the modules to deploy EC2 instances for databases, app and web servers
# in blocks where for_each is set, an additional 'each' object is available in expression. so in the block below, each.key is for db_instances variable,
# see the value in main.tfvars for each.key and each.value for db_instances variable only
# value of vault_token will be supplied in the cli, value of other variables are provided in the main.tfvars file
module "db_mod" {
  for_each       = var.db_instances
  source         = "./modules/ec2"
  env            = var.env
  app_port       = each.value["app_port"]
  component_name = each.key
  instance_type  = each.value["instance_type"]
  domain_name    = var.domain_name
  zone_id        = var.zone_id
  vault_token    = var.vault_token
}

module "app_mod" {
  depends_on     = [module.db_mod]
  for_each       = var.app_instances
  source         = "./modules/ec2"
  env            = var.env
  app_port       = each.value["app_port"]
  component_name = each.key
  instance_type  = each.value["instance_type"]
  domain_name    = var.domain_name
  zone_id        = var.zone_id
  vault_token    = var.vault_token
}

module "web_mod" {
  depends_on     = [module.app_mod]
  for_each       = var.web_instances
  source         = "./modules/ec2"
  env            = var.env
  app_port       = each.value["app_port"]
  component_name = each.key
  instance_type  = each.value["instance_type"]
  domain_name    = var.domain_name
  zone_id        = var.zone_id
  vault_token    = var.vault_token
}

module "eks_mod" {
  source = "./modules/eks"
  env = var.env
  subnet_ids = var.eks["subnet_ids"]
  addons     = var.eks["addons"]
  node_groups = var.eks["node_groups"]
  access_entries = var.eks["access_entries"]
}
