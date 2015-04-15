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
          @dest_port = options[:dest_port] ? options[:dest_port] : 80
          @source_port = options[:source_port] ? options[:source_port] : nil
        end

        def reachable?
          case @protocol
          when :ICMP
            icmp_reachable?
          when :TCP, :UDP
            transport_reachable?
          end
        end

        private

        def icmp_reachable?
          dest_addr = Util.address(@dest_node)
          @src_node.server
            .ssh_exec("ping -c1 -W3 #{dest_addr} && echo PING_OK")
            .include?('PING_OK')
        end

        def transport_reachable?
          dest_addr = Util.address(@dest_node)
          bpf_options = { :'dst host' => dest_addr,
                          :'dst port' => @dest_port,
                          @protocol.downcase => nil }
          bpf_options.merge!(:'src port' => @source_port) if @source_port
          bpf = Capture.bpf(bpf_options)
          capture = Capture.new(@dest_node, bpf)
          capture.open do
            nc_option = @protocol == :UDP ? '-u' : '-t'
            nc_option += @source_port ? " -p #{@source_port}" : ''
            @src_node.server
              .ssh_exec("echo test|nc #{dest_addr} #{@dest_port} #{nc_option}")
          end
          capture.result
        end
      end
    end
  end
end
