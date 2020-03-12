# Openshift installer for vSphere with Customizations
- ## Customizations list:
    - Static IPs
    - Static MAC address for DHCP reservations
    - Hostname start index at 1 for non bootstrap nodes
    - Hostname no digit at end for bootstrap node
    - Hostnames are FQDN

## To Test
    - conflict error if one of the VMs has an existing MAC address
    - Ignition file errors if any