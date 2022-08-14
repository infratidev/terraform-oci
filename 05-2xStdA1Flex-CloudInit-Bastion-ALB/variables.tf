variable "compartment_name" {
  description = "The name of the compartment."
  type        = string
}

variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user."
  type        = string
}

variable "vm_image_ocid_ampere" {
  description = "The OCID of the VM image to be deployed (ampere)."
  type        = string
}

variable "vm_name" {
  description = "Name of the infrati virtual machine."
  type        = string
  default      = "InfraTIWebServer"
}

variable "region" {
  description = "The name of the cloud region."
  type        = string
  default     = "us-ashburn-1"
}

variable "fingerprint" {
  description = "The fingerprint of the private key."
  type        = string
}

variable "private_key_path" {
  description = "The location of the private key."
  type        = string
}

variable "ssh_public_key" {
  description = "The value of your SSH public key."
  type        = string
}

variable "tags" {
  description = "Freeform tags."
  type        = map(any)
}

variable "compartment_ocid" {
  description = "The OCID of compartment."
  type        = string
}

variable "bastion_state" {
  description = "The target state for the instance. Could be set to RUNNING or STOPPED. (Updatable)"
  default     = "RUNNING"
  type        = string
}

variable "ssh_public_key_tls" {
  default = ""
}

variable "NumberOfNodes" {
  default = 2
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 10
}

locals {
  is_flexible_lb_shape   = var.lb_shape == "flexible" ? true : false
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "WebSubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "LBSubnet-CIDR" {
  default = "10.0.2.0/24"
}

variable "BastionSubnet-CIDR" {
  default = "10.0.3.0/24"
}

variable "webservice_ports" {
  default = ["80"]
}

variable "bastion_ports" {
  default = ["22"]
}

variable "client_cidr_block_allow_list" {
  default = "0.0.0.0/0"
}
