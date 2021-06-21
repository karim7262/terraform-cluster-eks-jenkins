variable "nirmata_token"{
  default = ""
}
variable "nodepool_ssh_key_name"{
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
resource "nirmata_cluster_type_eks" "eks-cluster-1-10" {
  name                      = "alex-eks-cluster-1-10"
  version                   = "1.19"
  credentials               = "nirmata-aws-dev"
  region                    = "us-west-1"
  vpc_id                    = "vpc-04a11fc7db0fc1765"
  subnet_id                 = ["subnet-0df29c38cf4a5", "subnet-011f4f72e6626fc69"]
  security_groups           = ["sg-0f76dae17a0ef3211"]
  cluster_role_arn          = "arn:aws:iam::844333597536:role/eks-role"
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
    ssh_key_name        = "${var.nodepool_ssh_key_name}"
    security_groups     = ["sg-0acabab6d34120202"]
    iam_role            = "arn:aws:iam::844333597536:role/Node-IAM-Role"
  }

  addons {
    name            = "vault-agent-injector"
    addon_selector  = "vault-agent-injector"
    catalog         = "default-catalog"
    channel         = "Stable"
    sequence_number = 1
  }

  vault_auth {
    name             = "vault-auth"
    path             = "nirmata/$(cluster.name)"
    addon_name       = "vault-agent-injector"
    credentials_name = "test-vault"
    delete_auth_path = true

    roles {
      name                 = "datadog-agent"
      service_account_name = "datadog-agent"
      namespace            = "datadog-agent"
      policies             = "nirmata"
    }
  }

}

# resource "nirmata_cluster" "eks-cluster-12" {
#   name                 = "eks-cluster-12"
#   cluster_type         = nirmata_cluster_type_eks.eks-cluster-1-19.name
#   node_count           = 1
# }

resource "nirmata_cluster" "eks-cluster-1" {
  name                 = "tf-eks-cluster"
  cluster_type         = nirmata_cluster_type_eks.eks-cluster-1-10.name
  # nodepools {
      node_count                = 3
      enable_auto_scaling       = true
      min_count = 2
      max_count = 4
  #  }
}