require 'chef/provider'
require 'chef/resource/template'
require 'chef/provider/template'
require_relative 'helpers'

class Chef
  class Provider
    class DhcpSubnet < Chef::Provider

      include Dhcp::Helpers

      def load_current_resource
        @current_resource ||= Chef::Resource::DhcpSubnet.new(new_resource.name)
        @current_resource
      end

      def action_add
        conf_file.run_action :create
        if conf_file.updated_by_last_action?
          subnet_list.run_action :create
          new_resource.notifies(:restart, dhcp_service, :delayed)
          new_resource.updated_by_last_action true
        else
          new_resource.updated_by_last_action false
        end
      end

      def action_remove
        if ::File.exist? conf_name
          conf_file.run_action :remove
          new_resource.updated_by_last_action true
        else
          new_resource.updated_by_last_action false
        end
      end

      def subnet_list
        return @subnet_list unless @subnet_list.nil?
        list_file = ::File.join(dhcp_base_dir,
                                'dhcpd.subnets.d/list.conf')
        @subnet_list = Chef::Resource::Template.new(list_file, run_context)
        @subnet_list.mode 0644
        @subnet_list.cookbook 'dhcp'
        @subnet_list.source 'list.conf.erb'
        @subnet_list.variables(dhcp_items: get_list)
        @subnet_list.group dhcp_group
        @subnet_list.owner dhcp_user
        @subnet_list
      end

      def get_list
        resource_list = []
        run_context.resource_collection.each do |resource|
          if resource.is_a?(Chef::Resource::DhcpSubnet) && resource.action == :add
            resource_list.push(::File.join(dhcp_base_dir,
                                           'dhcpd.subnets.d',
                                           "#{resource.network}.conf"))
          end
        end
        resource_list
      end

      def conf_name
        return @conf_name unless @conf_name.nil?
        @conf_name = ::File.join(dhcp_base_dir,
                                 'dhcpd.subnets.d',
                                 "#{new_resource.network}.conf")
      end

      def conf_file
        return @conf_file unless @conf_file.nil?
        @conf_file = Chef::Resource::Template.new(conf_name, run_context)
        @conf_file.mode 0644
        @conf_file.source 'subnet.conf.erb'
        @conf_file.cookbook 'dhcp'
        @conf_file.variables(
          pools: new_resource.pools,
          network: new_resource.network,
          netmask: new_resource.netmask,
          options: new_resource.options,
          subnet_options: new_resource.subnet_options
        )
        @conf_file.group dhcp_group
        @conf_file.owner dhcp_user
        @conf_file
      end
    end
  end
end
