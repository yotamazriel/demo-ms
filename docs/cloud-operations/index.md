# Infrastructure as code

## 💾 Developer Guide

### 💻 Workstation Setup

### Prerequisites

- [terraform] version v0.11.13+
- [gcp-cli] version latest

### Terraform steps /

```sh
export TF_VAR_org_id=tensorleap
export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
export TF_ADMIN=${USER}-terraform-admin
export TF_CREDS=~/.config/gcloud/${USER}-terraform-admin.json
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/key.json"
```

- terraform gs bucket creation -> see \${repo_root}/terraform/base/...

#### terraform init -> initialize + get plugins

```sh
terraform init

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
