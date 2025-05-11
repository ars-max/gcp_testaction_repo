# VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.l_vpc_name}-vpc"
  project                 = var.project_name
  auto_create_subnetworks = "false"
  routing_mode            = var.vpc_routing_mode
}
