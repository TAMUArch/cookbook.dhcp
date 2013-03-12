#
# Cookbook Name:: dhcp
# Recipe:: default
#
# Copyright 2013, Texas A&M
#
# All rights reserved - Do Not Redistribute
#

# Defaults in attributes set to work with Debian platform
case node["platform_family"]
when "rhel"
  node.set[:dhcp][:package_name] = "dhcp"
  node.set[:dhcp][:service_name] = "dhcpd"
end

# Versions of Ubuntu less than 12.04 use diff dhcp dir
if node["platform"] == "ubuntu" && node["platform_version"] < "12.04"
  node.set[:dhcp][:dhcp_dir] = "/etc/dhcp3"
end

package node["dhcp"]["package_name"] do
  action [:install]
end

## Assume if empty not managing hosts with databag
if !node["databag"]["domains"].empty?
  node.set[:dhcp][:hosts] = data_bag_item("domains", node["databag"]["domains"])["hosts"]
  node.set[:dhcp][:option][:dns_servers] = data_bag_item("domains", node["databag"]["domains"])["nameservers"] * ", "
  node.set[:dhcp][:option][:domain_name] = data_bag_item("domains", node["databag"]["domains"])["id"]
  node.set[:dhcp][:pool][:mask] = data_bag_item("domains", node["databag"]["domains"])["netmask"]
  node.set[:dhcp][:pool][:network] = data_bag_item("domains", node["databag"]["domains"])["network"] 
  node.set[:dhcp][:pool][:routers] = data_bag_item("domains", node["databag"]["domains"])["gateway"]
end

template "#{node["dhcp"]["dhcp_dir"]}/dhcpd.hosts" do
  source "dhcpd.hosts.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node["dhcp"]["service_name"]}]"
end

template "#{node["dhcp"]["dhcp_dir"]}/dhcpd.conf" do
  source "dhcpd.conf.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node["dhcp"]["service_name"]}]"
end

template "#{node["dhcp"]["dhcp_dir"]}/dhcpd.pools" do
  source "dhcpd.pools.erb"
  mode   "0644"
  group  "root"
  owner  "root"
  notifies :restart, "service[#{node["dhcp"]["service_name"]}]"
end

service node["dhcp"]["service_name"] do
  action [:disable, :stop]
end
