DHCP Cookbook
=============
This cookbook installs and configures a DHCP Server.

Requirements
------------
- CentOS, RHEL, Scientific Linux
- Ubuntu

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

Recipes
-------
#### default
Installs DHCP and sets up the core config

Resource/Provider
-----------------

### dhcp_subnet

#### actions

- **add** - adds the subnet
- **remove** - removes the subnet

#### attributes

- **network** - the network
- **netmask** - corresponding netmask for the network
- **options** - array of options

##### unkown attributes
It would be way too much work to maintain an attribute for every
possible option you can pass to subnet so this resource allows the
ability of dynamically creating one.

ex:
```ruby
dhcp_subnet '192.168.134.0' do
  max_lease_time 03430
end
```

The above example would generate the following line in the
actual config.

```
max-lease-time "03430";
```

##### pool block
This resource provides the ability to add pools to a subnet using a
chef like DSL.

ex:
```ruby
dhcp_subnet '192.168.134.0' do
  netmask '255.255.255.0'
  pool 'test1' do
    range '192.168.134.1 192.168.134.128'
    max_lease_time 2888
    options(['routers 192.168.134.254'])
  end
  deny 'unknown-clients'
end
```

### dhcp_host

#### actions

- **add** - adds the host
- **remove** - removes the host

#### attributes

- **physical_address** - the mac address of the host
- **fixed_address** - the ip address of the host
- **options** - Array of options to pass
- **host_name** - Host name of the host (defaults to the resource name)

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
