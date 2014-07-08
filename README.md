pe_console_tuning
=================

This module allows you to tweak a few things in the console, especially Live Management.
The parameter defaults are the same as PE's defaults, so trigger no changes.

Here's the module's parameter interface:
```puppet
class pe_console_tuning (
  $console_timeout = 1200,
  $facts_array = ["architecture", "domain", "fqdn", "hardwaremodel", "hostname", "ipaddress",
                  "is_virtual", "manufacturer", "memorytotal", "operatingsystem",
                  "operatingsystemrelease", "physicalprocessorcount", "processorcount",
                  "productname", "puppetversion"],
  $show_certnames_live_mgmt = false
)
```
*console_timeout* is a value in seconds. After a successful login you have this many seconds before y
ou have to login again.

*facts_array* is the set of facts in the Live Management Advanced filter. If you want to put custom v
alues in here, have at it.

*show_certnames_live_mgmt* causes certnames to be shown by default after performing some Live Managem
ent query or action instead of of having to unfold each '▶ on 1 node'
