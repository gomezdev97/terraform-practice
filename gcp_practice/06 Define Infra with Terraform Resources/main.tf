provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region = var.region
  zone = var.zone
}

provider "random" {}

resource "random_pet" "name" {}


resource "google_compute_instance" "vm_instance" {
  name         = var.vm_instance_name
  machine_type = "e2-micro"
  metadata_startup_script = "${file("init-script.sh")}"
  tags = [random_pet.name.id]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
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

resource "google_compute_firewall" "ingress"{
  project = var.project
  name = "ingress-allow-all"
  network = google_compute_network.vpc_network.name
  direction = "INGRESS"
  allow {
    protocol = "all"
  }
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "egress"{
  project = var.project
  name = "egress-allow-all"
  network = google_compute_network.vpc_network.name
  direction = "EGRESS"
  allow {
    protocol = "all"
  }
  allow {
    protocol = "all"
  }
}

# resource "google_compute_network_firewall_policy" "terraform_firewall_policy" {
#   name        = "tf-policy"
#   description = "Sample global network firewall policy"
#   project     = var.project
# }

# resource "google_compute_network_firewall_policy_rule" "primary" {
#   action                  = "allow"
#   description             = "This is a simple rule description"
#   direction               = "INGRESS"
#   disabled                = false
#   enable_logging          = true
#   firewall_policy         = google_compute_network_firewall_policy.terraform_firewall_policy.name
#   priority                = 1000
#   rule_name               = "terraform-test-rule"
#   # target_service_accounts = ["emailAddress:my@service-account.com"]

#   match {
#     # src_ip_ranges = ["10.100.0.1/32"]
#     src_ip_ranges = ["0.0.0.0/0"]

#     # src_secure_tags {
#     #   name = "tagValues/${google_tags_tag_value.basic_value.name}"
#     # }

#     layer4_configs {
#       ip_protocol = "80"
#     }
#   }
# }

# resource "google_compute_network_firewall_policy_rule" "secundary" {
#   action                  = "allow"
#   description             = "This is a simple rule description"
#   direction               = "EGRESS"
#   disabled                = false
#   enable_logging          = true
#   firewall_policy         = google_compute_network_firewall_policy.terraform_firewall_policy.name
#   priority                = 1000
#   rule_name               = "terraform-test-rule"
#   # target_service_accounts = ["emailAddress:my@service-account.com"]

#   match {
#     # src_ip_ranges = ["10.100.0.1/32"]
#     dest_ip_ranges = ["0.0.0.0/0"]

#     # src_secure_tags {
#     #   name = "tagValues/${google_tags_tag_value.basic_value.name}"
#     # }

#     layer4_configs {
#       ip_protocol = "all"
#     }
#   }
# }

# resource "google_compute_network_firewall_policy_association" "association" {
#   name = "association"
#   attachment_target = google_compute_network.vpc_network.id
#   firewall_policy =  google_compute_network_firewall_policy.terraform_firewall_policy.name
#   project =  var.project
# }