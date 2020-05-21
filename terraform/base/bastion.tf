################################################################################
#                                     DNS                                      #
################################################################################

// module "host-dns" {
//   source          = "../modules/cloud-foundation-fabric/modules/dns"
//   project_id      = module.project-host.project_id
//   type            = "private"
//   name            = "dev"
//   domain          = "tensorleap.ai"
//   client_networks = [module.vpc-shared.self_link]
//   recordsets = [
//     { name = "localhost", type = "A", ttl = 300, records = ["127.0.0.1"] },
//     { name = "bastion", type = "A", ttl = 300, records = module.vm-bastion.internal_ips },
//   ]
// }

################################################################################
#                                     VM                                      #
################################################################################

// module "vm-bastion" {
//   source     = "../modules/cloud-foundation-fabric/modules/compute-vm"
//   project_id = module.project-shared.project_id
//   region     = module.vpc-shared.subnet_regions.gce
//   zone       = "${module.vpc-shared.subnet_regions.gce}-b"
//   name       = "bastion"
//   network_interfaces = [{
//     network    = module.vpc-shared.self_link,
//     subnetwork = lookup(module.vpc-shared.subnet_self_links, "gce", null),
//     nat        = false,
//     addresses  = null
//   }]
//   instance_count = 1
//   tags           = ["ssh"]
//   metadata = {
//     startup-script = join("\n", [
//       "#! /bin/bash",
//       "apt-get update",
//       "apt-get install -y bash-completion kubectl dnsutils"
//     ])
//   }
//   service_account_create = true
// }

