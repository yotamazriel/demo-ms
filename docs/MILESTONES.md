# Infra project milestones

## Milestone 0.1

- [x] [GCP bootstrap](cloud-operations/gcp-tf-bootstrap.md)
  - [x] Setup an admin project `ternsorleap-admin` with iam-role to manage networks and sub-projects (e.g `ternsorleap-dev`)
  - [x] Create terraform remote state bucket `tensorleap-admin-state`
- [x] Setup a shared vpc for public & private subnet ranges - via terraform
- [x]] Setup environment scoped projects `ternsorleap-dev` (`ternsorleap-staging`, `ternsorleap-production`)
  - [x] Setup a GKE cluster in `ternsorleap-dev`
  - [x] Access `ternsorleap-dev` cluster - via terraform
  - [ ] Bootstrap cluster with ArgoCD - [Installing argoCD](./kubernetes-resources/argoCD.md#dev)
- [ ] CI process for Docker container via google container registry
- [x] Add terraform remote state and share between projects
- [ ] NFS server replacement [https://rook.io/docs/rook/master/nfs.html](https://rook.io/docs/rook/master/nfs.html)

---

## Milestone xxx - TBD

- [ ] Install tensorleap infra dependencies `ternsorleap-dev`
- [ ] Install tensorleap components `ternsorleap-dev`
- [ ] CI process for Backend components
- [ ] CI process for Frontend components
- [ ] CD process for Frontend components
- [ ] CD process for Backend components

---

## Milestone xxx - TBD

- [ ] Setup a GKE cluster in `ternsorleap-staging`

  - [ ] Access `ternsorleap-staging` cluster - via terraform
  - [ ] Bootstrap cluster with ArgoCD - [Installing argoCD](./kubernetes-resources/argoCD.md#staging)

- [ ] Setup a GKE cluster in `ternsorleap-production`
  - [ ] Access `ternsorleap-production` cluster - via terraform
  - [ ] Bootstrap cluster with ArgoCD - [Installing argoCD](./kubernetes-resources/argoCD.md#production)

> Please note:

- [x] completed tasks
- [ ] open tasks
