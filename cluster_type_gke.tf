variable "nirmata_token"{
  default = ""
} 

# locals {
#   name-sufix = "automation1"
# }

provider "nirmata" {
  #  Nirmata API Key. Best configured as the environment variable NIRMATA_TOKEN
     token = "${var.nirmata_token}"
  #  Nirmata address. Defaults to https://nirmata.io and can be configured as the environment variable NIRMATA_URL.
     url = "https://nirmata.io"
}
#  A ClusterType contains reusable configuration to create clusters.
resource "nirmata_cluster_type_gke" "gke-cluster-type" {
  name                       = "tf-gke-cluster-vault-indra-3" 
  version                    = "1.19.10-gke.1600"
  credentials                = "indra-vault"
  location_type              = "Zonal"
  project                    = "indra-test-gcp"
  zone                       = "us-west1-a"
  network                    = "default"
  subnetwork                 = "default"
  enable_cloud_run           = false
  enable_http_load_balancing = false
  allow_override_credentials = true
  channel                    = "Stable"
  auto_sync_namespaces       = true
  system_metadata = {
    cluster = "gke"
  }
  cluster_field_override = [ "enableWorkloadIdentity","subnetwork","workloadPool","network"]
  nodepool_field_override = [ "diskSize","serviceAccount","machineType"]
  nodepools {
    machine_type             = "g1-small"
    disk_size                = 110
    enable_preemptible_nodes = true
    #service_account          = ""
    auto_upgrade             = true
    auto_repair              = true
    max_unavailable          = 1
    max_surge                = 0
    node_annotations = {
      node = "annotate"
    }
  }
 vault_auth {
    name             = "vault-auth"
    path             = "nirmata/$(cluster.name)"
    addon_name       = "vault-agent-injector"
    credentials_name = "vault-lab"
    delete_auth_path     = "true"
    roles {
      name                 = "datadog-agent"
      service_account_name = "datadog-agent"
      namespace            = "datadog-agent"
      policies             = "nirmata"
    }
  }
}
resource "nirmata_cluster" "eks-cluster-1" {
  name                 = "gke-vault-indra-4"
  cluster_type         = nirmata_cluster_type_gke.gke-cluster-type.name
   nodepools {
      node_count                = 1
   }
   system_metadata = {
    cluster = "gke"
    test    = "1test"
  }
  labels = {
    label1 = "tes-vault1"
    label2 = "tes-vault2"
    label3 = "tes-vault3"
  }
}