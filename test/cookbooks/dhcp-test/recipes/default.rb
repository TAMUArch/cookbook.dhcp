include_recipe 'dhcp'

dhcp_host 'test.com' do
  action :add
  physical_address '00:00:00:00:4c:56'
  fixed_address '192.168.134.2'
end

dhcp_host 'docker.com' do
  action :add
  physical_address '00:00:00:00:45:57'
  fixed_address '192.168.134.4'
end

dhcp_subnet '192.168.134.0' do
  netmask '255.255.255.0'
  pool 'test1' do
    range '192.168.134.1 192.168.134.128'
    max_lease_time 2888
    options(['routers 192.168.134.254'])
  end

  pool 'test2' do
    #failover 'peer 192.168.134.20'
    range '192.168.134.129 192.168.134.254'
    max_lease_time 03430
  end
  options(['subnet-mask 255.255.255.0'])
  deny "unknown-clients"
end
