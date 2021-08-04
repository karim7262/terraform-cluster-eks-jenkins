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
        # The name of your Terraform Cloud organization
        organization = "automation-admin"

        # The name of the Terraform Cloud workspace to store Terraform state files in
        workspaces {
          name = "workspace18"
        }
        # token = "nzRfitwaWGQFAA.atlasv1.1I6GmrUpJIIdIGr3208bruFloKj9RGW97CrRHTsdkfyOQ9cko09jRYjLB1eLOOW5JQ4"
      }
    }
