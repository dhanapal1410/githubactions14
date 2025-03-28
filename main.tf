/*
resource "google_compute_network" "vpcnet" {
  name = "terraform-network"
}

resource "google_compute_subnetwork" "vpcsubnet" {
  name          = "terraform-subnetwork"
  network       = google_compute_network.vpcnet.name
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
}

resource "google_compute_firewall" "gfirewall" {
  name    = "allow-http"
  network = google_compute_network.vpcnet.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
*/

// Reference the existing network
data "google_compute_network" "existing_network" {
  name = "terraform-network"
}

data "google_compute_subnetwork" "existing_subnetwork" {
  name   = "terraform-subnetwork"
  region = "us-central1"
}

resource "google_compute_instance" "ginstance" {
  name         = "web-server"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = data.google_compute_network.existing_network.self_link
    subnetwork = data.google_compute_subnetwork.existing_subnetwork.self_link
    access_config {}
  }

  metadata_startup_script = file("startup-script.sh")
}
