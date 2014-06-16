require 'chef/resource'

class Chef
  class Resource
    class DhcpHost < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :dhcp_host
        @provider = Chef::Provider::DhcpHost
        @action = :add
        @allowed_actions = [:add, :remove]
      end

      def physical_address(arg=nil)
        set_or_return(:physical_address,
                      arg,
                      kind_of: String)
      end
      alias :mac_address :physical_address

      def fixed_address(arg=nil)
        set_or_return(:fixed_address,
                      arg,
                      kind_of: String)
      end
      alias :ip_address :fixed_address

      def options(arg=nil)
        set_or_return(:options,
                      arg,
                      kind_of:  Hash,
                      default:  {})
      end

      def host_name(arg=nil)
        set_or_return(:host_name,
                      arg,
                      kind_of: String,
                      name_attribute: true,
                      required: true)
      end
    end
  end
end
