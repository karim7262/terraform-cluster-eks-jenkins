variable "nirmata_token"{
  default = ""
}


provider "nirmata" {
  #  Nirmata API Key. Best configured as the environment variable NIRMATA_TOKEN.
     token = "${var.nirmata_token}"

  #  Nirmata address. Defaults to https://nirmata.io and can be configured as the environment variable NIRMATA_URL.
     url = "https://nirmata.io"
}

# resource "nirmata_cluster_type_gke" "gke-cluster-type-1-32" {

#   name                       = "alex02-tf-gke-cluster-type_alex" 
#   version                    = "1.19.10-gke.1600"
#   credentials                = "automation-gcp"
#   location_type              = "Zonal"
#   project                    = "gcpXXX"
#   zone                       = "us-west1-a"
#   network                    = "default"
#   subnetwork                 = "default"
#   enable_cloud_run           = false
#   enable_http_load_balancing = false
#   allow_override_credentials = true
#   channel                    = "Stable"
#   auto_sync_namespaces       = true

#   system_metadata = {
#     cluster = "gke"
#   }

#   cluster_field_override = [ "enableWorkloadIdentity","subnetwork","workloadPool","network"]
#   nodepool_field_override = [ "diskSize","serviceAccount","machineType"]

#   nodepools {
#     machine_type             = "c2-standard-16"
#     disk_size                = 110
#     enable_preemptible_nodes = true
#     #service_account          = ""
#     auto_upgrade             = true
#     auto_repair              = true
#     max_unavailable          = 1
#     max_surge                = 0
#     node_annotations = {
#       node = "annotate"
#     }
#   }
# }
resource "nirmata_cluster_type_eks" "eks-cluster-1-34" {
  name                      = "alex04-t3medium-tf-github-eks-cluster"
  version                   = "1.19"
  credentials               = "aws-apicluster"
  region                    = "us-west-1"
  vpc_id                    = "vpc-04a11fc7db0fc1765"
  subnet_id                 = ["subnet-0df29c38cf4a5XXXX", "subnet-011f4f72e6626XXXX"]
  security_groups           = ["sg-0f76dae17a0ef3XXXX"]
  cluster_role_arn          = "arn:aws:iam::844333597536:role/XXXX"
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
    instance_type       = "t3.medium"
    disk_size           = 60
    ssh_key_name        = "eu-central-key"
    security_groups     = ["sg-0acabab6d341XXXXX"]
    iam_role            = "arn:aws:iam::844333597536:role/XXXXXX"
  }
}

resource "nirmata_cluster" "eks-eu-34" {
  name = "alex04-t3medium-tf-github-eks-cluster"
  cluster_type = "alex04-t3medium-tf-github-eks-cluster"
  # labels  = {foo = "bar"}
  node_count = 1

  #  nodepools {
  #     node_count                = 1 
  #     enable_auto_scaling       = false
  #     min_count                 = 1
  #     max_count                 = 4
  #  }
  #  delete_action = "remove"
}