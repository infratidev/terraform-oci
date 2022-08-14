resource "null_resource" "InfraTIWebServerInit" {
  depends_on = [oci_core_instance.InfraTIWebserver]
  count      = var.NumberOfNodes

  provisioner "remote-exec" {
    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = oci_core_instance.InfraTIWebserver[count.index].private_ip
      private_key         = tls_private_key.public_private_key_pair.private_key_pem 
      agent               = false
      timeout             = "10m"
      bastion_host        = "host.bastion.${var.region}.oci.oraclecloud.com"
      bastion_port        = "22"
      bastion_user        = oci_bastion_session.InfraTISSHViaBastionService[count.index].id
      bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
    }

   script = "./scripts/apache2.sh"

  }

   triggers = {
    file_hashes = jsonencode({
      for fn in fileset("./scripts", "**") :
      fn => filesha256("./scripts/${fn}")
    })
  }

}

