# Remote state config, passed at init:
#   terraform init -backend-config=backend.hcl
# Storage account + container are created once, out-of-band, per environment.
resource_group_name  = "rg-tfstate-uks"
storage_account_name = "sttfstateuksctso"
container_name       = "tfstate"
key                  = "platform/dev.terraform.tfstate"
