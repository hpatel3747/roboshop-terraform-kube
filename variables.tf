#Define all the variables in this variable file
# make sure values are provided thru auto.tfvars, .tfvars or from cli
variable "env" {}
variable "db_instances" {}
variable "app_instances" {}
variable "web_instances" {}
variable "zone_id" {}
variable "domain_name" {}
variable "vault_token" {}