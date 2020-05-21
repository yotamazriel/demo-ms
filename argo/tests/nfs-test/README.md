# test nfs share

## Setup

```sh
cd argo/tests/nfs-test
kustomize build . | kubectl apply -f -
```

would yield:

```sh
deployment.apps/nfs-test-1-web created
deployment.apps/nfs-test-2-web created
deployment.apps/nfs-test-3-web created
deployment.apps/web created
persistentvolumeclaim/nfs-data created
persistentvolumeclaim/nfs-test-1-nfs-data created
persistentvolumeclaim/nfs-test-2-nfs-data created
persistentvolumeclaim/nfs-test-3-nfs-data created
```

## Test

- Validate volumes:

```sh
k get pvc
NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
nfs-data              Bound    pvc-8cc49a1c-1a60-4f16-a636-dbf562ff2fbe   250Gi      RWX            nfs            9m17s
nfs-test-1-nfs-data   Bound    pvc-f949d876-0aff-4190-b622-f3b47ddc5078   250Gi      RWX            nfs            9m17s
nfs-test-2-nfs-data   Bound    pvc-28a2f75a-7c1d-49ff-9156-d2d72651f369   250Gi      RWX            nfs            9m16s
nfs-test-3-nfs-data   Bound    pvc-c2f0081e-cc90-4852-96ea-9cae908ed11d   250Gi      RWX            nfs            9m16s
```

- Write a file to first pod e.g. `nfs-test-1`

```sh
kubectl exec -it $(kubectl get po | grep nfs-test-1 | awk '{print $1}') touch /data/hello_from_nfs
```

- ls file on all pods
- 


 