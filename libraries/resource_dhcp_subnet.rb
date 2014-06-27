require 'chef/resource'

class Chef
  class Resource
    class DhcpSubnet < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :dhcp_subnet
        @provider = Chef::Provider::DhcpSubnet
        @action = :add
        @allowed_actions = [:add, :remove]
      end

      def network(arg=nil)
        set_or_return(:network,
                      arg,
                      kind_of: String,
                      name_attribute: true,
                      required: true)
      end

      def netmask(arg=nil)
        set_or_return(:netmask,
                      arg,
                      kind_of: String,
                      required: true)
      end

      def options(arg=nil)
        set_or_return(:options,
                      arg,
                      kind_of: Array,
                      default: {})
      end

      # Lazy way of handling every tunable parameter
      def method_missing(m, *args, &block)
        if m.to_s == 'pool'
          unless block.nil?
            Chef::Log.debug "Generating Pool from block"
            new_pool = Chef::Resource::DhcpSubnet::DhcpPool.new
            new_pool.instance_eval &block
            pools.push new_pool.to_hash
          end
        else
          Chef::Log.debug "Generating dynamic resource attribute #{m}"
          if args.length > 1
            raise ArgumentError, "Too many arguments", caller
          else
            val = args.first.to_s
          end
          key = m.to_s
          subnet_options.merge!({key => val})
        end
      end

      def subnet_options
        return @subnet_options unless @subnet_options.nil?
        @subnet_options = {}
        @subnet_options
      end

      def pools
        return @pools unless @pools.nil?
        @pools = []
      end

      class DhcpPool
        attr_reader :options, :range

        # More lazy magic
        def method_missing(m, *args, &block)
          instance_variable_set("@#{m}", args.first.to_s)
        end

        # Some type checking at least
        def options(opts)
          if opts.kind_of? Array
            @options = opts
          else
            raise ArgumentError, "Options must be of type Array", caller
          end
        end

        def range(range)
          @range = range
        end

        # All this object creation just so we can export it back to
        # a hash...
        def to_hash
          if @range.nil?
            raise "Range must be a string not of type nil!!"
          else
            new_hash = {}
            self.instance_variables.each do |var|
              stripped_var = var.to_s.sub!('@', '')
              new_hash.merge!({stripped_var => self.instance_variable_get(var.to_sym)})
            end
            new_hash
          end
        end
      end
    end
  end
end
