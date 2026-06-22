terraform{
  required_providers {
    google = {
      source="hashicorp/google"
    }
  }
  backend "gcs"{
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_compute_instance" "gatus-vm" {
  name = var.machine_name
  machine_type = "e2-micro"
  zone = var.region
  labels = {
    managed-by = "terraform"
    env = "prd"
    app = "gatus"
  }
  tags=["gatus"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
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
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = templatefile(abspath("${path.module}/../scripts/startup.sh.tftpl"), {
    ssh_private_key = var.ssh_private_key
  })
  metadata = {
  enable-oslogin = "TRUE"
}
  
}
resource "google_compute_instance_iam_member" "ssh_access" {
  instance_name = google_compute_instance.gatus-vm.name
  zone          = google_compute_instance.gatus-vm.zone
  role          = "roles/compute.osLogin"
  member        = "serviceAccount:${var.email_sa}"
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
  value = google_compute_instance.gatus-vm.network_interface[0].access_config[0].nat_ip
}
