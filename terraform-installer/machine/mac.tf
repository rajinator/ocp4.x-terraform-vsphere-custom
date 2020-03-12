//locals {
//    mac_addresses = ["${coalescelist(var.macaddrstatic)}"]
//}
//
//data "template_file" "mac_address" {
//  count = "${length(var.macaddrstatic) == 0 ? var.instance_count : 0}"
//  template = "${var.macaddrstatic}"
//}