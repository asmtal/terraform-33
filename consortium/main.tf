terraform {
  required_version = ">= 0.10.3"
}

resource "freight_consortium" "this" {
  name        = "${var.name}"
  description = "${var.description}"
  mode        = "${var.mode}"
}

resource "freight_environment" "this" {
  count          = "${length(var.environments) > 0 ? length(var.environments) : 0}"
  consortium_id  = "${freight_consortium.this.id}"
  name           = "${element(var.environments, count.index)}"
  description    = "${element(var.environments, count.index)}"
  env_type       = "${var.env_type}"
  consensus_type = "${var.consensus_type}"
}

resource "freight_node" "this" {
  count          = "${var.number_of_nodes}"
  consortium_id  = "${freight_consortium.this.id}"
  environment_id = "${freight_environment.this.*.id}"
  membership_id  = "${freight_membership.this.id}"
  name           = "node-${count.index + 1}"
}


resource "freight_app_key" "this" {
  consortium_id  = "${freight_consortium.this.id}"
  environment_id = "${freight_environment.this.*.id}"
  membership_id  = "${freight_membership.freight.id}"
}
