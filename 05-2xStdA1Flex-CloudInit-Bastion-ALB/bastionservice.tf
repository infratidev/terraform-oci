resource "oci_bastion_bastion" "InfraTIBastionService" {

  bastion_type     = "STANDARD"
  compartment_id   = oci_identity_compartment.infraticomp.id
  target_subnet_id = oci_core_subnet.InfraTIBastionSubnet.id
  client_cidr_block_allow_list = split(",", var.client_cidr_block_allow_list)
  name = "InfraTIBastionService"
}

resource "oci_bastion_session" "InfraTISSHViaBastionService" {

  bastion_id = oci_bastion_bastion.InfraTIBastionService.id
  depends_on = [oci_core_instance.InfraTIWebserver]
  count      = var.NumberOfNodes
 
  key_details {
  
    public_key_content = tls_private_key.public_private_key_pair.public_key_openssh
  }

  target_resource_details {

    session_type       = "MANAGED_SSH"
    target_resource_id = oci_core_instance.InfraTIWebserver[count.index].id
    target_resource_private_ip_address =  oci_core_instance.InfraTIWebserver[count.index].private_ip

    target_resource_operating_system_user_name = "ubuntu"
    target_resource_port                       = "22"
  }

  session_ttl_in_seconds = 1800
  key_type               = "PUB"
  display_name = "SSHViaBastionServic"

}

