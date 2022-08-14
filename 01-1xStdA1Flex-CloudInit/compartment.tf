resource "oci_identity_compartment" "homelab" {
  compartment_id = var.compartment_ocid
  description    = "Compartment for InfraTI resources."
  name           = var.compartment_name
  freeform_tags  = var.tags
}
