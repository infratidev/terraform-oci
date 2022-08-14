resource "oci_identity_compartment" "infraticomp" {
  compartment_id = var.compartment_ocid
  description    = "Compartment for InfraTI resources."
  name           = var.compartment_name
  freeform_tags  = var.tags
}
