variable "nirmata_token"{
  default = ""
} 

locals {
  name-sufix = "automation01" // !!! change also in terraform.yaml
}


provider "nirmata" {
  #  Nirmata API Key. Best configured as the environment variable NIRMATA_TOKEN
     token = "${var.nirmata_token}"
  #  Nirmata address. Defaults to https://nirmata.io and can be configured as the environment variable NIRMATA_URL.
     url = "https://nirmata.io"
}
resource "nirmata_cluster_type_eks" "eks-cluster-tf-test-automation" {
  name                      = "cluster-type-eks-test-${local.name-sufix}"
  version                   = "1.18"
  credentials               = "nirmata-aws-dev"
  region                    = "us-west-1"
  vpc_id                    = "vpc-05f45863"
  subnet_id                 = ["subnet-0369f4bd32e5db9d5", "subnet-0bea7061f60ae8a8d", "subnet-08f6b376fb8c0d61d"]
  security_groups           = ["sg-00e7a90524265bfb0"]
  cluster_role_arn          = "arn:aws:iam::094919933512:role/eks-role"
  enable_private_endpoint   = true
  enable_identity_provider  = true
  auto_sync_namespaces       = false
  # enable_secrets_encryption = true
  # kms_key_arn = ""
  # log_types = ""
  # enable_fargate = true
  # pod_execution_role_arn = ""
  nodepools {
    name                = "default"
    instance_type       = "t2.small"
    disk_size           = 60
    ssh_key_name        = "nirmata-west-1-062014"
    security_groups     = ["sg-00e7a90524265bfb0"]
    iam_role            = "arn:aws:iam::844333597536:role/Node-IAM-Role"
  }

}
resource "nirmata_cluster" "eks-cluster-test-automation" {   
  name                 = "cluster-eks-test-${local.name-sufix}"
  cluster_type         = nirmata_cluster_type_eks.eks-cluster-tf-test-automation.name 
  nodepools {
  node_count                = 3
      enable_auto_scaling       = true
      min_count = 2
      max_count = 4
   }
}