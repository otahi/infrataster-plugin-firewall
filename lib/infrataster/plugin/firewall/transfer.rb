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
          addresses(@dest_node).each do |a|
            @src_node.server.ssh_exec("ping -c1 -W3 #{a}")
          end
        end

        def addresses(node)
          addrs = nil
          if node.respond_to?(:server)
            addrs = case node.server
                    when respond_to?(:rep_address)
                      node.server.rep_address
                    when respond_to?(:server)
                      node.server.address
                    end
          else
            addrs = node.to_s
          end
          [addrs].flatten
        end
      end
    end
  end
end
