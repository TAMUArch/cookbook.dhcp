default['dhcp']['authoratative'] = true
default['dhcp']['lease']['default_time'] = 3600
default['dhcp']['lease']['max_time'] = 86400

#DHCP Conf Options
default['dhcp']['options']['domain-name'] = "\"#{node['domain']}\""
default['dhcp']['options']['fqdn.no-client-update'] = 'on'
default['dhcp']['options']['fqdn.rcode2'] = 255
default['dhcp']['options']['pxegrub code'] = '150 = text'

# DHCP Logging
default['dhcp']['log']['facility'] = 'syslog'

# DHCP Failover
# if peer not set assume no failover
default['dhcp']['failover']['peer']
default['dhcp']['failover']['role'] = 'primary'
default['dhcp']['failover']['ip_address'] = node['ipaddress']
default['dhcp']['failover']['peer_address']
default['dhcp']['failover']['port'] = 647
default['dhcp']['failover']['peer_port'] = 647
default['dhcp']['failover']['max_response_delay'] = 30
default['dhcp']['failover']['max_unacked_updates'] = 10
default['dhcp']['failover']['load_balance'] = 3
default['dhcp']['failover']['mclt'] = 300
default['dhcp']['failover']['split'] = 128

# PXE Options
default['dhcp']['pxe']['server']
default['dhcp']['pxe']['filename'] = 'pxelinux.0'

# Package name, dhcp dir, service name
case node['platform']
when 'debian', 'ubuntu'
  default['dhcp']['package_name'] = 'isc-dhcp-server'
  default['dhcp']['service_name'] = 'isc-dhcp-server'
  if node['platform_version'] >= "14.04"
    default['dhcp']['user'] = 'dhcpd'
    default['dhcp']['group'] = 'dhcpd'
  else
    default['dhcp']['user'] = 'root'
    default['dhcp']['group'] = 'root'
  end
  default['dhcp']['dir'] = '/etc/dhcp'
when 'rhel', 'centos', 'amazon', 'scientific'
  default['dhcp']['user'] = 'root'
  default['dhcp']['group'] = 'root'
  default['dhcp']['package_name'] = 'dhcp'
  default['dhcp']['service_name'] = 'dhcpd'
  default['dhcp']['dir'] = '/etc/dhcp'
end
