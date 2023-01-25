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
  # https://cloud.google.com/compute/docs/troubleshooting/troubleshooting-ssh-errors?hl=es-419
  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
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

# resource "google_compute_project_metadata" "default" {
#   metadata = {
#     ssh-keys = <<EOF
#       david@DESKTOP-PV0N8VQ: ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoprEIP4QOtluMzZS+wFG+89GXI8qgDhK0y0bKEJndjtlLNpXrDXmvZv9+2B05ZjnVn8atgHF8uF7cjyyDt4R0jbKIpA7ndUMfo99Nxc2C9D5ReKXAFVKjsnwBxowQ3lG8sRlKRxhev/3OyrEMaCrvDB6Qk7ghKC8gttrMAyc+qfMKSL0TXnAQd+lsKlHsEParZH2tj2EMcEuYge5hlVnvTSL9wb11g98ojxkEETrd2ZtsP5mN63Yc8VFs1FQcBkgMtYO6FHzWI8dyG6/a2VqTH9d80cHlWf16DaHlt1NJeEOYr/WQ0PKVo5ZI4nCPYGHYXFfuwPBLdT4A/75t/nlhFPkx7lIliRrsFzsVICssrf35Bp9yhBFaAQe+v8jTpplq8/sPr/DLKQ1+IHYzjWnIspOLt3D+k/F6AfI+tiTZCksuP6sAcjcNcGMdUO3OkFwtlGGWlfLBJ+EWi+nwbfUtY7/GYhC0V5SWwFtYmuHPwVbm9uvzTnyfYzCUmju04WdXeHOppR/plh2zahHlTZokM2TOPq9sh8GxR2x6k/b3IpY2XZOk4L1l+D8EoLC0UgIgcsW6J/DBrKfVXrVn7QJjYii/or4uF8/PYmHF6E00MRYQjB5vyYiROUL01cuvWjvwkm/SiEvFBzlktG/DIObrTGpxS8//z3936hhlJqNfHw== david@DESKTOP-PV0N8VQ
      
#       EOF
#   }
# }



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