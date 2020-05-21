# Github Actions [ CI candidate ]

- [GoogleCloudPlatform/github-actions](https://github.com/GoogleCloudPlatform/github-actions)

# FluxCD + ArgoCD

- [FluxCD](https://fluxcd.io/)
- [ArgoCD](https://argoproj.github.io/)
  - [bootstrapping with app-of-apps](https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/)
  - [ingress](https://argoproj.github.io/argo-cd/operator-manual/ingress/)
  - [argocd-example-apps](https://github.com/argoproj/argocd-example-apps)
  - [useful samples](https://github.com/jessesuen/k8s-deployments)

# GKE

- [cluster-shared-vpc](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc)

# Terraform

- [jetstack/terraform-google-gke-cluster](https://github.com/jetstack/terraform-google-gke-cluster)
- supports node_pools

  ```sh
    node_pools = [
        {
            name                       = "default"
            initial_node_count         = 1
            autoscaling_min_node_count = 2
            autoscaling_max_node_count = 3
            management_auto_upgrade    = true
            management_auto_repair     = true
            node_config_machine_type   = "n1-standard-1"
            node_config_disk_type      = "pd-standard"
            node_config_disk_size_gb   = 100
            node_config_preemptible    = false
        },
    ]
  ```
