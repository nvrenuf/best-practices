#--------------------------------------------------------------
# This module creates all resources necessary for a Bastion
# host
#--------------------------------------------------------------

variable "name"              { }
variable "zones"				 { }
variable "public_subnet_names" { }
variable "image" 			 { }
variable "instance_type"     { }

resource "google_compute_instance" "bastion" {
  name         = "${var.name}"
  machine_type = "${var.instance_type}"
  zone         = "${element(split(",", var.zones), 0)}"

  disk {
    image = "${var.image}"
  }

  network_interface {
    subnetwork = "${element(split(",", var.public_subnet_names), 0)}"

    access_config {
      # ephemeral
    }
  }
}

output "private_ip" {
  value = "${google_compute_instance.bastion.network_interface.0.address}"
}

output "public_ip" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.assigned_nat_ip}"
}