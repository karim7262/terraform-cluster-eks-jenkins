 # The configuration for the `remote` backend.
    terraform {
      required_version = ">= 0.14"
      required_providers {
        nirmata = {
            source  = "nirmata1/nirmata"
            # source  = "nirmata/nirmata"
            version = "1.0.0"
        }
        provider_installation {
        filesystem_mirror {
          path = "/home/runner/work/nirmata_terraform_cluster_eks/nirmata_terraform_cluster_eks/terraform-provider-nirmata"
        }
      }
      }
      
      backend "remote" {
        # The name of your Terraform Cloud organization.
        organization = "automation-admin"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "new_workspace6"
        }
      }
    }