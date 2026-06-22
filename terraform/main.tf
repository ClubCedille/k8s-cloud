terraform{
  required_providers {
    google = {
      source="hashicorp/google"
    }
  }
  backend "gcs"{
    bucket = var.bucket
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_compute_instance" "gatus-vm" {
  name = "ced-gce-gatus-prd-na1-01"
  machine_type = "e2-micro"
  zone = "northamerica-norhteast1-a"
  labels = {
    managed-by = "terraform"
    env = "prd"
    app = "gatus"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-13"
    }
  }
  network_interface {
    network = "default"
    access_config {

    }
  }

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  service_account {
    email = var.email_sa
    scopes = ["cloud-plateform"]
  }
  metadata_startup_script = templatefile(abspath("${path.module}/../scripts/startup.sh.tftpl"), {
    ssh_private_key = var.ssh_private_key
  })
  
}

resource "google_compute_firewall" "allow-httptrafic"{
  name = "allow-httpgatus"
  network = "default"

  allow {
    protocol = "tcp" 
      ports = ["80", "443"]
  }
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["gatus"]
}

output "gatus_ip" {
    value = google_compute_instance.gatus-vm.network_interface.0.access_config.0.nat_ip
}
