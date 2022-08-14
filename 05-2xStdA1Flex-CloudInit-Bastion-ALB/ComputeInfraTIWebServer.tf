resource "oci_core_instance" "InfraTIWebserver" {
  count 			                        = var.NumberOfNodes
  availability_domain                 = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id                      = oci_identity_compartment.infraticomp.id
  shape                               = "VM.Standard.A1.Flex"
  display_name                        = join("", [var.vm_name, "0", count.index + 1])
  preserve_boot_volume                = false
  is_pv_encryption_in_transit_enabled = true
  freeform_tags                       = var.tags

  shape_config {
    memory_in_gbs = 12
    ocpus         = 2
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.public_private_key_pair.public_key_openssh
  }

  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false

    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  source_details {
    source_id   = var.vm_image_ocid_ampere
    source_type = "image"
  }

  availability_config {
    is_live_migration_preferred = true
  }

  create_vnic_details {
    assign_public_ip          = false
    subnet_id                 = oci_core_subnet.InfraTIWebSubnet.id
    nsg_ids                   = [oci_core_network_security_group.InfraTIWebSecurityGroup.id]
  }

 provisioner "local-exec" {
    command = "sleep 200"
  }

}


