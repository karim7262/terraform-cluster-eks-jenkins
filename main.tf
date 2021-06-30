 # The configuration for the `remote` backend.
    terraform {
      required_version = ">= 0.14"
      required_providers {
        nirmata = {
            # source  = "registry.terraform.io/nirmata/nirmata"
            source  = "nirmata/nirmata"
            version = "1.0.1"
        }
      }
      backend "remote" {
        # The name of your Terraform Cloud organization.
        organization = "automation-admin"

        # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
          name = "new_workspace2"
        }
      }
    }