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
    network    = google_compute_network.vpcnet.name
    subnetwork = google_compute_subnetwork.vpcsubnet.name
    access_config {}
  }

  metadata_startup_script = file("startup-script.sh")
}
