module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Util
      class Util
        def self.address(node)
          if node.class == Resources::ServerResource
            node.server.address
          else
            node.to_s
          end
        end
      end
    end
  end
end
