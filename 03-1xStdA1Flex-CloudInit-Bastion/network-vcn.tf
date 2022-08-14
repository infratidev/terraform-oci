module "vcn" {

  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.5.0"

  compartment_id = oci_identity_compartment.homelab.id
  region         = "us-ashburn-1"
  vcn_name       = var.compartment_name
  vcn_dns_label  = var.compartment_name
}
