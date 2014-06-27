#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2013, Texas A&M
#
# All rights reserved - Do Not Redistribute
#

package node['dhcp']['package_name'] do
  action [:install]
end

template ::File.join(node['dhcp']['dir'], 'dhcpd.conf') do
  source 'dhcpd.conf.erb'
  mode 0655
  group  'root'
  owner  'root'
  notifies :restart, "service[#{node['dhcp']['service_name']}]"
end

%w(dhcpd.hosts.d dhcpd.subnets.d).each do |dir|
  list_path = ::File.join(node['dhcp']['dir'], dir)
  empty_list = ::File.join(list_path, 'list.conf')

  directory list_path do
    action :create
    mode 0655
    group 'root'
    owner 'root'
  end

  file empty_list do
    action :create_if_missing
    mode 0644
    group 'root'
    owner 'root'
  end
end

# Only enabling the dhcp service since attempting to start
# without any subnet configs will result in an error
service node['dhcp']['service_name'] do
  if node.platform == 'ubuntu'
    provider Chef::Provider::Service::Upstart
  end
  action [:enable]
end
