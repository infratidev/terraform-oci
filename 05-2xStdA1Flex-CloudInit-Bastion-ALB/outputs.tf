# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.infraticomp.name
}

output "private-ip-infratiwebserver-instance" {
  value = oci_core_instance.InfraTIWebserver.*.private_ip
}

output "bastion_ssh_metadata" {
  value = oci_bastion_session.InfraTISSHViaBastionService.*.ssh_metadata
}
