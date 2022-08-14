# Output the "list" of all availability domains.
output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.homelab.name
}

output "private-ip-ampere-instance" {
  value = oci_core_instance.vm_instance_ampere.*.private_ip
}

output "bastion_ssh_metadata" {
  value = oci_bastion_session.homelab_bastionsession.*.ssh_metadata
}
