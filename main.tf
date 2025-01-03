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
module "db_instances" {
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

module "app_instances" {
  depends_on     = [module.db_instances]
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

module "web_instances" {
  depends_on     = [module.app_instances]
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


