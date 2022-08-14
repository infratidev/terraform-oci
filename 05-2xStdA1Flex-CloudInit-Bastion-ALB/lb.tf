resource "oci_load_balancer" "InfraTIPublicLoadBalancer" {
  compartment_id   = oci_identity_compartment.infraticomp.id

  display_name              = "InfraTIPublicLB"
  network_security_group_ids =  [oci_core_network_security_group.InfraTIWebSecurityGroup.id]

  subnet_ids = [
     oci_core_subnet.InfraTILBSubnet.id
  ]

  shape = var.lb_shape

  dynamic "shape_details" {
    for_each = local.is_flexible_lb_shape ? [1] : []
    content {
      minimum_bandwidth_in_mbps = var.flex_lb_min_shape
      maximum_bandwidth_in_mbps = var.flex_lb_max_shape
    }
  }
}

resource "oci_load_balancer_backendset" "InfraTIPublicLoadBalancerBackendset" {
  name             = "InfraTILBBackendset"
  load_balancer_id = oci_load_balancer.InfraTIPublicLoadBalancer.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "InfraTIPublicLoadBalancerListener" {
  load_balancer_id         = oci_load_balancer.InfraTIPublicLoadBalancer.id
  name                     = "InfraTILBListener"
  default_backend_set_name = oci_load_balancer_backendset.InfraTIPublicLoadBalancerBackendset.name
  port                     = 80
  protocol                 = "HTTP"
}

resource "oci_load_balancer_backend" "InfraTIPublicLoadBalancerBackend" {
  count            = var.NumberOfNodes
  load_balancer_id = oci_load_balancer.InfraTIPublicLoadBalancer.id
  backendset_name  = oci_load_balancer_backendset.InfraTIPublicLoadBalancerBackendset.name
  ip_address       = oci_core_instance.InfraTIWebserver[count.index].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

output "InfraTIPublicLoadBalancer_Public_IP" {
  value = [oci_load_balancer.InfraTIPublicLoadBalancer.ip_addresses]
}

