output "domain-name" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}

output "application-url" {
  value = "${google_compute_instance.vm_instance.network_interface.0.network_ip}/index.php"
}
