subnet_ids = [
  "subnet-0d1a07bc7ceaf4694",
  "subnet-05a9dc77897b66c38",
  "subnet-08c53c78664626d0f"
]

cluster_name            = "roboshop"
env                     = "test"
eks_version             = "1.35"
node_group_desired_size = 2
node_group_max_size     = 5
node_group_min_size     = 1
instance_types = [
  "t3.medium",
  "t3.large"
]

# DB Variables

# Value of the map of maps for components variable, we can use this in any environment and change the instance type as per the requirement of the environment. This is how we can achieve the DRY code in terraform.
components = {
  mongodb = {
    instance_type = "t3.medium"
    internal      = true
  }

  redis = {
    instance_type = "t3.micro"
    internal      = true
  }

  mysql = {
    instance_type = "t3.medium"
    internal      = true
  }

  rabbitmq = {
    instance_type = "t3.micro"
    internal      = true
  }

}

env_name    = "test"
ami_name    = "DevOps-LabImage-RHEL9"
sg_name     = "b60-allow-all"
domain_name = "robotshop.fun"