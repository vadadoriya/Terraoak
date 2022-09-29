resource "google_container_cluster" "container" {
  name               = "marcellus-wallace"
  location           = "us-central1-a"
  initial_node_count = 3
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    disk_size_gb = ""

  }
}

resource "google_container_node_pool" "container" {
  name       = "my-node-pool"
  cluster    = google_container_cluster.container.name
  node_count = 1

  node_config {
    disk_size_gb = ""
}
}
