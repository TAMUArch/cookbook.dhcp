module Dhcp
  module Helpers
    # return dhcp service resource
    def dhcp_service
      name = run_context.node.dhcp.service_name
      run_context.resource_collection.find(service: name)
    end

    def dhcp_user
      run_context.node.dhcp.user
    end

    def dhcp_group
      run_context.node.dhcp.group
    end

    def dhcp_base_dir
      run_context.node.dhcp.dir
    end
  end
end
