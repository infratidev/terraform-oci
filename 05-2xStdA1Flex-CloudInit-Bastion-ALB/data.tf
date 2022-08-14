data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_boot_volumes" "infrati_boot_volumes" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = oci_identity_compartment.infraticomp.id
}


