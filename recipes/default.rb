#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2013, Texas A&M
#
# All rights reserved - Do Not Redistribute
#

package node[:dhcp][:package_name] do
  action [:install]
end

## Assume if empty not managing hosts with databag
unless node[:dhcp][:databag].empty?
  node.set[:dhcp][:hosts] = data_bag_item("domains", node[:dhcp][:databag])["hosts"]
  node.set[:dhcp][:option][:dns_servers] = data_bag_item("domains", node[:dhcp][:databag])["nameservers"] * ", "
  node.set[:dhcp][:option][:domain_name] = data_bag_item("domains", node[:dhcp][:databag])["id"]
  node.set[:dhcp][:pool][:mask] = data_bag_item("domains", node[:dhcp][:databag])["netmask"]
  node.set[:dhcp][:pool][:network] = data_bag_item("domains", node[:dhcp][:databag])["network"] 
  node.set[:dhcp][:pool][:routers] = data_bag_item("domains", node[:dhcp][:databag])["gateway"]
end

template ::File.join(node[:dhcp][:dhcp_dir], 'dhcpd.hosts') do
  source "dhcpd.hosts.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node[:dhcp][:service_name]}]"
end

template ::File.join(node[:dhcp][:dhcp_dir], 'dhcpd.conf') do
  source "dhcpd.conf.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node[:dhcp][:service_name]}]"
end

template ::File.join(node[:dhcp][:dhcp_dir], 'dhcpd.pools') do
  source "dhcpd.pools.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node[:dhcp][:service_name]}]"
end

service node[:dhcp][:service_name] do
  action [:disable, :stop]
end
