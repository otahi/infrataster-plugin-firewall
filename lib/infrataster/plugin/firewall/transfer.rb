module Infrataster
  module Plugin
    # Infrataster plugin for firewall
    module Firewall
      # Represent transfer
      class Transfer
        def initialize(src_node, dest_node, options = {})
          @src_node = src_node
          @dest_node = dest_node
          @protocol = options[:protocol] ? options[:protocol] : :ICMP
        end

        def reachable?
          case @protocol
          when :ICMP then
            icmp_reachable?
          end
        end

        private

        def icmp_reachable?
          true
        end
      end
    end
  end
end
