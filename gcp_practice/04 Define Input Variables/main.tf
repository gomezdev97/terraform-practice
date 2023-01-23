# The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure.
terraform {
  # You can also define a version constraint for each provider in the required_providers {} block.
  # The version attribute is optional, but we recommend using it to enforce the provider version.
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

# The provider block configures the specified provider, in this case google. 
# A provider is a plugin that Terraform uses to create and manage your resources.
provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region = var.region
  zone = var.zone
}

# Use resource blocks to define components of your infrastructure.
# A resource might be a physical component such as a server, or it can be a logical resource such as a Heroku application.

# Resource blocks have two strings before the block: the resource type and the resource name.
# resource "<resource_type>" "<resource_name>" {}
resource "google_compute_instance" "vm_instance" {
  name         = var.vm_instance_name
  machine_type = "e2-micro"
  tags = ["web", "dev"]

  boot_disk {
    initialize_params {
      # image = "debian-cloud/debian-11"
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    # A default network is created for all GCP projects

    # The resource type and resource name form a unique ID for the resource.
    # In this case the ID that refers to the network created.
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}
