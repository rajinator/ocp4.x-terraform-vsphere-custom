data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${var.datacenter_id}"
}

data "vsphere_network" "network" {
  name          = "${var.network}"
  datacenter_id = "${var.datacenter_id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${var.datacenter_id}"
}

resource "vsphere_virtual_machine" "vm" {
  count = "${var.instance_count}"

  name             = "${var.name == "bootstrap" ? "${var.name}" : "${var.name}${count.index+1}"}"
  resource_pool_id = "${var.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = "${var.num_cpu}"
  num_cores_per_socket = "${var.num_sockets}"
  memory           = "${var.memory}"
  memory_limit     = "${var.memlimit}"
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  folder           = "${var.folder}"
  enable_disk_uuid = "true"

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    use_static_mac = "${ var.usestaticmac == "true" ? "true" : "false" }"
    //uncomment the following line to use static macs, static mac addresses must be specified in tfvars
    mac_address = "${ var.usestaticmac == "true" ? "${var.macaddrstatic[count.index]}" : "" }"
  }

  disk {
    label            = "disk0"
    size             = 120
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  vapp {
    properties {
      "guestinfo.ignition.config.data"          = "${base64encode(data.ignition_config.ign.*.rendered[count.index])}"
      "guestinfo.ignition.config.data.encoding" = "base64"
    }
  }
}
