# Terraform Google GKE setup

This guide is based on the [following link](https://www.terraform.io/docs/providers/google/guides/getting_started.html)

## Prerequisites

- gcloud cli version `latest` ([installation](https://cloud.google.com/sdk/install))
- terraform version `>= v0.12.20` ([installation](https://learn.hashicorp.com/terraform/getting-started/install.html))

  ```sh
  docker run -v $HOME/bin:/software sethvargo/hashicorp-installer terraform 0.12.24
  ```

## Setup

Once the Cloud SDK is installed you can authenticate, set the project, and choose a compute zone with the interactive command:

```sh
gcloud auth login
```

> Note: you will be prompt by your browser to login, once successful you should be redirected to -> https://cloud.google.com/sdk/auth_success.

1. set env vars to be used later in this guide

```sh
export TF_VAR_org_id=219080304146                       # gcloud organizations list
export TF_VAR_billing_account="01A513-C44F6C-A1B22F"    # gcloud beta billing accounts list
export TF_ADMIN=tensorleap-admin
export TF_CREDS=~/.config/gcloud/tensorleap-admin.json  # where the credentials file will be stored

```

2. Create the Terraform Admin Project

```sh
gcloud projects create --name=${TF_ADMIN}  \
    --organization ${TF_VAR_org_id}   \
    --set-as-default

```

Should yield something like:

```sh
No project id provided.

Use [tensorleap-admin-273613] as project id (Y/n)?  Y

Create in progress for [https://cloudresourcemanager.googleapis.com/v1/projects/tensorleap-admin-273613].
Waiting for [operations/cp.8138913449382167480] to finish...done.
Enabling service [cloudapis.googleapis.com] on project [tensorleap-admin-273613]...
Operation "operations/acf.7f943985-f322-44ae-939a-1671a00d4049" finished successfully.
Updated property [core/project] to [tensorleap-admin-273613].
```

3. Attach to your existing billing account (or different account - client account ?!)
   Please note the project-id may vary from setup to setup ... hence the `export TF_ADMIN=tensorleap-admin-${id}` before we attach billing.

```sh
export TF_ADMIN=tensorleap-admin-273613
gcloud beta billing projects link ${TF_ADMIN} \
--billing-account ${TF_VAR_billing_account}
```

Should yield something like:

```sh
billingAccountName: billingAccounts/01A513-C44F6C-A1B22F
billingEnabled: true
name: projects/tensorleap-admin-273613/billingInfo
projectId: tensorleap-admin-273613
```

4. Create the Terraform service account

```sh
gcloud iam service-accounts create terraform \
--display-name "Terraform admin account"
```

5. Save a copy of the service account - this account will be used from here-on by Terraform

```
gcloud iam service-accounts keys create ${TF_CREDS} \
--iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com
```

6. Grant the service account permission to view the Admin Project and manage Cloud Storage:

```sh
gcloud projects add-iam-policy-binding ${TF_ADMIN} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/viewer

gcloud projects add-iam-policy-binding ${TF_ADMIN} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/storage.admin

```

7. Enable the requires API's which will utilized by terraform down the pipeline

```sh
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable admin.googleapis.com
gcloud services enable container.googleapis.com
```

8. Add organization/folder-level permissions

```sh

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/resourcemanager.organizationViewer

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/billing.user

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/container.clusterAdmin

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role  roles/compute.admin

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/iam.serviceAccountUser

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role roles/compute.networkAdmin

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role=roles/compute.xpnAdmin \
--user-output-enabled false

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role=roles/iam.serviceAccountAdmin \
--user-output-enabled false

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
--member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
--role=roles/resourcemanager.projectIamAdmin \
--user-output-enabled false
```

9. Set up remote state in Cloud Storage [ will be used by terraform to preseve & lock terraform states]

```sh
gsutil mb -p ${TF_ADMIN} gs://tensorleap-admin-state

```

Set versioning on the gs bucket:

```sh
gsutil versioning set on gs://tensorleap-admin-state
```

10. you are now ready to start "Terraforming" with the `serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com` Iam service account.
