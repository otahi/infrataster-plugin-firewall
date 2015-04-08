module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Represent transfer
      class Transfer
        def initialize(src_node, dest_node, protocol)
          @src_node = src_node
          @dest_node = dest_node
          @protocol = protocol
        end

        def reachable?
          true
        end
      end
    end
  end
end
