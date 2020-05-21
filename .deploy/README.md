# local development of k8s resources

## gcr token for local development

create a service-account token and create a file `.deploy/gcr-json-key.yaml` it will be used by kind to pull images we have in `tensorleap-dev-3` gcr repo.

## local cluster if needed

- using kind
-

```sh
kind create cluster --name tensorleap-dev
Creating cluster "tensorleap-dev" ...
 ✓ Ensuring node image (kindest/node:v1.17.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-tensorleap-dev"
You can now use your cluster with:

kubectl cluster-info --context kind-tensorleap-dev

Have a nice day! 👋
hagzags-mac:cd hagzag$ kubectl cluster-info --context kind-tensorleap-dev
Kubernetes master is running at https://127.0.0.1:32768
KubeDNS is running at https://127.0.0.1:32768/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

## "building" manifests

```sh
cd .deploy
kustomize build .
```

Should yield:

```sh
apiVersion: v1
data:
  .dockerconfigjson: <redacted>
kind: Secret
metadata:
  name: gcr-json-key
  namespace: default
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: tensorleap-web
  name: tensorleap-web
spec:
  ports:
  - name: http
    port: 80
    targetPort: http
  selector:
    app: tensorleap-web
  sessionAffinity: None
  type: ClusterIP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tensorleap-web
spec:
  selector:
    matchLabels:
      app: tensorleap-web
  template:
    metadata:
      labels:
        app: tensorleap-web
    spec:
      containers:
      - image: gcr.io/tensorleap-dev-3/web-app:latest
        imagePullPolicy: Always
        name: web-app
        ports:
        - containerPort: 80
          name: http
      imagePullSecrets:
      - name: gcr-secret
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: tensorleap-web
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: tensorleap-web
          servicePort: http
        path: /
```

You should be able to access the server locally via `kubectl port-forward` / ip of the server.


