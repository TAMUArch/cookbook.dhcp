DHCP Cookbook
=============
This cookbook installs and configures a DHCP Server.  This cookbook can work directly with our Bind cookbook allowing the use of a single data bag to store all of your network information.

Requirements
------------
This cookbook has only been tested and used with Ubuntu 12.04.


Attributes
----------
#### dhcp::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['databag']['domains']</tt></td>
    <td>String</td>
    <td>A domains databag to use with this cookbook.  Not required.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['dhcp']['option']['domain_name']</tt></td>
    <td>String</td>
    <td>Default domain name for dhcp</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['dhcp']['option']['dns_servers']</tt></td>
    <td>Array</td>
    <td>List of dns servers</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['dhcp']['option']['ntp_servers']</tt></td>
    <td>Array</td>
    <td>List of ntp servers</td>
    <td><tt></tt></td>
  </tr>
</table>

Usage
-----
#### dhcp::default

Include dhcp in your run list and set the above defaults in your node definition.

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dhcp]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Jim Rosser 
