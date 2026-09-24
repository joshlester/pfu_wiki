
# Server Software

## Keepalived
https://www.digitalocean.com/community/tutorials/how-to-set-up-highly-available-web-servers-with-keepalived-and-floating-ips-on-ubuntu-14-04

https://serverfault.com/questions/473058/keepaliveds-virtual-router-id-should-it-be-unique-per-node
Different VRRP instances should have different virtual_router_id values. Same VRRP instances should have the same value.

You can read the following from man keepalived.conf:

arbitary unique number 0..255
used to differentiate multiple instances of vrrpd
running on the same NIC (and hence same socket).
virtual_router_id 51

To summarize, you need to have the same value on the members of same cluster. If you have another cluster, its members should have another value. The virtual_router_id should be unique per VRRP cluster.
