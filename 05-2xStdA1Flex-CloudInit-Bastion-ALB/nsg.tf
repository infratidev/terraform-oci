resource "oci_core_network_security_group" "InfraTIWebSecurityGroup" {
  compartment_id = oci_identity_compartment.infraticomp.id
  display_name   = "InfraTIWebSecurityGroup"
  vcn_id         = oci_core_virtual_network.InfraTIVCN.id
}

resource "oci_core_network_security_group" "InfraTISSHSecurityGroup" {
  compartment_id = oci_identity_compartment.infraticomp.id
  display_name   = "InfraTISSHSecurityGroup"
  vcn_id         = oci_core_virtual_network.InfraTIVCN.id
}

resource "oci_core_network_security_group_security_rule" "InfraTIWebSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.InfraTIWebSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "InfraTIWebSecurityIngressGroupRules" {
  for_each = toset(var.webservice_ports)

  network_security_group_id = oci_core_network_security_group.InfraTIWebSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}

resource "oci_core_network_security_group_security_rule" "InfraTISSHSecurityEgressGroupRule" {
  network_security_group_id = oci_core_network_security_group.InfraTISSHSecurityGroup.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

resource "oci_core_network_security_group_security_rule" "InfraTISSHSecurityIngressGroupRules" {
  for_each = toset(var.bastion_ports)

  network_security_group_id = oci_core_network_security_group.InfraTISSHSecurityGroup.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = each.value
      min = each.value
    }
  }
}
