## Domain Databag
default[:databag][:domains]
default[:dhcp][:hosts]

# DHCP Lease Settings
default[:dhcp][:lease][:default_time] = "3600"
default[:dhcp][:lease][:max_time] = "86400"

#DHCP Conf Options
default[:dhcp][:option][:domain_name]
default[:dhcp][:option][:dns_servers]
default[:dhcp][:option][:ntp_servers]
default[:dhcp][:option][:fqdn_no_client_update] = "on"
default[:dhcp][:option][:fqdn_rcode2] = "255"
default[:dhcp][:option][:pxegrub_code] = "text"

# DHCP Logging
default[:dhcp][:log][:facility]="syslog"

# DHCP Pool
# if no failover peer set assume no failover
default[:dhcp][:pool][:range]
default[:dhcp][:pool][:mask]
default[:dhcp][:pool][:network]
default[:dhcp][:pool][:options]
default[:dhcp][:pool][:failover]
default[:dhcp][:pool][:routers]

# DHCP Failover
# if peer not set assume no failover
default[:dhcp][:failover][:peer] = node["dhcp"]["pool"]["failover"]
default[:dhcp][:failover][:role] = "primary"
default[:dhcp][:failover][:ip_address] = node['ipaddress']
default[:dhcp][:failover][:peer_address]
default[:dhcp][:failover][:port] = "647"
default[:dhcp][:failover][:peer_port] = "647"
default[:dhcp][:failover][:max_response_delay] = "30"
default[:dhcp][:failover][:max_unacked_updates] = "10"
default[:dhcp][:failover][:load_balance] = "3"
default[:dhcp][:failover][:mclt] = "300"
default[:dhcp][:failover][:split] = "128"

# PXE Options
default[:dhcp][:pxe][:server]
default[:dhcp][:pxe][:filename] = "pxelinux.0"

# Package name, dhcp dir, service name
case node[:platform]
when 'debian', 'ubuntu'
  if node[:platform_version] < '12.04'
  default[:dhcp][:package_name] = 'isc-dhcp-server'
when 'rhel', 'centos', 'amazon', 'scientific'

end
default[:dhcp][:package_name] = "isc-dhcp-server"
default[:dhcp][:dhcp_dir] = "/etc/dhcp"
default[:dhcp][:service_name] = "isc-dhcp-server"
