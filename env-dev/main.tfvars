env         = "dev"
domain_name = "hptldevops.online"
zone_id     = "Z034492616CL1VL5T8KC8"

db_instances = {
  mongodb = {
    app_port      = 27017
    instance_type = "t3.small"
  }

  redis = {
    app_port      = 6379
    instance_type = "t3.small"
  }

  rabbitmq = {
    app_port      = 5672
    instance_type = "t3.small"
  }

  mysql = {
    app_port      = 3306
    instance_type = "t3.small"
  }
}

app_instances = {

  catalogue = {
    app_port      = 8080
    instance_type = "t3.small"
  }

  cart = {
    app_port      = 8080
    instance_type = "t3.small"
  }

  user = {
    app_port      = 8080
    instance_type = "t3.small"
  }

  shipping = {
    app_port      = 8080
    instance_type = "t3.small"
  }

  payment = {
    app_port      = 8080
    instance_type = "t3.small"
  }

}

web_instances = {
  frontend = {
    app_port      = 80
    instance_type = "t3.small"
  }
}

eks = {
  subnet_ids = ["subnet-03267e70b0f121080", "subnet-0aee3b0522317971a"]
  addons = {
    vpc-cni = {}
    kube-proxy = {}
  }
  #verify your subnet ids (this id are from Raghu's code)
  # arn is unique identifier for a resource in aws such as ec2, s3 bucket, etc.
  access_entries = {
    workstation = {
      principal_arn     = "arn:aws:iam::585768147521:role/WorkstationRole"
      kubernetes_groups = []
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope_type = "cluster"
      access_scope_namespaces = []
    }
    # UI Access
    ui-access = {
      principal_arn     = "arn:aws:iam::585768147521:root"
      kubernetes_groups = []
      policy_arn        = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope_type = "cluster"
      access_scope_namespaces = []
    }
  }
  node_groups = {
    g1 = {
      desired_size  = 1
      max_size      = 2
      min_size      = 1
      capacity_type = "SPOT"
      instance_types = ["t3.large"]
    }
  }
}