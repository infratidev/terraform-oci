terraform {
  required_version = ">= 1.1.0"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.87.0"
    }

    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }

  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
