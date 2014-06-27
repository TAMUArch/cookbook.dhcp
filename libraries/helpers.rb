module Dhcp
  module Helpers
    # return dhcp service resource
    def dhcp_service
      name = run_context.node.dhcp.service_name
      run_context.resource_collection.find(service: name)
    end

    def dhcp_base_dir
      run_context.node.dhcp.dir
    end
  end
end
