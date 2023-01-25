output "domain-name" {
  value = google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip
}

output "application-url" {
  value = "${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}/index.php"
}
