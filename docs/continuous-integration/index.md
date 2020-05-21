# Continuous Integration

## using Argo workflows + Argo events

- How does it differ from Jenkins ? - maintanence everything is in code (well, yaml ...)

## Use case

- Build a container and push it to Docker registry [a.k.a GCR]

### Build steps

[HLD](docs/continuous-integration/hld.md)

1. [x] CI - Checkout code from git repo
2. [ ] CI - Run tests & publish reports
3. [x] CI - Build container and tag it for release [ e.g. `git rev-parse --short HEAD` would yield the 7 first charectars of the git-commit -> something like: `c0fabcf` ]
4. [x] CI - Push container to registry < [WIP] based on tag ?!>
5. [x] CD - Checkout `tensorleap/infra` - prepare for CD
6. [x] CD - Patch with `kustomize` -> based on the trigger's origin branch choose the destination overlay e.g:
       tensorlea-web in infra would patch repository `github.com/tensorleap/infra` repo path `argo/cd/overlays/apps/dev/kustomization.yaml`
       in this all cases it would run: `kustomize edit image` `repo_url/app-name` : `git rev-parse --short HEAD`
       `kustomize edit set image gcr.io/tensorleap-dev-3/web-app:c0fabcf`
7. [x] CD - commit & push to infra master branch e.g
       `git commit -m rolling update to dev-branch`
8. [ ] CD - notify relevant slack / e-mail channel
9. [ ] See also [todo's below](#todos)
10. [ ] Add dind persistence.

#### CI - Checkout code from git repo

Part of Argo's sensor & evens-ource configurations

Sensor -> defined the origin and the event type:

```yaml

```

#### CI - Run tests & publish reports [TBD]

```yaml

```

#### CI - Build container and tag it for release

```yaml

```

#### CI - Push container to registry

```yaml

```

---

#### Useful links

- https://github.com/argoproj/argo/blob/master/examples/input-artifact-git.yaml
- https://github.com/argoproj/argo/blob/master/examples/rest-examples.md
-

#### TODO's

- [x] Create a storage / artifact repo dedicated service account [nfs server]
- [x] Disable cluster-wide role roles/owner (dangerous for long term security wise) - implemented key file secret
- [x] Automate service account secret in argo-workflows
- [ ] Adding secrets / keys should be done by secrets-manager

#### service account setup

- Get service account for cluster, this example uses the default gke node sa we setup as part of `tensorleap base`

```sh
cd `github.com/tensorleap/infra/terraform/base`
terraform output -json | jq '.service_accounts.value.gke_node'
```

- Create service account token for this sa to use

```sh
gcloud iam service-accounts keys create --iam-account \
gke-node@tensorleap-dev-3.iam.gserviceaccount.com \
key.json
```

- Create a kubernetes secret which holds the service account token for this sa to use

```sh
kubectl create secret generic gcp-key --from-file key.json --namespace argo
```
