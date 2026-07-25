terraform{
  required_providers{
    google = {
      source= "hashicorp/google"
    }
  }
  backend "gcs"{
    bucket = "tfstate-gatus"
    prefix "terraform/state"
  }
}

provider "google"{
  project = var.project
  region = var.region
}

resource "google_service_account" "sa_terraform-vm"{
  account_id = "terraform-vm"
  display_name = "Terraform VM"
}

resource "google_project_iam_member" "sa_terraform-vm_iam"{
  for_each = toset(var.iam_roles)
  project = var.project
  role = each.value
}

resource "google_compute_instance" "vm-terraform"{
  name=var.name_vm
  machine_type = var.machine_type
  zone = var.zone_project
  for_each = toset(var.tags)
  tags = each.value
}