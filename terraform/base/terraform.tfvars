root_node          = "organizations/219080304146"
prefix             = "tensorleap"
billing_account_id = "01A513-C44F6C-A1B22F"
owners_gce         = ["user:yotam@tensorleap.ai", "user:haggai.zagury@tensorleap.ai", "user:doron.harnoy@tensorleap.ai"]
owners_gke         = ["user:yotam@tensorleap.ai", "user:haggai.zagury@tensorleap.ai", "user:doron.harnoy@tensorleap.ai"]
owners_host        = ["user:yotam@tensorleap.ai", "user:haggai.zagury@tensorleap.ai", "user:doron.harnoy@tensorleap.ai"]
region             = "us-central1"

ip_ranges = {
  # Add acess to the k8s endpoint.
  # Can also be done from the UI in 5 sec
  hagzag_home = "0.0.0.0/0", # allow access from all ;)
  # vpn server network preperation if/when needed
  gce = "10.0.16.0/24",
  gke = "10.0.32.0/24"
}

ip_secondary_ranges = {
  gke-pods     = "10.128.0.0/18",
  gke-services = "172.16.0.0/24"
}

private_service_ranges = {
  dev_svcs = "192.168.0.0/28",
}

project_services = [
  "resourceviews.googleapis.com",
  "stackdriver.googleapis.com",
]
