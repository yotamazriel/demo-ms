# default pool
module "dev-cluster-default-pool" {
  source                      = "../modules/cloud-foundation-fabric/modules/gke-nodepool"
  name                        = "default-pool"
  project_id                  = module.project-dev.project_id
  location                    = module.dev-cluster.location
  cluster_name                = module.dev-cluster.name
  node_config_service_account = module.service-account-gke-node.email
  node_config_machine_type    = "n1-standard-4"
  node_config_image_type      = "COS"
  max_pods_per_node           = 55
  initial_node_count          = 3
  
  node_config_labels = {
    default-pool = "true"
  }

  #TODO replace with cluster-autoscaler ?!
  autoscaling_config = {
    min_node_count = 3
    max_node_count = 6
  }

  management_config = {
    # acceaptible + securitity path compliant needs `upgrade_config` below
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_config = {
    # we allow 1 more node during rolling upgrade
    max_surge = 1
    # we always have 1 vm wavailable in the node-pool during rolling update of nodes.
    max_unavailable = 0
  }

}
# python-services pool
module "dev-cluster-python-services" {
  source                      = "../modules/cloud-foundation-fabric/modules/gke-nodepool"
  name                        = "python-services"
  project_id                  = module.project-dev.project_id
  location                    = module.dev-cluster.location
  cluster_name                = module.dev-cluster.name
  node_config_service_account = module.service-account-gke-node.email
  node_config_machine_type    = "n1-standard-2"
  node_config_image_type      = "UBUNTU"
  node_config_preemptible     = true
  max_pods_per_node           = "55"
  node_config_labels = {
    accelerator = "python-services"
  }
  #TODO replace with cluster-autoscaler ?!
  autoscaling_config = {
    min_node_count = 1
    max_node_count = 3
  }

  management_config = {
    # acceaptible + securitity path compliant needs `upgrade_config` below
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_config = {
    # we allow 1 more node during rolling upgrade
    max_surge = 1
    # we always have 1 vm wavailable in the node-pool during rolling update of nodes.
    max_unavailable = 0
  }

}
# ealsticsearch pool
module "dev-cluster-elastic" {
  source                      = "../modules/cloud-foundation-fabric/modules/gke-nodepool"
  name                        = "elastic-pool"
  project_id                  = module.project-dev.project_id
  location                    = module.dev-cluster.location
  cluster_name                = module.dev-cluster.name
  initial_node_count          = "3" #TODO more eslatic more nodes ?
  node_config_service_account = module.service-account-gke-node.email
  node_config_machine_type    = "n1-standard-4"
  node_config_image_type      = "UBUNTU"
  node_config_preemptible     = false
  max_pods_per_node           = "55"
  node_config_oauth_scopes    = ["https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/service.management", "https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/monitoring"]
  node_config_labels = {
    accelerator = "python-services"
  }

  management_config = {
    # acceaptible + securitity path compliant needs `upgrade_config` below
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_config = {
    # we allow 1 more node during rolling upgrade
    max_surge = 1
    # we always have 1 vm wavailable in the node-pool during rolling update of nodes.
    max_unavailable = 0
  }

}

# k-80 node-pool
module "dev-cluster-k80-nodepool" {
  source                      = "../modules/cloud-foundation-fabric/modules/gke-nodepool"
  name                        = "nvidia-tesla-k80"
  project_id                  = module.project-dev.project_id
  # gcloud compute accelerator-types list --filter="zone:( us-central1-b us-central1-a us-central1-c )"
  location                    = "us-central1-c"
  node_locations            = [ "us-central1-c" ]
  cluster_name                = module.dev-cluster.name
  node_config_service_account = module.service-account-gke-node.email
  node_config_machine_type    = "n1-standard-2"
  node_config_image_type      = "UBUNTU"
  node_config_preemptible     = true
  max_pods_per_node           = "55"

  node_config_guest_accelerator = {
    nvidia-tesla-k80 = 1
  }

  node_config_labels = {
    accelerator = "nvidia-tesla-k80"
  }
  
  initial_node_count = 0
  
  autoscaling_config = {
    min_node_count = 0
    max_node_count = 3
  }

  management_config = {
    # acceaptible + securitity path compliant needs `upgrade_config` below
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_config = {
    # we allow 1 more node during rolling upgrade
    max_surge = 1
    # we always have 1 vm wavailable in the node-pool during rolling update of nodes.
    max_unavailable = 0
  }
  #TODO use admition control to manage bursts and taints
  # -> https://www.terraform.io/docs/providers/google/r/container_cluster.html#tainthttps://www.terraform.io/docs/providers/google/r/container_cluster.html#taint
  # looks like GCP adds these automatically !
  //  taint {
  //     effect = "NO_SCHEDULE"
  //     key    = "nvidia.com/gpu"
  //     value  = "present"
  //   }
}

# k-80 node-pool
module "dev-cluster-k80-highmem-nodepool" {
  source                      = "../modules/cloud-foundation-fabric/modules/gke-nodepool"
  name                        = "nvidia-tesla-k80-np"
  project_id                  = module.project-dev.project_id
  # gcloud compute accelerator-types list --filter="zone:( us-central1-b us-central1-a us-central1-c )"
  location                    = "us-central1-c"
  node_locations              = [ "us-central1-c" ]
  cluster_name                = module.dev-cluster.name
    
  node_config_service_account = module.service-account-gke-node.email
  node_config_machine_type    = "n1-highmem-4"
  node_config_image_type      = "UBUNTU"
  node_config_preemptible     = true
  max_pods_per_node           = "55"

  node_config_guest_accelerator = {
    nvidia-tesla-k80 = 1
  }

  node_config_labels = {
    accelerator = "nvidia-tesla-k80"
  }
  
  initial_node_count = 0
  
  autoscaling_config = {
    min_node_count = 0
    max_node_count = 3
  }

  management_config = {
    # acceaptible + securitity path compliant needs `upgrade_config` below
    auto_repair  = true
    auto_upgrade = true
  }

  upgrade_config = {
    # we allow 1 more node during rolling upgrade
    max_surge = 1
    # we always have 1 vm wavailable in the node-pool during rolling update of nodes.
    max_unavailable = 0
  }
  #TODO use admition control to manage bursts and taints
  # -> https://www.terraform.io/docs/providers/google/r/container_cluster.html#tainthttps://www.terraform.io/docs/providers/google/r/container_cluster.html#taint
  # looks like GCP adds these automatically !
  //  taint {
  //     effect = "NO_SCHEDULE"
  //     key    = "nvidia.com/gpu"
  //     value  = "present"
  //   }
}

# roles assigned via this module use non-authoritative IAM bindings at the
# project level, with no risk of conflicts with pre-existing roles

module "service-account-gke-node" {
  source     = "../modules/cloud-foundation-fabric/modules/iam-service-accounts"
  project_id = module.project-dev.project_id
  names      = ["gke-node"]
  iam_project_roles = {
    ("${module.project-dev.project_id}") = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
      "roles/dns.admin",
      "roles/storage.objectViewer",
      "roles/artifactregistry.writer",
      "roles/storage.admin"
    ]
  }
}

