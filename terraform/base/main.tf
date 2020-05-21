# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

// resource "random_id" "id" {
//   byte_length = 4
//   prefix      = var.project_name
// }

locals {
  # project-host
  admin-project-version = 0003
  # shared-project
  shared-project-version = 0003
  # dev-project
  dev-project-version = 0003
}

###############################################################################
#                          Host and service projects                          #
###############################################################################

# the container.hostServiceAgentUser role is needed for GKE on shared VPC

module "project-host" {
  source          = "../modules/cloud-foundation-fabric/modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  // name            = "admin"
  name     = "admin-${local.admin-project-version}"
  services = concat(var.project_services, ["dns.googleapis.com"])
  iam_roles = [
    "roles/container.hostServiceAgentUser", "roles/owner"
  ]
  iam_members = {
    "roles/container.hostServiceAgentUser" = [
      "serviceAccount:${module.project-dev.gke_service_account}"
    ]
    "roles/owner" = var.owners_host
  }
}

module "project-shared" {
  source          = "../modules/cloud-foundation-fabric/modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  // name            = "shared"
  name           = "shared-${local.shared-project-version}"
  services       = var.project_services
  oslogin        = true
  oslogin_admins = var.owners_gce
  iam_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/owner"
  ]
  iam_members = {
    // "roles/logging.logWriter"       = [module.vm-bastion.service_account_iam_email],
    // "roles/monitoring.metricWriter" = [module.vm-bastion.service_account_iam_email],
    "roles/owner" = var.owners_gce
  }
}

# the container.developer role assigned to the bastion instance service account
# allows to fetch GKE credentials from bastion for clusters in this project

module "project-dev" {
  source          = "../modules/cloud-foundation-fabric/modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  // name            = "dev"
  name     = "dev-${local.dev-project-version}"
  services = var.project_services
  iam_roles = [
    "roles/container.developer",
    "roles/owner",
  ]
  iam_members = {
    "roles/owner" = var.owners_gke
    // "roles/container.developer" = [module.vm-bastion.service_account_iam_email]
  }
}

################################################################################
#                                  Networking                                  #
################################################################################

# the service project GKE robot needs the `hostServiceAgent` role throughout
# the entire life of its clusters; the `iam_project_id` project output is used
# here to set the project id so that the VPC depends on that binding, and any
# cluster using it then also depends on it indirectly; you can of course use
# the `project_id` output instead if you don't care about destroying

# subnet IAM bindings control which identities can use the individual subnets

module "vpc-shared" {
  source          = "../modules/cloud-foundation-fabric/modules/net-vpc"
  project_id      = module.project-host.project_id
  name            = "shared-vpc"
  shared_vpc_host = true
  shared_vpc_service_projects = [
    module.project-shared.project_id,
    module.project-dev.project_id
  ]
  subnets = {
    gce = {
      ip_cidr_range      = var.ip_ranges.gce
      region             = var.region
      secondary_ip_range = {}
    }
    gke = {
      ip_cidr_range = var.ip_ranges.gke
      region        = var.region
      secondary_ip_range = {
        pods     = var.ip_secondary_ranges.gke-pods
        services = var.ip_secondary_ranges.gke-services
      }
    }
  }
  iam_roles = {
    gke = ["roles/compute.networkUser", "roles/compute.securityAdmin"]
    gce = ["roles/compute.networkUser"]
  }
  iam_members = {
    gce = {
      "roles/compute.networkUser" = concat(var.owners_gce, [
        "serviceAccount:${module.project-shared.cloudsvc_service_account}",
      ])
    }
    gke = {
      "roles/compute.networkUser" = concat(var.owners_gke, [
        "serviceAccount:${module.project-dev.cloudsvc_service_account}",
        "serviceAccount:${module.project-dev.gke_service_account}",
      ])
      "roles/compute.securityAdmin" = [
        "serviceAccount:${module.project-dev.gke_service_account}",
      ]
    }
  }
}

module "vpc-shared-firewall" {
  source               = "../modules/cloud-foundation-fabric/modules/net-vpc-firewall"
  project_id           = module.project-host.project_id
  network              = module.vpc-shared.name
  admin_ranges_enabled = true
  admin_ranges         = values(var.ip_ranges)
}

module "nat" {
  source         = "../modules/cloud-foundation-fabric/modules/net-cloudnat"
  project_id     = module.project-host.project_id
  region         = var.region
  name           = "vpc-shared"
  router_create  = true
  router_network = module.vpc-shared.name
}

