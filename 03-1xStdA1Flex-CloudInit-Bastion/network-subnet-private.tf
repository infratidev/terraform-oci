resource "oci_core_subnet" "vcn-private-subnet" {

  compartment_id = oci_identity_compartment.homelab.id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.0.0/24"
  freeform_tags  = var.tags

  security_list_ids = [
    oci_core_security_list.private-security-list.id,
  ]

  display_name    = "private-subnet"
  dhcp_options_id = oci_core_dhcp_options.dhcp-options.id
  dns_label       = "privatesubnet"
}

resource "oci_core_nat_gateway" "homelab_nat_gateway" {
  compartment_id = oci_identity_compartment.homelab.id
  display_name   = "labinfrati-ng"
  vcn_id         = module.vcn.vcn_id
}

resource "oci_core_default_route_table" "homelab_default_route" {
    #Required
    manage_default_resource_id = oci_core_subnet.vcn-private-subnet.route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_nat_gateway.homelab_nat_gateway.id}"
  }
}

resource "oci_core_security_list" "private-security-list" {
  compartment_id = oci_identity_compartment.homelab.id
  vcn_id         = module.vcn.vcn_id
  display_name   = "security-list-private"
  freeform_tags  = var.tags

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    description = "SSH traffic"

    tcp_options {
      min = 22
      max = 22
    }
  }

     ingress_security_rules {
       stateless   = false
       source      = "0.0.0.0/0"
       source_type = "CIDR_BLOCK"
       protocol    = "6"
       description = "HTTP traffic"

       tcp_options {
         min = 80
         max = 80
       }
     }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    description = "ICMP Port Unreachable"

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    description = "ICMP Destination Unreachable"

    icmp_options {
      type = 3
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    description = "ICMP Echo Reply"

    icmp_options {
      type = 0
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    description = "ICMP Echo"

    icmp_options {
      type = 8
    }
  }
}

resource "oci_core_network_security_group" "homelab-network-security-group" {
  compartment_id = oci_identity_compartment.homelab.id
  vcn_id         = module.vcn.vcn_id
  display_name   = "network-security-group-homelab"
  freeform_tags  = var.tags
}

resource "oci_core_network_security_group_security_rule" "homelab-network-security-group-list-ingress" {
  network_security_group_id = oci_core_network_security_group.homelab-network-security-group.id
  direction                 = "INGRESS"
  source                    = oci_core_network_security_group.homelab-network-security-group.id
  source_type               = "NETWORK_SECURITY_GROUP"
  protocol                  = "all"
  stateless                 = true
}

resource "oci_core_network_security_group_security_rule" "homelab-network-security-group-list-egress" {
  network_security_group_id = oci_core_network_security_group.homelab-network-security-group.id
  direction                 = "EGRESS"
  destination               = oci_core_network_security_group.homelab-network-security-group.id
  destination_type          = "NETWORK_SECURITY_GROUP"
  protocol                  = "all"
  stateless                 = true
}
