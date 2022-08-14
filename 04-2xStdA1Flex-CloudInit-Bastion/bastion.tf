resource "oci_bastion_bastion" "homelab_bastion" {

  bastion_type     = "STANDARD"
  compartment_id   = oci_identity_compartment.homelab.id
  target_subnet_id = oci_core_subnet.vcn-private-subnet.id

  client_cidr_block_allow_list = [
    "0.0.0.0/0"
  ]

  name = "InfraTIBastion"
}

resource "oci_bastion_session" "homelab_bastionsession" {

  bastion_id = oci_bastion_bastion.homelab_bastion.id
  depends_on = [oci_core_instance.vm_instance_ampere ]
  count      = var.NumberOfNodes
 
  key_details {
  
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }

  target_resource_details {

    session_type       = "MANAGED_SSH"
    target_resource_id = oci_core_instance.vm_instance_ampere[count.index].id
    target_resource_private_ip_address =  oci_core_instance.vm_instance_ampere[count.index].private_ip

    target_resource_operating_system_user_name = "ubuntu"
    target_resource_port                       = "22"
  }

  session_ttl_in_seconds = 1800
  display_name = "bastionsession-private-host"

}

