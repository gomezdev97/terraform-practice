terraform {

  /* Uncomment this block to use Terraform Cloud for this tutorial
  cloud {
      organization = "organization-name"
      workspaces {
        name = "learn-terraform-*"
      }
  }
  */

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}
