# Tensorleap Infra

[![Docs status](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-doc&revision=true)](https://cd.dev.tensorleap.ai/applications/tensorleap-doc)

Services Status table:

| Environment (NS) | Component               | Status Badge                                                                                  | Relevant links                                                                 |
| ---------------- | ----------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| Infra-Shared     | Docs                    | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-doc&revision=true)              | [ArgoCD](https://cd.dev.tensorleap.ai/applications/tensorleap-doc)             |
| Infra-Shared     | argo-events             | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=argo-events&revision=true)                 | [ArgoCD](https://cd.dev.tensorleap.ai/applications/argo-events)                |
| Infra-Shared     | argo-workflows          | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=argo-workflows&revision=true)              | [ArgoCD](https://cd.dev.tensorleap.ai/applications/argo-workflows)             |
| Infra-Shared     | argo-events (ci-events) | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=ci-events&revision=true)                   | [ArgoCD](https://cd.dev.tensorleap.ai/applications/ci-events)                  |
| Infra-Shared     | argo-workflows          | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=argo-workflows&revision=true)              | [ArgoCD](https://cd.dev.tensorleap.ai/applications/argo-workflows)             |
| Infra-Shared     | nfs-server-provisioner  | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=nfs-server-provisioner&revision=true)      | [ArgoCD](https://cd.dev.tensorleap.ai/applications/nfs-server-provisioner)     |
| ---              | ---                     | ---                                                                                           | ---                                                                            |
| Production       | Docs                    | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-doc&revision=true)              | [webapp](https://docs.dev.tensorleap.ai)                                       |
| Production (WIP) | Web                     | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-web-prod&revision=true)         | [webapp](https://app.tensorleap.ai)                                            |
| Production (WIP) | Node-Server             | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-node-server-prod&revision=true) | [api](https://app.tensorleap.ai/api), [admin](https://app.tensorleap.ai/admin) |
| ---              | ---                     | ---                                                                                           | ---                                                                            |
| Dev              | Web                     | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-web&revision=true)              | [webapp](https://app.dev.tensorleap.ai)                                        |
| Dev              | Node-Server             | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-node-server&revision=true)      |                                                                                |
| ---              | ---                     | ---                                                                                           | ---                                                                            |
| Infra-Dev        | Overall*                | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=infra-dev&revision=true)                   | All apps status se below per component                                         |
| ---              | ---                     | ---                                                                                           | ---                                                                            |
| Infra-Dev        | Elasticsearch           | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=elasticsearch&revision=true)               | [ArgoCD](https://cd.dev.tensorleap.ai/applications/elasticsearch)              |
| Infra-Dev        | Kibana                  | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=kibana&revision=true)                      | [ArgoCD](https://cd.dev.tensorleap.ai/applications/kibana)                     |
| Infra-Dev        | MongoDB                 | ![alt](https://cd.dev.tensorleap.ai/api/badge?name=mongodb&revision=true)                     | [ArgoCD](https://cd.dev.tensorleap.ai/applications/mongodb)                    |
| ---              | ---                     | ---                                                                                           | ---                                                                            |

![alt](https://cd.dev.tensorleap.ai/api/badge?name=tensorleap-node-server-prod&revision=**true******) - planned / unknown

## Quickstart

Run docs:

```sh
git clone git@github.com:tensorleap/infra.git

```

## CI/CD for docs (prototype for ci componenets)

Makefile -> [see](./Makefile)

`make release` - Runs a docker build, tags it with short sha + tags latest, then pushes to $REGISTRY
`make deploy-dev` (WIP) - Runs a kustomize patch and git commit for given component

```sh
make release 
/usr/local/bin/docker build --label docker_build_timestamp=2020-05-16T22:03:48Z --label git_repo=git@github.com:tensorleap/infra.git --label git_branch=master --label git_commit=a39067d . -t gcr.io/tensorleap-dev-3/tensorleap-doc:latest
Sending build context to Docker daemon  174.9MB
Step 1/16 : FROM node:latest
 ---> a5a6a9c32877
Step 2/16 : RUN npm install -g docsify-cli@latest
 ---> Using cache
 ---> 5d6e894fd4a1
Step 3/16 : RUN mkdir -p /usr/local/docsify
 ---> Using cache
 ---> 73e9f7592261
Step 4/16 : ENV DEBUG 0
 ---> Using cache
 ---> a91e377ff2d4
Step 5/16 : ENV PORT 3000
 ---> Using cache
 ---> 7043f6b7fc0d
Step 6/16 : ENV DOCSIFY_VERSION latest
 ---> Using cache
 ---> c982db289746
Step 7/16 : ENV NODE_VERSION latest
 ---> Using cache
 ---> 78cd4f1f7907
Step 8/16 : EXPOSE 3000
 ---> Using cache
 ---> bc5e31645073
Step 9/16 : WORKDIR /usr/local/docsify
 ---> Using cache
 ---> 86ded8a20af0
Step 10/16 : ENTRYPOINT [ "docsify", "serve", "--port", "3000" ]
 ---> Using cache
 ---> 78efaa436bcb
Step 11/16 : ADD ./docs .
 ---> Using cache
 ---> 6c6853811122
Step 12/16 : CMD [ "." ]
 ---> Using cache
 ---> f877a0316020
Step 13/16 : LABEL docker_build_timestamp=2020-05-16T22:03:48Z
 ---> Running in e96aaffaca48
Removing intermediate container e96aaffaca48
 ---> 8725878df60b
Step 14/16 : LABEL git_branch=master
 ---> Running in aabe2d9dc270
Removing intermediate container aabe2d9dc270
 ---> a58c41389b8b
Step 15/16 : LABEL git_commit=a39067d
 ---> Running in 4c86889ebc6f
Removing intermediate container 4c86889ebc6f
 ---> cc3fa65f9ff3
Step 16/16 : LABEL git_repo=git@github.com:tensorleap/infra.git
 ---> Running in 319b6c008b6a
Removing intermediate container 319b6c008b6a
 ---> 420b14679696
Successfully built 420b14679696
Successfully tagged gcr.io/tensorleap-dev-3/tensorleap-doc:latest
/usr/local/bin/docker tag gcr.io/tensorleap-dev-3/tensorleap-doc:latest gcr.io/tensorleap-dev-3/tensorleap-doc:a39067d
/usr/local/bin/docker push gcr.io/tensorleap-dev-3/tensorleap-doc:latest 
The push refers to repository [gcr.io/tensorleap-dev-3/tensorleap-doc]
7182df9582a6: Layer already exists 
fbb8bdc1393a: Layer already exists 
4d376a90d3dc: Layer already exists 
a794511022d8: Layer already exists 
003219296229: Layer already exists 
0845d99db73f: Layer already exists 
496d6557f1e3: Layer already exists 
867786449541: Layer already exists 
92d17ee6d9da: Layer already exists 
e54368741774: Layer already exists 
5a6c4d956b5d: Layer already exists 
86ab2c6c5d58: Layer already exists 
latest: digest: sha256:1ad92b0b4213d5e654693e7047c3a6584445aa5acc9b6f960ac9e91158ee87d7 size: 2844
/usr/local/bin/docker push gcr.io/tensorleap-dev-3/tensorleap-doc:a39067d
The push refers to repository [gcr.io/tensorleap-dev-3/tensorleap-doc]
7182df9582a6: Layer already exists 
fbb8bdc1393a: Layer already exists 
4d376a90d3dc: Layer already exists 
a794511022d8: Layer already exists 
003219296229: Layer already exists 
0845d99db73f: Layer already exists 
496d6557f1e3: Layer already exists 
867786449541: Layer already exists 
92d17ee6d9da: Layer already exists 
e54368741774: Layer already exists 
5a6c4d956b5d: Layer already exists 
86ab2c6c5d58: Layer already exists 
a39067d: digest: sha256:1ad92b0b4213d5e654693e7047c3a6584445aa5acc9b6f960ac9e91158ee87d7 size: 2844
```

## Project milestones

- [Milestones](MILESTONES.md)

## Working with Tensorleap infra

- Make sure you run [GCP bootstrap](cloud-operations/gcp-tf-bootstrap.md) and ready to get started with [terraform]|(https://terraform.io)
- Based on ./terraform/envs/\${environment} you will find a terraform module which will bootstrap a GKE cluster with a "tensorleap standard" `cluster spec` [WIP]

## Architectural overview & key concepts

## shared-vpc

- [shared-vpc](cloud-operations/shared-vpc.md)

## CI process with Argo workflows + Argo events

## CD process with ArgoCD
