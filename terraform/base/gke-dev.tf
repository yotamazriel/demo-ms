################################################################################
#                                     GKE                                      #
################################################################################

module "dev-cluster" {
  source                    = "../modules/cloud-foundation-fabric/modules/gke-cluster"
  name                      = "tensorleap-dev"
  project_id                = module.project-dev.project_id
  location                  = "${module.vpc-shared.subnet_regions.gke}-c"
  // node_locations            = [ "${module.vpc-shared.subnet_regions.gke}-a", "${module.vpc-shared.subnet_regions.gke}-c"]
  network                   = module.vpc-shared.self_link
  subnetwork                = module.vpc-shared.subnet_self_links.gke
  secondary_range_pods      = "pods"
  secondary_range_services  = "services"
  default_max_pods_per_node = 32
  release_channel           = "REGULAR"
  labels = {
    environment = "test"
    purpose     = "development-workload"
  }
  master_authorized_ranges = {
    internal-vms = var.ip_ranges.gce
    hagzaag-home = var.ip_ranges.hagzag_home
  }
  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.private_service_ranges.dev_svcs
  }
 
}
