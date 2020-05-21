# Continuous Deployment


## tensorleap-web

* Deployment consists of:
  * 1. web component
  * 2. mongoDB backend
  * 3. Kibana client
  * 4. ElastirSearch 

## tensorleap-node-server

## tensorleap-sysvcs

* Deployment consists of `cpu` & `gpu` tags & a conifg.yaml

* K8s resource definitions

1. deployment for the main application(s)
2. config map which overrides thew `/app/src/config.yaml`

```sh├── tensorleap
│   ├── assets
│   │   └── config.yaml
│   ├── kustomization.yaml
│   └── patches
│       └── deployment.yaml
```

