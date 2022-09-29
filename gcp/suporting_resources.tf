resource "google_kms_crypto_key" "kms" {
  description             = "KMS key 1"
  deletion_window_in_days = 10
}

resource "google_compute_firewall" "firewall" {
  name    = "test-firewall"
  network = google_compute_network.network.name

  allow {
    protocol = "all"
  }

  source_ranges = ["*"]
}

resource "google_compute_network" "network" {
  name = "test-network"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.network.name
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_subnetwork_iam_binding" "subnetwork" {
  subnetwork = google_compute_subnetwork.subnetwork.name
  role = "roles/compute.networkUser"
  members = ["allUsers"]
}



