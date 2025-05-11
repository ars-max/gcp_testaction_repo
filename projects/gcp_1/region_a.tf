# Subnet Name 
locals {
  shr_name_pub = try(substr(var.project_name, 0, 62-length("${var.region_a}-subnet-public")), null)
  shr_name_pri = try(substr(var.project_name, 0, 62-length("${var.region_a}-subnet-private")), null)
  shr_name_pro = try(substr(var.project_name, 0, 62-length("${var.region_a}-subnet-protected")), null)
  l_sub_pub = try("${local.l_vpc_name}-${var.region_a}-subnet-public", null)
  l_sub_pri = try("${local.l_vpc_name}-${var.region_a}-subnet-private", null)
  l_sub_pro = try("${local.l_vpc_name}-${var.region_a}-subnet-protected", null)
  l_sub_pbname  = try(length(local.l_sub_pub) > 63 ? "${local.shr_name_pub}-${var.region_a}-subnet-public" : local.l_sub_pub, null)
  l_sub_pvname  = try(length(local.l_sub_pri) > 63 ? "${local.shr_name_pri}-${var.region_a}-subnet-private" : local.l_sub_pri, null)
  l_sub_poname  = try(length(local.l_sub_pro) > 63 ? "${local.shr_name_pro}-${var.region_a}-subnet-protected" : local.l_sub_pro, null)
}


# VPC Router
resource "google_compute_router" "vpc_router_a" {

  name = "${local.l_vpc_name}-${var.region_a}-router"
  description = "${var.project_name}-router"
  project = var.project_name
  region  = var.region_a
  network = google_compute_network.vpc.self_link

}

# Subnet: Public
resource "google_compute_subnetwork" "vpc_subnetwork_public_a" {
  # name = "${local.l_vpc_name}-${var.region_a}-subnet-public"
  name = local.l_sub_pbname
  project = var.project_name
  region  = var.region_a
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.public_subnet_width_delta,
    0
  )

    secondary_ip_range {
    range_name = "public-services"
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_public_subnet_width_delta,
      0
    )
  }

  dynamic "log_config" {
    for_each = var.log_config == null ? [] : tolist([var.log_config])

    content {
      aggregation_interval = var.log_config.aggregation_interval
      flow_sampling        = var.log_config.flow_sampling
      metadata             = var.log_config.metadata
    }
  }
}


# Subnet: Private
resource "google_compute_subnetwork" "vpc_subnetwork_private_a" {
  # name = "${local.l_vpc_name}-${var.region_a}-subnet-private"
  name = local.l_sub_pvname
  project = var.project_name
  region  = var.region_a
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.private_subnetwork_width_delta,
    1 * (1 + var.cidr_subnetwork_spacing)
  )

  secondary_ip_range {
    range_name = "private-services"
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_private_subnetwork_width_delta,
      1 * (1 + var.secondary_cidr_subnetwork_spacing)
    )
  }

  dynamic "log_config" {
    for_each = var.log_config == null ? [] : tolist([var.log_config])

    content {
      aggregation_interval = var.log_config.aggregation_interval
      flow_sampling        = var.log_config.flow_sampling
      metadata             = var.log_config.metadata
    }
  }
}


# Subnet: Protected
resource "google_compute_subnetwork" "vpc_subnetwork_protected_a" {
  # name = "${local.l_vpc_name}-${var.region_a}-subnet-protected"
  name = local.l_sub_poname
  project = var.project_name
  region  = var.region_a
  network = google_compute_network.vpc.self_link

  private_ip_google_access = true
  ip_cidr_range = cidrsubnet(
    var.cidr_block,
    var.protected_subnetwork_width_delta,
    1 * (2 + var.cidr_subnetwork_spacing)
  )

  secondary_ip_range {
    range_name = "private-services"
    ip_cidr_range = cidrsubnet(
      var.secondary_cidr_block,
      var.secondary_protected_subnetwork_width_delta,
      1 * (2 + var.secondary_cidr_subnetwork_spacing)
    )
  }

  dynamic "log_config" {
    for_each = var.log_config == null ? [] : tolist([var.log_config])

    content {
      aggregation_interval = var.log_config.aggregation_interval
      flow_sampling        = var.log_config.flow_sampling
      metadata             = var.log_config.metadata
    }
  }
}


# Cloud NAT
resource "google_compute_router_nat" "vpc_nat_a" {
  name = "${local.l_vpc_name}-${var.region_a}-nat"

  project                            = var.project_name
  region                             = var.region_a
  router                             = google_compute_router.vpc_router_a.name
  min_ports_per_vm                   = 64
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  enable_endpoint_independent_mapping = false

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork_private_a.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnetwork_protected_a.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ALL"
  }
}
