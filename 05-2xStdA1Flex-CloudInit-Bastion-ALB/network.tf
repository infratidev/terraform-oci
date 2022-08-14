##VCN
resource "oci_core_virtual_network" "InfraTIVCN" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "InfraTIVCN"
  compartment_id  = oci_identity_compartment.infraticomp.id
  display_name   = "InfraTIVCN"
}

###DHCP
resource "oci_core_dhcp_options" "InfraTIDhcpOptions1" {

  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id
  display_name    = "InfraTIDHCPOptions1"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type                = "SearchDomain"
    search_domain_names = ["infrati.dev"]
  }
}

###IG
resource "oci_core_internet_gateway" "InfraTIInternetGateway" {

  compartment_id  = oci_identity_compartment.infraticomp.id
  display_name   = "InfraTIInternetGateway"
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id
}

resource "oci_core_route_table" "InfraTIRouteTableViaIGW" {

  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id
  display_name   = "InfraTIRouteTableViaIGW"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.InfraTIInternetGateway.id
  }
}

###NAT
resource "oci_core_nat_gateway" "InfraTINATGateway" {

  compartment_id  = oci_identity_compartment.infraticomp.id
  display_name   = "InfraTINATGateway"
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id
}

resource "oci_core_route_table" "InfraTIRouteTableViaNAT" {

  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id
  display_name   = "InfraTIRouteTableViaNAT"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.InfraTINATGateway.id
  }
}

###SUBREDES
resource "oci_core_subnet" "InfraTIWebSubnet" {
  cidr_block      = var.WebSubnet-CIDR
  display_name    = "InfraTIWebSubnet"
  dns_label       = "infratiwebnet"
  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id

  route_table_id  = oci_core_route_table.InfraTIRouteTableViaNAT.id
  dhcp_options_id = oci_core_dhcp_options.InfraTIDhcpOptions1.id
}

resource "oci_core_subnet" "InfraTILBSubnet" {
  cidr_block      = var.LBSubnet-CIDR
  display_name    = "InfraTILBSubnet"
  dns_label       = "infratilbnet"
  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id

  route_table_id  = oci_core_route_table.InfraTIRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.InfraTIDhcpOptions1.id
}

resource "oci_core_subnet" "InfraTIBastionSubnet" {
  cidr_block      = var.BastionSubnet-CIDR
  display_name    = "InfraTIBastionSubnet"
  dns_label       = "infratibastion"
  compartment_id  = oci_identity_compartment.infraticomp.id
  vcn_id          = oci_core_virtual_network.InfraTIVCN.id

  route_table_id  = oci_core_route_table.InfraTIRouteTableViaIGW.id
  dhcp_options_id = oci_core_dhcp_options.InfraTIDhcpOptions1.id
}





