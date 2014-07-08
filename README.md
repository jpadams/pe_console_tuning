pe_console_tuning
=================

This module allows you to tweak a few things in the console, especially Live Management.
The parameter defaults are the same as PE's defaults, so trigger no changes.
The "API" I'm using is spots I've found in the source code where these values are set and are otherwise not managed by Puppet Enterprise. These could change at any time and break this module, so it should not be used in production.

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
####console_timeout:
a value in seconds. After a successful login you have this many seconds before you have to login again.

####facts_array:
the set of 'Common fact names' in the Live Management Advanced Search filter. If you want to put custom values in here, have at it.

####show_certnames_live_mgmt:
if set to *true* causes certnames to be shown by default after performing some Live Management query or action instead of having to unfold each '▸ on 1 node'
