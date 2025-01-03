# variables to create eks cluster resource in aws
variable "env" {}
variable "subnet_ids" {}
variable "addons" {}
variable "node_groups" {}
variable "access_entries" {}

#create aws resource eks cluster named dev-eks
resource "aws_eks_cluster" "main" {
  name     = "${var.env}-eks"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }
}
# create access_entries resource which are used to grant access to IAM users on kubernetes resources
resource "aws_eks_access_entry" "main" {
  for_each          = var.access_entries
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = each.value["principal_arn"]
  kubernetes_groups = each.value["kubernetes_groups"]
  type              = "STANDARD"
}
