# create dev-eks-role and assign 1. AmazonEKSClusterPolicy 2. AmazonEKSVPCResourceController policies
# assume role policy refers to JSON document which entity (user, service ot other IAM role) are allowed to assume a specific IAM role in AWS
# in our case here eks.amazonaws.com service principle is allowed to assume the role dev-eks-role, then we are associating those two permissions
resource "aws_iam_role" "eks-cluster-role" {
  name               = "${var.env}-eks-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}
# create dev-eks-node-group-role and assign 1.AmazonEKSWorkerNodePolicy 2.AmazonEKS_CNI_Policy 3. AmazonEC2ContainerRegistryReadOnly policy
# service principle ec2.amazonaws.com is allowed to assume the dev-eks-node-group-role and assigned those three policies
resource "aws_iam_role" "eks-node-group-role" {
  name = "${var.env}-eks-node-group-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "main-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}
