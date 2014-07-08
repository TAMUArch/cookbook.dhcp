require 'chef/provider'
require 'chef/resource/template'
require 'chef/provider/template'
require_relative 'helpers'

class Chef
  class Provider
    class DhcpHost < Chef::Provider

      include Dhcp::Helpers

      def load_current_resource
        @current_resource ||= Chef::Resource::DhcpHost.new(new_resource.name)
        @current_resource
      end

      def action_add
        conf_file.run_action :create
        if conf_file.updated_by_last_action?
          host_list.run_action :create
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

      def host_list
        return @host_list unless @host_list.nil?
        list_file = ::File.join(dhcp_base_dir,
                                'dhcpd.hosts.d/list.conf')
        @host_list = Chef::Resource::Template.new(list_file, run_context)
        @host_list.mode 0644
        @host_list.cookbook 'dhcp'
        @host_list.source 'list.conf.erb'
        @host_list.variables(dhcp_items: get_list)
        @host_list.group dhcp_group
        @host_list.owner dhcp_user
        @host_list
      end

      def get_list
        resource_list = []
        run_context.resource_collection.each do |resource|
          if resource.is_a?(Chef::Resource::DhcpHost)
            if resource.action.kind_of?(Array)
              action = resource.action
            else
              action = [resource.action]
            end

            if action.include?(:add)
              resource_list.push(::File.join(dhcp_base_dir,
                                             'dhcpd.hosts.d',
                                             "#{resource.host_name}.conf"))
            end
          end
        end
        resource_list
      end

      def conf_name
        return @conf_name unless @conf_name.nil?
        @conf_name = ::File.join(dhcp_base_dir,
                                 'dhcpd.hosts.d',
                                 "#{new_resource.name}.conf")
        @conf_name
      end

      def conf_file
        return @conf_file unless @conf_file.nil?
        @conf_file = Chef::Resource::Template.new(conf_name, run_context)
        @conf_file.mode 0644
        @conf_file.source 'host.conf.erb'
        @conf_file.cookbook 'dhcp'
        @conf_file.variables(
          hostname: new_resource.host_name,
          physical_address: new_resource.physical_address,
          fixed_address: new_resource.fixed_address,
          options: new_resource.options
        )
        @conf_file.group dhcp_group
        @conf_file.owner dhcp_user
        @conf_file
      end
    end
  end
end
